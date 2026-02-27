import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_durations.dart';

/// 사용자의 감정 타입을 나타내는 enum
/// 각 감정에 따라 세션 설정이 달라집니다.
enum EmotionType {
  /// 😫 하기 싫음 - 5~10분 미니 세션
  tired,
  
  /// 😰 스트레스 - 부담 완화 모드 (성과 기록 없음)
  stressed,
  
  /// 😴 졸림 - 15분 + 움직임 알림
  sleepy,
  
  /// 😃 괜찮음 - 25~40분 딥워크
  good,
}

/// EmotionType에 대한 확장 메서드
extension EmotionTypeExtension on EmotionType {
  /// 이모지 반환
  String get emoji {
    switch (this) {
      case EmotionType.tired:
        return '😫';
      case EmotionType.stressed:
        return '😰';
      case EmotionType.sleepy:
        return '😴';
      case EmotionType.good:
        return '😃';
    }
  }

  /// 아이콘 반환 (홈 화면과 일치)
  IconData get icon {
    switch (this) {
      case EmotionType.tired:
        return Icons.blur_on_rounded;
      case EmotionType.stressed:
        return Icons.sentiment_very_dissatisfied_rounded;
      case EmotionType.sleepy:
        return Icons.battery_3_bar_rounded;
      case EmotionType.good:
        return Icons.track_changes_rounded;
    }
  }

  /// Localized emotion label
  String label(BuildContext context) {
    switch (this) {
      case EmotionType.tired:
        return AppStrings.emotionTired(context);
      case EmotionType.stressed:
        return AppStrings.emotionStressed(context);
      case EmotionType.sleepy:
        return AppStrings.emotionSleepy(context);
      case EmotionType.good:
        return AppStrings.emotionGood(context);
    }
  }

  /// Localized emotion description
  String description(BuildContext context) {
    switch (this) {
      case EmotionType.tired:
        return AppStrings.emotionTiredDesc(context);
      case EmotionType.stressed:
        return AppStrings.emotionStressedDesc(context);
      case EmotionType.sleepy:
        return AppStrings.emotionSleepyDesc(context);
      case EmotionType.good:
        return AppStrings.emotionGoodDesc(context);
    }
  }

  /// 감정 색상 반환
  Color get color {
    switch (this) {
      case EmotionType.tired:
        return AppColors.emotionTired;
      case EmotionType.stressed:
        return AppColors.emotionStressed;
      case EmotionType.sleepy:
        return AppColors.emotionSleepy;
      case EmotionType.good:
        return AppColors.emotionGood;
    }
  }

  /// 권장 세션 시간 (분) 반환
  int get recommendedDuration {
    switch (this) {
      case EmotionType.tired:
        return AppDurations.emotionTiredMin; // 5분
      case EmotionType.stressed:
        return AppDurations.emotionStressedSession; // 10분
      case EmotionType.sleepy:
        return AppDurations.emotionSleepySession; // 15분
      case EmotionType.good:
        return AppDurations.emotionGoodMin; // 25분
    }
  }

  /// 최대 세션 시간 (분) 반환
  int get maxDuration {
    switch (this) {
      case EmotionType.tired:
        return AppDurations.emotionTiredMax; // 10분
      case EmotionType.stressed:
        return AppDurations.emotionStressedSession; // 10분
      case EmotionType.sleepy:
        return AppDurations.emotionSleepySession; // 15분
      case EmotionType.good:
        return AppDurations.emotionGoodMax; // 40분
    }
  }

  /// 성과 기록을 하는지 여부 (스트레스일 때는 부담 완화 모드)
  bool get recordsProgress {
    return this != EmotionType.stressed;
  }

  /// 움직임 알림 필요 여부
  bool get needsMovementReminder {
    return this == EmotionType.sleepy;
  }
}




