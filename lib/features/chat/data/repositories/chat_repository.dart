import 'dart:async';
import 'dart:convert';

import 'package:gambless/utils/logger.dart'; // logger をインポート
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../chat/domain/entities/chat_message.dart';

class ChatRepository {
  final SupabaseClient _client;
  final _httpClient = http.Client(); // http クライアントを初期化

  ChatRepository(this._client);

  /// ユーザーメッセージをデータベースに保存する
  Future<void> saveUserMessage(ChatMessage message) async {
    // final userId = _client.auth.currentUser?.id;
    // if (userId == null) {
    //   throw Exception('User not authenticated.');
    // }
    try {
      await _client.from('chat_messages').insert({
        // 'user_id': userId, // 認証ユーザーIDを追加
        'content': message.content, // 元のメッセージ内容に戻す
        'is_user': true, // コメントアウトを解除！
      });
    } on PostgrestException catch (e) {
      logger.e('Error saving user message to DB: ${e.message}');
      throw Exception('Failed to save user message: ${e.message}');
    } catch (e) {
      logger.e('Unexpected error saving user message: $e');
      throw Exception('Unexpected error saving message: $e');
    }
  }

  Stream<String> sendMessage(String message, List<ChatMessage> history) async* {
    // _client の情報から Functions URL と ApiKey を取得
    final functionUrl = '${_client.rest.url}/ai_chat'
        .replaceAll('/rest/v1', '/functions/v1'); // Functionsパスに調整
    final headers = {
      'Authorization':
          'Bearer ${String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'a')}',
      'Content-Type': 'application/json',
    };

    final List<Map<String, String>> historyMessages = history
        .map((msg) => {
              'role': msg.isUser ? 'user' : 'assistant',
              'content': msg.content,
            })
        .toList();

    final body = jsonEncode({
      'history': historyMessages,
      'message': message,
    });

    try {
      final request = http.Request('POST', Uri.parse(functionUrl));
      request.headers.addAll(headers);
      request.body = body;

      final response = await _httpClient.send(request);

      if (response.statusCode == 200) {
        // レスポンスボディをストリームとして取得し、UTF-8でデコード
        // SSE形式をパースする
        final stream = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter());

        await for (final line in stream) {
          // 行が空でないかチェック
          if (line.trim().isEmpty) continue;

          String dataLine = line;
          // 'data: ' プレフィックスがあるか確認
          if (line.startsWith('data: ')) {
            logger.i('dataLine: $dataLine');
            dataLine = line.substring(6).trim(); // 'data: ' と前後の空白を除去
          }

          if (dataLine == '[DONE]') {
            // OpenAI のストリーム終了シグナル
            break;
          }

          // JSONとしてパースを試みる
          try {
            final decoded = jsonDecode(dataLine);
            // choices[0].delta.content を取得
            if (decoded['choices'] != null &&
                decoded['choices'].isNotEmpty &&
                decoded['choices'][0]['delta'] != null &&
                decoded['choices'][0]['delta']['content'] != null) {
              yield decoded['choices'][0]['delta']['content'] as String;
            } else {
              // 予期しないJSON構造の場合（デバッグ用）
              logger.w('Received JSON without expected content: $dataLine');
            }
          } catch (e) {
            // JSONパースエラーの場合（デバッグ用）
            logger.e('Error parsing SSE data line: $dataLine, Error: $e');
            // エラーでもとりあえずそのまま流してみるか、無視するかを選択
            // yield dataLine; // 必要に応じてコメント解除
          }
        }
      } else {
        final errorBody = await response.stream.bytesToString();
        logger.e('Failed to send message: ${response.statusCode} - $errorBody');
        throw Exception(
            'Failed to send message: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      logger.e('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
    // 注意: _httpClient は適切に dispose することが推奨されますが、
    // Repository がアプリケーションのライフサイクル全体で使われる場合は、
    // アプリケーション終了時に dispose するなどの考慮が必要です。
    // 簡単のためここでは dispose 処理は省略します。
  }
}
