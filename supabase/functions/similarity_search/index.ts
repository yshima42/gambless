// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

import { serve } from "https://deno.land/std@0.170.0/http/server.ts";
import "https://deno.land/x/xhr@0.2.1/mod.ts";
import {
  Configuration,
  OpenAIApi,
} from "https://esm.sh/openai@3.1.0?deps=axios@1.6.8";
import { _OpenAiApiKey_ } from "../utils/config.ts";
import { supabaseClient } from "../utils/supabase.ts";

export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // Handle CORS
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // Search query is passed in request payload
  const { query } = await req.json();

  // OpenAI recommends replacing newlines with spaces for best results
  const input = query.replace(/\n/g, " ");

  const configuration = new Configuration({ apiKey: _OpenAiApiKey_ });
  const openai = new OpenAIApi(configuration);

  // Generate a one-time embedding for the query itself
  const embeddingResponse = await openai.createEmbedding({
    model: "text-embedding-3-small",
    input,
  });

  const [{ embedding }] = embeddingResponse.data.data;
  console.log(embedding);

  // In production we should handle possible errors
  const { data: documents, error: error } = await supabaseClient.rpc(
    "match_messages",
    {
      query_embedding: embedding,
      similarity_threshold: 0.3, // Choose an appropriate threshold for your data
      match_count: 10, // Choose the number of matches
    },
  );
  console.log(documents);
  console.log(error);
  return new Response(JSON.stringify(documents), {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/similarity_search' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
