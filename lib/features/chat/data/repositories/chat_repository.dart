import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../chat/domain/entities/chat_message.dart';

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);

  // フロントじゃなくてエッジ関数側で取得したほうがいいかも
  Future<String> sendMessage(String message, List<ChatMessage> history) async {
    try {
      final List<Map<String, String>> messages = history
          .map((msg) => {
                'role': msg.isUser ? 'user' : 'assistant',
                'content': msg.content,
              })
          .toList();

      messages.add({
        'role': 'user',
        'content': message,
      });

      final response = await _client.functions.invoke(
        'openai',
        body: {
          'messages': messages.map((m) => Map<String, String>.from(m)).toList(),
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to send message: ${response.data}');
      }

      return response.data as String;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
