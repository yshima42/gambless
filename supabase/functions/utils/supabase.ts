// 余裕あったクラスにしたい
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.0.0";

import {
	_SupabaseAnonKey_,
	_SupabaseServiceRoleKey_,
	_SupabaseUrl_,
} from "./config.ts";
// import { Database } from "../types/database.ts";

// rls制限を受けるクライアント
// 問題が起きなければエラーを減らすためにこちらを使う
export const supabaseClient = createClient(
	_SupabaseUrl_,
	_SupabaseAnonKey_,
	// サーバーで動かすとエラーが起きるため
	// https://github.com/nuxt-modules/supabase/issues/188#issuecomment-1657850414
	{ auth: { persistSession: false } },
);

// rls制限を受けないクライアント
export const supabaseAdmin = createClient(
	_SupabaseUrl_,
	_SupabaseServiceRoleKey_,
	// サーバーで動かすとエラーが起きるため
	// https://github.com/nuxt-modules/supabase/issues/188#issuecomment-1657850414
	{ auth: { persistSession: false } },
);
