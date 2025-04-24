// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import OpenAI from "https://deno.land/x/openai@v4.24.0/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

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
    // 1. リクエストから現在のメッセージを取得
    const { messages } = await req.json();
    // messages配列の最後の要素が現在のユーザーメッセージ
    const currentMessage = messages[messages.length - 1]?.content;
    if (!currentMessage) {
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
      // similarity_searchと同じモデルを使用
      model: "text-embedding-3-small",
      input: currentMessage,
    });
    const currentEmbedding = embeddingResponse.data[0].embedding;

    // 6. 類似メッセージを検索 (match_messages関数を呼び出す)
    // 注意: match_messages関数にuser_id_inputが必要な場合は、SQLと引数を修正してください
    const { data: relevantHistory, error: rpcError } = await supabaseClient.rpc(
      "match_messages",
      {
        query_embedding: currentEmbedding,
        similarity_threshold: 0.3, // similarity_searchの設定に合わせる
        match_count: 10, // 取得する関連メッセージ数（調整可能）
        // user_id_input: userId // match_messages関数がuser_idを要求する場合
      },
    );

    console.log(relevantHistory);

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
      content:
        "あなたはギャンブル依存症の克服をサポートするAIアシスタントです。" +
        "以下の関連する過去の会話を参考に、ユーザーの文脈を理解し、" +
        "共感的で建設的なアドバイスを提供してください。",
    };

    const allMessages = [
      systemMessage,
      ...historyMessages.reverse(), // 新しい順で取得されるため、古い順に並び替える
      { role: "user", content: currentMessage },
    ];

    // 9. OpenAI Chat Completion APIを呼び出す
    const chatCompletion = await openai.chat.completions.create({
      messages: allMessages,
      model: "gpt-3.5-turbo", // 使用するモデル
      stream: false,
    });

    const reply = chatCompletion.choices[0].message.content;
    if (!reply) {
      throw new Error("OpenAI did not return a reply.");
    }

    // 10. AIの返信の埋め込みベクトルを生成
    const replyEmbeddingResponse = await openai.embeddings.create({
      model: "text-embedding-3-small",
      input: reply,
    });
    const replyEmbedding = replyEmbeddingResponse.data[0].embedding;

    // 11. 新しいメッセージと返信をデータベースに保存
    // 注意: chat_messagesテーブルにuser_idカラムが必要です
    const { error: insertError } = await supabaseClient.from("chat_messages")
      .insert([
        {
          // user_id: userId, // user_idカラムがある場合
          content: currentMessage,
          is_user: true,
          embedding: currentEmbedding,
        },
        {
          // user_id: userId, // user_idカラムがある場合
          content: reply,
          is_user: false,
          embedding: replyEmbedding,
        },
      ]);

    if (insertError) {
      console.error("Insert Error:", insertError);
      // エラーが発生しても、ユーザーには返信する（エラー処理は改善の余地あり）
    }

    // 12. AIの返信を返す
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
    --data '{"name":"Functions"}'

*/
