import 'dart:async'; // StreamSubscription のために追加

import 'package:flutter/material.dart';
import 'package:gambless/utils/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/chat_repository.dart';
import '../../domain/entities/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // スクロール制御用
  final List<ChatMessage> _messages = [];
  late final ChatRepository _chatRepository;
  bool _isLoading = false;
  StreamSubscription? _streamSubscription; // ストリーム購読管理用
  String _currentAIResponse = ''; // AIの現在構築中のレスポンス
  int? _aiMessageIndex; // 現在更新中のAIメッセージのインデックス

  @override
  void initState() {
    super.initState();
    _chatRepository = ChatRepository(Supabase.instance.client);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose(); // dispose を追加
    _streamSubscription?.cancel(); // dispose時に購読をキャンセル
    super.dispose();
  }

  // 最下部へスクロールするメソッド
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return; // 送信中は何もしない

    // 既存のストリームがあればキャンセル
    await _streamSubscription?.cancel();
    _streamSubscription = null;

    setState(() {
      _isLoading = true;
      _messages.add(ChatMessage(
        content: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      // AI応答用の空メッセージを追加し、そのインデックスを保持
      _messages.add(ChatMessage(
        content: '', // 最初は空
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _aiMessageIndex = _messages.length - 1;
      _currentAIResponse = ''; // レスポンスをリセット
    });

    _messageController.clear();
    _scrollToBottom(); // 新しいメッセージ表示後にスクロール

    try {
      const recentMessagesLength = 6;
      // ユーザーメッセージと空のAIメッセージを除いたリストを取得
      final previousMessages = _messages.sublist(0, _messages.length - 2);

      final recentMessages = previousMessages.length > recentMessagesLength
          ? previousMessages
              .sublist(previousMessages.length - recentMessagesLength)
          : previousMessages;

      logger.i('Recent Messages: $recentMessages');

      final stream = _chatRepository.sendMessage(message, recentMessages);
      _streamSubscription = stream.listen(
        (chunk) {
          // 受信したチャンクを結合
          _currentAIResponse += chunk;
          setState(() {
            // 対応するAIメッセージの content を更新
            if (_aiMessageIndex != null &&
                _aiMessageIndex! < _messages.length) {
              _messages[_aiMessageIndex!] = _messages[_aiMessageIndex!]
                  .copyWith(content: _currentAIResponse);
            }
          });
          _scrollToBottom(); // メッセージ更新中にスクロール
        },
        onDone: () {
          logger.i('Stream done');
          setState(() {
            _isLoading = false;
            _aiMessageIndex = null; // 更新完了
          });
          _scrollToBottom(); // 完了後にもスクロール
        },
        onError: (e) {
          logger.e('Error receiving stream: $e');
          setState(() {
            _isLoading = false;
            if (_aiMessageIndex != null &&
                _aiMessageIndex! < _messages.length) {
              // エラーメッセージを表示
              _messages[_aiMessageIndex!] = _messages[_aiMessageIndex!]
                  .copyWith(content: 'エラーが発生しました: $e');
            } else {
              // AIメッセージが見つからない場合（稀なケース）
              _messages.add(ChatMessage(
                  content: 'エラーが発生しました: $e',
                  isUser: false,
                  timestamp: DateTime.now()));
            }
            _aiMessageIndex = null; // 更新完了
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('メッセージの受信中にエラーが発生しました: $e')),
          );
          _scrollToBottom(); // エラー後にもスクロール
        },
        cancelOnError: true, // エラー時に自動でキャンセル
      );
    } catch (e) {
      logger.e('Error sending message: $e');
      setState(() {
        _isLoading = false;
        // エラー発生時、プレースホルダーのAIメッセージを削除またはエラー表示に更新
        if (_aiMessageIndex != null && _aiMessageIndex! < _messages.length) {
          _messages.removeAt(_aiMessageIndex!); // 失敗したAIメッセージは削除
        }
        _aiMessageIndex = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('メッセージの送信に失敗しました: $e')),
      );
    }
    // finally は stream.listen が非同期に完了するため、ここでは使わない
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        centerTitle: true,
        titleSpacing: 0,
        toolbarHeight: 48,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          iconSize: 20,
          visualDensity: VisualDensity.compact,
        ),
        leadingWidth: 40,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      controller: _scrollController, // controller を設定
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        // AIメッセージが構築中の場合の点滅カーソル表示（オプション）
                        bool isAiTyping = !message.isUser &&
                            _isLoading &&
                            index == _aiMessageIndex;
                        return _buildMessageBubble(message, isAiTyping);
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'メッセージを入力...',
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? theme.colorScheme.surface
                            : Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      // 送信ボタンが無効な時もEnterで送信しないようにする
                      enabled: !_isLoading,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          _isLoading ? Colors.grey : theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _isLoading ? null : _sendMessage,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send,
                              color: Colors.white, size: 20),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        minWidth: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'AI Chat Support',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'メッセージを入力してサポートを受けましょう',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 12,
                children: [
                  _buildSuggestionChip(context, '今日の気分はどうですか？'),
                  _buildSuggestionChip(context, 'ギャンブルの衝動への対処法は？'),
                  _buildSuggestionChip(context, '目標設定のサポート'),
                  _buildSuggestionChip(context, 'ストレス解消法'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String text) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        _messageController.text = text;
        _sendMessage();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // MessageBubble の引数を変更
  Widget _buildMessageBubble(ChatMessage message, [bool isAiTyping = false]) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // タイピング中のカーソル表示（シンプルに末尾にカーソル文字を追加）
    final content = message.content + (isAiTyping ? '▋' : '');

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          // メッセージが空でも最小幅を確保（オプション）
          minWidth: isAiTyping ? 40 : 0,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? theme.colorScheme.primary
              : isDark
                  ? Colors.grey.shade800
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          content, // 更新された content を使用
          style: TextStyle(
            color: message.isUser
                ? Colors.white
                : isDark
                    ? Colors.white
                    : Colors.black87,
          ),
        ),
      ),
    );
  }
}
