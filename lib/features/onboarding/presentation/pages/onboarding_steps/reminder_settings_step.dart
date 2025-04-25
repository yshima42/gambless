import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../widgets/onboarding_widgets.dart';

class ReminderSettingsStep extends ConsumerWidget {
  final VoidCallback onNext;

  const ReminderSettingsStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingData = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    // バイブレーション関数
    void vibrate() {
      try {
        Vibration.vibrate(duration: 15, amplitude: 180);
      } catch (e) {
        // バイブレーションに対応していない場合のエラーハンドリング
      }
    }

    // 時間選択ダイアログを表示する関数
    Future<void> selectTime(BuildContext context) async {
      vibrate(); // タップ時にバイブレーション

      // デフォルト時間を設定（現在の設定値またはデフォルト値）
      final TimeOfDay initialTime = onboardingData.reminderTime ??
          TimeOfDay(hour: 9, minute: 0); // デフォルトは朝9時

      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Theme.of(context).colorScheme.primary,
                onPrimary: Colors.white,
                surface: Colors.grey.shade900,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.grey.shade900,
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        onboardingNotifier.setReminderTime(picked);
      }
    }

    // 分かりやすい時刻表示
    String formatTimeOfDay(TimeOfDay? time) {
      if (time == null) return '時間を選択';

      final hour = time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = hour < 12 ? 'AM' : 'PM';
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;

      return '$displayHour:$minute $period';
    }

    // おすすめの時間プリセット
    final List<Map<String, dynamic>> recommendedTimes = [
      {
        'time': const TimeOfDay(hour: 7, minute: 30),
        'label': '朝のルーティン',
        'description': '朝の習慣形成におすすめ',
        'icon': Icons.wb_sunny,
      },
      {
        'time': const TimeOfDay(hour: 12, minute: 0),
        'label': 'ランチタイム',
        'description': '昼休みの小休憩におすすめ',
        'icon': Icons.lunch_dining,
      },
      {
        'time': const TimeOfDay(hour: 19, minute: 0),
        'label': '夜のリラックスタイム',
        'description': '夜の自己振り返りにおすすめ',
        'icon': Icons.nightlight_round,
      },
      {
        'time': const TimeOfDay(hour: 21, minute: 30),
        'label': '就寝前',
        'description': '睡眠前の落ち着いた時間におすすめ',
        'icon': Icons.bedtime,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QuizHeader(
            questionNumber: 'Step #2',
            question: 'Reminder Settings',
            description:
                'Regular reminders are effective for maintaining recovery. Would you like to receive daily reminders?',
            icon: Icons.notifications_active,
          ),
          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'For Habit Formation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Receiving reminders at the same time every day makes it easier to form new habits for recovery.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Daily reminder toggle
          InkWell(
            onTap: () {
              vibrate(); // タップ時にバイブレーション
              onboardingNotifier
                  .setDailyReminders(!onboardingData.wantsDailyReminders);
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: onboardingData.wantsDailyReminders
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                  width: onboardingData.wantsDailyReminders ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications,
                    color: onboardingData.wantsDailyReminders
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Reminders',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: onboardingData.wantsDailyReminders
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                          ),
                        ),
                        Text(
                          'Receive daily reminders for exercises and tasks',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: onboardingData.wantsDailyReminders,
                    onChanged: (value) {
                      vibrate(); // スイッチ切り替え時にバイブレーション
                      onboardingNotifier.setDailyReminders(value);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // リマインダー時間設定 - リマインダーONの場合のみ表示
          if (onboardingData.wantsDailyReminders)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ヘッダーテキスト
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
                  child: Text(
                    'おすすめの時間',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),

                // おすすめの時間のリスト
                ...recommendedTimes.map((timeData) {
                  final TimeOfDay time = timeData['time'];
                  final bool isSelected = onboardingData.reminderTime != null &&
                      onboardingData.reminderTime!.hour == time.hour &&
                      onboardingData.reminderTime!.minute == time.minute;

                  return InkWell(
                    onTap: () {
                      vibrate();
                      onboardingNotifier.setReminderTime(time);
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            timeData['icon'],
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white.withOpacity(0.7),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  timeData['label'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  timeData['description'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.2)
                                  : Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              formatTimeOfDay(time),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // カスタム時間選択ボタン
                InkWell(
                  onTap: () => selectTime(context),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isCustomTime(
                                onboardingData.reminderTime, recommendedTimes)
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor,
                        width: _isCustomTime(
                                onboardingData.reminderTime, recommendedTimes)
                            ? 2
                            : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: _isCustomTime(
                                  onboardingData.reminderTime, recommendedTimes)
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'カスタム時間を設定',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: _isCustomTime(
                                          onboardingData.reminderTime,
                                          recommendedTimes)
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                'あなたに最適な時間を選択してください',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isCustomTime(onboardingData.reminderTime,
                                    recommendedTimes)
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2)
                                : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isCustomTime(onboardingData.reminderTime,
                                        recommendedTimes)
                                    ? formatTimeOfDay(
                                        onboardingData.reminderTime)
                                    : '選択',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isCustomTime(
                                          onboardingData.reminderTime,
                                          recommendedTimes)
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_drop_down,
                                color: _isCustomTime(
                                        onboardingData.reminderTime,
                                        recommendedTimes)
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white.withOpacity(0.7),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Best practice for time selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Best Practices',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Research suggests that setting reminders in the morning (within 1 hour of waking up) or at night (1 hour before bed) is most effective.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          const SizedBox(height: 40),

          // Continueボタン
          const SizedBox(height: 24),
          OnboardingButton(
            text: 'Continue to Final Step',
            onPressed: onNext,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // カスタム時間かどうかをチェック
  bool _isCustomTime(
      TimeOfDay? selectedTime, List<Map<String, dynamic>> recommendedTimes) {
    if (selectedTime == null) return false;

    // 推奨時間リストに含まれているかをチェック
    for (final timeData in recommendedTimes) {
      final TimeOfDay time = timeData['time'];
      if (time.hour == selectedTime.hour &&
          time.minute == selectedTime.minute) {
        return false;
      }
    }

    // リストに含まれていなければカスタム時間
    return true;
  }
}
