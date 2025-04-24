import 'package:vibration/vibration.dart';

/// バイブレーション機能を提供するユーティリティクラス
class VibrationUtil {
  /// 短いボタンクリック時のバイブレーション
  static void buttonClick() {
    try {
      // より歯切れの良い短い単一振動
      Vibration.vibrate(duration: 15, amplitude: 180);
    } catch (e) {
      // バイブレーションに対応していない場合のエラーハンドリング
    }
  }

  /// オプションをタップした際のバイブレーション
  static void optionTap() {
    try {
      // より歯切れの良い短い単一振動
      Vibration.vibrate(duration: 10, amplitude: 150);
    } catch (e) {
      // バイブレーションに対応していない場合のエラーハンドリング
    }
  }

  /// ダイヤル回転感覚のバイブレーションパターン
  static void dialPattern(int amplitude) {
    try {
      // 短いバイブレーションを3回連続で実行し、ダイヤルのカチカチ感を再現
      List<int> pattern = [
        0,
        20,
        30,
        20,
        30,
        20
      ]; // ミリ秒単位: [待機, 振動, 待機, 振動, 待機, 振動]
      List<int> intensities = [
        0,
        amplitude,
        0,
        amplitude,
        0,
        amplitude
      ]; // 強度: [0, 強度, 0, 強度, 0, 強度]

      Vibration.vibrate(pattern: pattern, intensities: intensities);
    } catch (e) {
      // バイブレーションに対応していない場合のエラーハンドリング
    }
  }

  /// 分析完了時の特別なバイブレーションパターン
  static void completionPattern() {
    try {
      // 完了時は「ダイヤルがロックされた」感覚を再現
      List<int> pattern = [0, 40, 30, 80, 40, 120]; // [待機, 振動, 待機, 振動, 待機, 振動]
      List<int> intensities = [0, 120, 0, 160, 0, 200]; // 強度が徐々に上がる

      Vibration.vibrate(pattern: pattern, intensities: intensities);
    } catch (e) {
      // バイブレーションに対応していない場合のエラーハンドリング
    }
  }
}
