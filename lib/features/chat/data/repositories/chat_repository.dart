import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);

  Future<String> sendMessage(String message) async {
    try {
      final response = await _client.functions.invoke(
        'openai',
        body: {'query': message},
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
