-- For vector operations
create extension if not exists vector;


-- チャット履歴テーブルの作成
create table chat_messages (
  id uuid default uuid_generate_v4() primary key,
  -- user_id uuid references auth.users(id),
  content text not null,
  is_user boolean not null,
	embedding vector(1536),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- RLSポリシーの設定
-- alter table chat_history enable row level security;
-- create policy "ユーザーは自分のチャット履歴のみアクセス可能" 
-- on chat_history for all 
-- using (auth.uid() = user_id);

-- ベクトル検索用のインデックスを作成
create index chat_messages_embedding_idx 
on chat_messages 
using ivfflat (embedding vector_cosine_ops)
with (lists = 100);

-- 類似度検索用の関数
create or replace function match_messages (
  query_embedding vector(1536),
  similarity_threshold float,
  match_count int
  -- user_id_input uuid
)
returns table (
  content text,
  is_user boolean,
  similarity float
)
language plpgsql
as $$
begin
  return query
  select
    chat_messages.content,
    chat_messages.is_user,
    1 - (chat_messages.embedding <=> query_embedding) as similarity
  from chat_messages
  where chat_messages.embedding <=> query_embedding < 1 - similarity_threshold
  order by chat_messages.embedding <=> query_embedding
  limit match_count;
end;
$$;
