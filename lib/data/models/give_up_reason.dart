import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

/// 세션 포기 이유를 나타내는 enum
enum GiveUpReason {
  /// 너무 피곤해요
  tired,
  
  /// 집중이 안 돼요
  distracted,
  
  /// 급한 일이 생겼어요
  urgent,
  
  /// 기타
  other,
}

/// GiveUpReason에 대한 확장 메서드
extension GiveUpReasonExtension on GiveUpReason {
  /// Localized reason label
  String label(BuildContext context) {
    switch (this) {
      case GiveUpReason.tired:
        return AppStrings.giveUpReasonTired(context);
      case GiveUpReason.distracted:
        return AppStrings.giveUpReasonDistracted(context);
      case GiveUpReason.urgent:
        return AppStrings.giveUpReasonUrgent(context);
      case GiveUpReason.other:
        return AppStrings.giveUpReasonOther(context);
    }
  }

  /// 아이콘 반환 (영문 레이블에 어울리는 아이콘)
  IconData get icon {
    switch (this) {
      case GiveUpReason.tired:
        return Icons.battery_alert_rounded;
      case GiveUpReason.distracted:
        return Icons.blur_on_rounded;
      case GiveUpReason.urgent:
        return Icons.notifications_active_rounded;
      case GiveUpReason.other:
        return Icons.coffee_rounded;
    }
  }

  /// 이모지 반환
  String get emoji {
    switch (this) {
      case GiveUpReason.tired:
        return '😴';
      case GiveUpReason.distracted:
        return '🤯';
      case GiveUpReason.urgent:
        return '🚨';
      case GiveUpReason.other:
        return '💭';
    }
  }
}




