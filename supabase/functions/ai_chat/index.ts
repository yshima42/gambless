// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import OpenAI from "https://deno.land/x/openai@v4.24.0/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { OPENAI_CONSTANTS } from "../utils/constants.ts";

export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  // Handle CORS preflight request
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // 1. リクエストから現在のメッセージと履歴を取得
    const { history, message } = await req.json();

    if (!message) {
      throw new Error("Message content is missing");
    }

    // 2. 環境変数を取得
    const apiKey = Deno.env.get("OPENAI_API_KEY");
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!apiKey || !supabaseUrl || !supabaseServiceRoleKey) {
      throw new Error("Missing environment variables");
    }

    // 3. クライアントを初期化
    const openai = new OpenAI({ apiKey });
    // データベース操作のためにService Role Keyを使用
    const supabaseClient = createClient(
      supabaseUrl,
      supabaseServiceRoleKey,
      // Edge Functionsではセッション永続化を無効にする必要がある
      { auth: { persistSession: false } },
    );

    // // 4. ユーザー認証 (Authorizationヘッダーからトークンを取得)
    // const authHeader = req.headers.get("Authorization");
    // if (!authHeader) {
    //   throw new Error("Missing authorization header");
    // }
    // const token = authHeader.split(" ")[1];
    // const { data: { user }, error: userError } = await supabaseClient.auth
    //   .getUser(token);

    // if (userError || !user) {
    //   console.error("User auth error:", userError);
    //   throw new Error("Unauthorized: Failed to get user");
    // }
    // const userId = user.id;

    // 5. 現在のメッセージの埋め込みベクトルを生成
    const embeddingResponse = await openai.embeddings.create({
      model: OPENAI_CONSTANTS.EMBEDDING_MODEL,
      input: message,
    });
    const currentEmbedding = embeddingResponse.data[0].embedding;

    // 6. 類似メッセージを検索
    const { data: relevantHistory, error: rpcError } = await supabaseClient.rpc(
      "match_messages",
      {
        query_embedding: currentEmbedding,
        similarity_threshold: OPENAI_CONSTANTS.SIMILARITY_THRESHOLD,
        match_count: OPENAI_CONSTANTS.MATCH_COUNT,
      },
    );

    console.log("relevantHistory", relevantHistory);

    if (rpcError) {
      console.error("RPC Error:", rpcError);
      throw new Error(`Failed to match messages: ${rpcError.message}`);
    }

    // 7. 関連履歴をOpenAIのフォーマットに変換
    const historyMessages = (relevantHistory || []).map((
      msg: { content: string; is_user: boolean },
    ) => ({
      role: msg.is_user ? "user" : "assistant",
      content: msg.content,
    }));

    // 8. OpenAIに送信するメッセージリストを構築
    const systemMessage = {
      role: "system",
      content: OPENAI_CONSTANTS.SYSTEM_MESSAGE,
    };

    const allMessages = [
      systemMessage,
      ...historyMessages,
      ...(history || []), // フロントから送られてきた会話履歴も追加
      { role: "user", content: message },
    ];

    console.log("allMessages", allMessages);

    // 9. OpenAI Chat Completion APIを呼び出す
    const chatCompletion = await openai.chat.completions.create({
      messages: allMessages,
      model: OPENAI_CONSTANTS.CHAT_MODEL,
      stream: false,
    });

    const reply = chatCompletion.choices[0].message.content;
    if (!reply) {
      throw new Error("OpenAI did not return a reply.");
    }

    // 10. 新しいメッセージと返信をデータベースに保存
    const { error: insertError } = await supabaseClient.from("chat_messages")
      .insert([
        {
          content: message,
          is_user: true,
        },
        {
          content: reply,
          is_user: false,
        },
      ]);

    if (insertError) {
      console.error("Insert Error:", insertError);
      // エラーが発生しても、ユーザーには返信する（エラー処理は改善の余地あり）
    }

    // 11. AIの返信を返す
    return new Response(reply, {
      headers: { ...corsHeaders, "Content-Type": "text/plain" },
    });
  } catch (error) {
    console.error("Error in OpenAI function:", error);
    return new Response(JSON.stringify({ error: error }), {
      status: error instanceof Error && error.message.includes("Unauthorized")
        ? 401
        : 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/openai' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"message":"こんにちは", "history":[]}'

*/
