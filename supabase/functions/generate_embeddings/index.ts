// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
// import { Configuration, OpenAIApi } from "https://esm.sh/openai@3.1.0";
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { _OpenAiApiKey_ } from "../utils/config.ts";
import { supabaseClient } from "../utils/supabase.ts";

Deno.serve(async (_) => {
  const { data } = await supabaseClient.from("chat_messages").select(
    "*",
  ); // Your custom function to load docs

  // Assuming each document is a string
  for (const message of data) {
    // OpenAI recommends replacing newlines with spaces for best results
    const input = message.content.replace(/\n/g, " ");
    // console.log(input);
    console.log("OpenAI API Key:", _OpenAiApiKey_);

    const embeddingResponse = await fetch(
      "https://api.openai.com/v1/embeddings",
      {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${_OpenAiApiKey_}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "text-embedding-3-small",
          input,
        }),
      },
    );
    const resJson = await embeddingResponse.json(); // ← ここ追加！

    const [{ embedding }] = resJson.data;

    await supabaseClient.from("chat_messages").update({
      embedding,
    }).eq("id", message.id);
  }

  return new Response(
    JSON.stringify({ message: "Embeddings generated" }),
    { headers: { "Content-Type": "application/json" } },
  );
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/generate_embeddings' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
