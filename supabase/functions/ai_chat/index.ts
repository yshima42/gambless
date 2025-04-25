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
      content: `(過去の関連メッセージ) ${msg.content}`,
    }));

    // 8. OpenAIに送信するメッセージリストを構築
    const systemMessage = {
      role: "system",
      content: OPENAI_CONSTANTS.SYSTEM_MESSAGE,
    };

    const allMessages = [
      systemMessage,
      ...historyMessages,
      { role: "system", content: "--- ここから現在の会話 ---" },
      ...(history || []),
      { role: "user", content: message },
    ];

    console.log("allMessages", allMessages);

    // 9. OpenAI Chat Completion APIを呼び出す
    const chatCompletion = await openai.chat.completions.create({
      messages: allMessages,
      model: OPENAI_CONSTANTS.CHAT_MODEL,
      stream: true,
    });

    // 10. ストリームを分岐させる
    const stream = chatCompletion.toReadableStream();
    const [stream1, stream2] = stream.tee();

    // 11. DB保存処理を非同期で実行する関数
    //    ストリームの完了を待ってメッセージと返信をDBに保存する
    const saveToDatabase = async () => {
      let fullReply = "";
      const reader = stream2.getReader();
      const decoder = new TextDecoder();

      try {
        while (true) {
          const { done, value } = await reader.read();

          if (done) {
            break;
          }
          if (!value || value.length === 0) {
            continue;
          }

          const chunk = decoder.decode(value, { stream: true });
          // ストリーミングデータの解析 (OpenAIのSSE形式に依存)
          const lines = chunk.split("\n");
          for (const line of lines) {
            // 空行は無視
            if (!line.trim()) {
              // console.log("Skipping empty line.");
              continue;
            }

            try {
              // 直接JSONとしてパース
              const parsed = JSON.parse(line);

              if (parsed.choices && parsed.choices[0]?.delta?.content) {
                const contentPiece = parsed.choices[0].delta.content;
                fullReply += contentPiece;
              }
            } catch (e) {
              console.error("Error parsing JSON line:", e, "Line:", line);
            }
          }
        }

        // ストリーム完了後、DBに保存 (返信が空でない場合)
        if (fullReply.trim()) {
          console.log("inserting to db");
          const { error: insertError } = await supabaseClient.from(
            "chat_messages",
          )
            .insert([
              {
                content: fullReply, // AIの完全な返信
                is_user: false,
              },
            ]).select(); // select() を追加して挿入結果を確認 (任意)

          if (insertError) {
            console.error("Insert Error after stream:", insertError);
            // 必要に応じてエラーハンドリングを追加
          } else {
            console.log(
              "Messages inserted successfully after stream completion.",
            );
          }
        } else {
          console.log("Skipping DB insert for empty reply.");
        }
      } catch (error) {
        console.error("Error reading stream or saving to DB:", error);
      } finally {
        // リーダーがロックされているか確認してから解放
        try {
          reader.releaseLock();
        } catch (_) {
          // すでに解放されている場合は無視
        }
      }
    };

    // DB保存処理を開始 (クライアントへのレスポンスをブロックしない)
    saveToDatabase().catch(console.error); // 非同期処理のエラーをキャッチ

    // 12. AIの返信ストリームをクライアントに返す (分岐した一方のストリームを使用)
    return new Response(stream1, {
      headers: { ...corsHeaders, "Content-Type": "text/event-stream" },
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
