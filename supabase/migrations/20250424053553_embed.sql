-- For vector operations
create extension if not exists vector
with
  schema extensions;

create extension if not exists "uuid-ossp"
with
  schema extensions;

-- For queueing and processing jobs
-- (pgmq will create its own schema)
create extension if not exists pgmq;

-- For async HTTP requests
create extension if not exists pg_net
with
  schema extensions;

-- For scheduled processing and retries
-- (pg_cron will create its own schema)
create extension if not exists pg_cron;

-- For clearing embeddings during updates
create extension if not exists hstore
with
  schema extensions;
-- Schema for utility functions
create schema util;

-- Utility function to get the Supabase project URL (required for Edge Functions)
create function util.project_url()
returns text
language plpgsql
security definer
as $$
declare
  secret_value text;
begin
  -- Retrieve the project URL from Vault
  select decrypted_secret into secret_value from vault.decrypted_secrets where name = 'project_url';
  return secret_value;
end;
$$;

-- Generic function to invoke any Edge Function
create or replace function util.invoke_edge_function(
  name text,
  body jsonb,
  timeout_milliseconds int = 5 * 60 * 1000  -- default 5 minute timeout
)
returns void
language plpgsql
as $$
declare
  headers_raw text;
  auth_header text;
begin
  -- If we're in a PostgREST session, reuse the request headers for authorization
  headers_raw := current_setting('request.headers', true);

  -- Only try to parse if headers are present
  auth_header := case
    when headers_raw is not null then
      (headers_raw::json->>'authorization')
    else
      null
  end;

  -- Perform async HTTP request to the edge function
  perform net.http_post(
    url => util.project_url() || '/functions/v1/' || name,
    headers => jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', auth_header
    ),
    body => body,
    timeout_milliseconds => timeout_milliseconds
  );
end;
$$;

-- Generic trigger function to clear a column on update
create or replace function util.clear_column()
returns trigger
language plpgsql as $$
declare
    clear_column text := TG_ARGV[0];
begin
    NEW := NEW #= hstore(clear_column, NULL);
    return NEW;
end;
$$;

-- Queue for processing embedding jobs
select pgmq.create('embedding_jobs');

-- Generic trigger function to queue embedding jobs
create or replace function util.queue_embeddings()
returns trigger
language plpgsql
security definer
as $$
declare
  content_function text = TG_ARGV[0];
  embedding_column text = TG_ARGV[1];
begin
  perform pgmq.send(
    queue_name => 'embedding_jobs',
    msg => jsonb_build_object(
      'id', NEW.id,
      'schema', TG_TABLE_SCHEMA,
      'table', TG_TABLE_NAME,
      'contentFunction', content_function,
      'embeddingColumn', embedding_column
    )
  );
  return NEW;
end;
$$;

-- Function to process embedding jobs from the queue
create or replace function util.process_embeddings(
  batch_size int = 10,
  max_requests int = 10,
  timeout_milliseconds int = 5 * 60 * 1000 -- default 5 minute timeout
)
returns void
language plpgsql
as $$
declare
  job_batches jsonb[];
  batch jsonb;
begin
  with
    -- First get jobs and assign batch numbers
    numbered_jobs as (
      select
        message || jsonb_build_object('jobId', msg_id) as job_info,
        (row_number() over (order by 1) - 1) / batch_size as batch_num
      from pgmq.read(
        queue_name => 'embedding_jobs',
        vt => timeout_milliseconds / 1000,
        qty => max_requests * batch_size
      )
    ),
    -- Then group jobs into batches
    batched_jobs as (
      select
        jsonb_agg(job_info) as batch_array,
        batch_num
      from numbered_jobs
      group by batch_num
    )
  -- Finally aggregate all batches into array
  select array_agg(batch_array)
  from batched_jobs
  into job_batches;

  -- Invoke the embed edge function for each batch
  foreach batch in array job_batches loop
    perform util.invoke_edge_function(
      name => 'embed',
      body => batch,
      timeout_milliseconds => timeout_milliseconds
    );
  end loop;
end;
$$;

-- Schedule the embedding processing
select
  cron.schedule(
    'process-embeddings',
    '10 seconds',
    $$
    select util.process_embeddings();
    $$
  );

-- チャット履歴テーブルの作成
create table public.chat_messages (
  id uuid default extensions.uuid_generate_v4() primary key,
  -- user_id uuid references auth.users(id),
  content text not null,
  is_user boolean not null,
	embedding extensions.halfvec(1536),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- RLSポリシーの設定
-- alter table chat_history enable row level security;
-- create policy "ユーザーは自分のチャット履歴のみアクセス可能" 
-- on chat_history for all 
-- using (auth.uid() = user_id);

-- ベクトル検索用のインデックスを作成
-- 注意: インデックス作成時の演算子クラス (halfvec_cosine_ops) は通常スキーマ修飾不要ですが、
-- もしエラーが続く場合は extensions.halfvec_cosine_ops を試してください。
create index on public.chat_messages using hnsw (embedding extensions.halfvec_cosine_ops);

-- Customize the input for embedding generation
-- e.g. Concatenate title and content with a markdown header
create or replace function public.embedding_input(message public.chat_messages)
returns text
language plpgsql
immutable
as $$
begin
  return '# ' || message.content;
end;
$$;

-- Trigger for insert events
create trigger embed_messages_on_insert
  after insert
  on public.chat_messages
  for each row
  execute function util.queue_embeddings('public.embedding_input', 'embedding');

-- Trigger for update events
create trigger embed_messages_on_update
  after update of content -- must match the columns in embedding_input()
  on public.chat_messages
  for each row
  execute function util.queue_embeddings('public.embedding_input', 'embedding');

-- 類似度検索用の関数
create or replace function public.match_messages (
  query_embedding extensions.halfvec(1536),
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
    cm.content,
    cm.is_user,
    1 - (cm.embedding <=> query_embedding) as similarity
  from public.chat_messages cm
  where cm.embedding <=> query_embedding < 1 - similarity_threshold
  order by cm.embedding <=> query_embedding
  limit match_count;
end;
$$;

