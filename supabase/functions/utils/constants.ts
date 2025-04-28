export const OPENAI_CONSTANTS = {
	// OpenAIモデル設定
	CHAT_MODEL: "gpt-4.1-mini",
	EMBEDDING_MODEL: "text-embedding-3-small",

	// 類似メッセージ検索設定
	SIMILARITY_THRESHOLD: 0.4, // gptおすすめ
	MATCH_COUNT: 3,

	// システムメッセージ
	SYSTEM_MESSAGE:
		"あなたは、ギャンブル依存に悩む人の話を親身になって聞くAIです。" +
		"ユーザーが自分の気持ちや状況を安心して話せるように、やさしく、共感を持って対応してください。" +
		"一緒に考えたり、気づきを促したりするような、自然な対話を心がけてください。" +
		"過去の会話も参考にして、一貫性のあるサポートを行ってください。",
} as const;
