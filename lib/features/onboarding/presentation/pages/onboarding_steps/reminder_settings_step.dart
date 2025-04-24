import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../../../data/providers/onboarding_provider.dart';
import '../../widgets/onboarding_widgets.dart';
import 'subscription_step.dart';

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
    Future<void> _selectTime(BuildContext context) async {
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
    String _formatTimeOfDay(TimeOfDay? time) {
      if (time == null) return '時間を選択';

      final hour = time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = hour < 12 ? 'AM' : 'PM';
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;

      return '$displayHour:$minute $period';
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF121212),
                  const Color(0xFF1E1E2E),
                  Theme.of(context).colorScheme.background,
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
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
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                        onboardingNotifier.setDailyReminders(
                            !onboardingData.wantsDailyReminders);
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
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
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
                              activeColor:
                                  Theme.of(context).colorScheme.primary,
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
                          // 時間選択ボタン
                          InkWell(
                            onTap: () => _selectTime(context),
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: onboardingData.reminderTime != null
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).dividerColor,
                                  width: onboardingData.reminderTime != null
                                      ? 2
                                      : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: onboardingData.reminderTime != null
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Reminder Time',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color:
                                                onboardingData.reminderTime !=
                                                        null
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Set your daily reminder time',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Colors.white.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      _formatTimeOfDay(
                                          onboardingData.reminderTime),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Best Practices',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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

                    // Continue button
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: OnboardingButton(
                          text: 'Continue to Subscription',
                          onPressed: () {
                            // すでにOnboardingButtonの中でバイブレーションが実装されている
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SubscriptionStep(
                                  onNext: onNext,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
