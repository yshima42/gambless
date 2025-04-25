export const OPENAI_CONSTANTS = {
	// OpenAIモデル設定
	CHAT_MODEL: "gpt-3.5-turbo",
	EMBEDDING_MODEL: "text-embedding-3-small",

	// 類似メッセージ検索設定
	SIMILARITY_THRESHOLD: 0.4, // gptおすすめ
	MATCH_COUNT: 3,

	// システムメッセージ
	SYSTEM_MESSAGE:
		"あなたはギャンブル依存症の克服をサポートするAIアシスタントです。" +
		"以下の関連する過去の会話を参考に、ユーザーの文脈を理解し、" +
		"共感的で建設的なアドバイスを提供してください。",
} as const;
