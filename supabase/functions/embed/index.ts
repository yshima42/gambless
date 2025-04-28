// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

// We'll use the OpenAI API to generate embeddings
import OpenAI from "jsr:@openai/openai";

import { z } from "npm:zod";

// We'll make a direct Postgres connection to update the document
import postgres from "https://deno.land/x/postgresjs@v3.4.5/mod.js";

// Initialize OpenAI client
const openai = new OpenAI({
  // We'll need to manually set the `OPENAI_API_KEY` environment variable
  apiKey: Deno.env.get("OPENAI_API_KEY"),
});

// Initialize Postgres client
const sql = postgres(
  // `SUPABASE_DB_URL` is a built-in environment variable
  Deno.env.get("SUPABASE_DB_URL")!,
);

const jobSchema = z.object({
  jobId: z.number(),
  id: z.string(),
  schema: z.string(),
  table: z.string(),
  contentFunction: z.string(),
  embeddingColumn: z.string(),
});

const failedJobSchema = jobSchema.extend({
  error: z.string(),
});

type Job = z.infer<typeof jobSchema>;
type FailedJob = z.infer<typeof failedJobSchema>;

type Row = {
  id: string;
  content: unknown;
};

const QUEUE_NAME = "embedding_jobs";

// Listen for HTTP requests
Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("expected POST request", { status: 405 });
  }

  if (req.headers.get("content-type") !== "application/json") {
    return new Response("expected json body", { status: 400 });
  }

  const body = await req.json();
  console.log("start embed \n", body);
  // Use Zod to parse and validate the request body
  const parseResult = z.array(jobSchema).safeParse(body);

  if (parseResult.error) {
    console.log(parseResult.error);
    return new Response(`invalid request body: ${parseResult.error.message}`, {
      status: 400,
    });
  }

  const pendingJobs = parseResult.data;

  // Track jobs that completed successfully
  const completedJobs: Job[] = [];

  // Track jobs that failed due to an error
  const failedJobs: FailedJob[] = [];

  async function processJobs() {
    let currentJob: Job | undefined;

    while ((currentJob = pendingJobs.shift()) !== undefined) {
      try {
        await processJob(currentJob);
        completedJobs.push(currentJob);
      } catch (error) {
        failedJobs.push({
          ...currentJob,
          error: error instanceof Error ? error.message : JSON.stringify(error),
        });
      }
    }
  }

  try {
    // Process jobs while listening for worker termination
    await Promise.race([processJobs(), catchUnload()]);
  } catch (error) {
    // If the worker is terminating (e.g. wall clock limit reached),
    // add pending jobs to fail list with termination reason
    failedJobs.push(
      ...pendingJobs.map((job) => ({
        ...job,
        error: error instanceof Error ? error.message : JSON.stringify(error),
      })),
    );
  }

  // Log completed and failed jobs for traceability
  console.log("finished processing jobs:", {
    completedJobs: completedJobs.length,
    failedJobs: failedJobs.length,
  });

  return new Response(
    JSON.stringify({
      completedJobs,
      failedJobs,
    }),
    {
      // 200 OK response
      status: 200,

      // Custom headers to report job status
      headers: {
        "content-type": "application/json",
        "x-completed-jobs": completedJobs.length.toString(),
        "x-failed-jobs": failedJobs.length.toString(),
      },
    },
  );
});

/**
 * Generates an embedding for the given text.
 */
async function generateEmbedding(text: string) {
  const response = await openai.embeddings.create({
    model: "text-embedding-3-small",
    input: text,
  });
  const [data] = response.data;

  if (!data) {
    throw new Error("failed to generate embedding");
  }

  return data.embedding;
}

/**
 * Processes an embedding job.
 */
async function processJob(job: Job) {
  const { jobId, id, schema, table, contentFunction, embeddingColumn } = job;

  // Fetch content for the schema/table/row combination
  const [row]: [Row] = await sql`
    select
      id,
      ${sql(contentFunction)}(t) as content
    from
      ${sql(schema)}.${sql(table)} t
    where
      id = ${id}
  `;

  if (!row) {
    throw new Error(`row not found: ${schema}.${table}/${id}`);
  }

  if (typeof row.content !== "string") {
    throw new Error(
      `invalid content - expected string: ${schema}.${table}/${id}`,
    );
  }

  const embedding = await generateEmbedding(row.content);

  await sql`
    update
      ${sql(schema)}.${sql(table)}
    set
      ${sql(embeddingColumn)} = ${JSON.stringify(embedding)}
    where
      id = ${id}
  `;

  await sql`
    select pgmq.delete(${QUEUE_NAME}, ${jobId}::bigint)
  `;
}

/**
 * Returns a promise that rejects if the worker is terminating.
 */
function catchUnload() {
  return new Promise((reject) => {
    // deno-lint-ignore no-explicit-any
    addEventListener("beforeunload", (ev: any) => {
      reject(new Error(ev.detail?.reason));
    });
  });
}
