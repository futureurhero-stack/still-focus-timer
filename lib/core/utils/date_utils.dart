import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// 날짜/시간 관련 유틸리티 함수들
class AppDateUtils {
  AppDateUtils._();

  /// 시간을 MM:SS 형식으로 포맷
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// 시간을 HH:MM:SS 형식으로 포맷 (1시간 이상)
  static String formatDurationLong(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  /// 분을 읽기 쉬운 형식으로 변환 (로케일별)
  static String formatMinutes(BuildContext context, int minutes) {
    final isKo = Localizations.localeOf(context).languageCode == 'ko';

    if (isKo) {
      if (minutes < 60) {
        return '$minutes분';
      }
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (mins == 0) {
        return '$hours시간';
      }
      return '$hours시간 $mins분';
    } else {
      if (minutes < 60) {
        return '$minutes min';
      }
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (mins == 0) {
        return '${hours}h';
      }
      return '${hours}h ${mins}m';
    }
  }

  /// 오늘 날짜인지 확인
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// 어제 날짜인지 확인
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// 날짜를 친근한 형식으로 포맷
  static String formatFriendlyDate(DateTime date) {
    if (isToday(date)) {
      return '오늘';
    }
    if (isYesterday(date)) {
      return '어제';
    }
    return DateFormat('M월 d일').format(date);
  }

  /// 날짜를 전체 형식으로 포맷
  static String formatFullDate(DateTime date) {
    return DateFormat('yyyy년 M월 d일').format(date);
  }

  /// 시간을 오전/오후 형식으로 포맷
  static String formatTime(DateTime date) {
    return DateFormat('a h:mm', 'ko').format(date);
  }

  /// 시간대를 문자열로 변환
  static String getTimeOfDayString(DateTime date) {
    final hour = date.hour;
    if (hour >= 5 && hour < 12) {
      return '오전';
    } else if (hour >= 12 && hour < 17) {
      return '오후';
    } else if (hour >= 17 && hour < 21) {
      return '저녁';
    } else {
      return '밤';
    }
  }

  /// 요일을 현재 로케일에 맞게 반환 (한글: 월화수…, 영어: Mon, Tue…)
  static String getWeekdayName(BuildContext context, int weekday) {
    final locale = Localizations.localeOf(context).languageCode;
    // weekday 1=월요일, 7=일요일. 2024-01-01 = 월요일
    final refDate = DateTime(2024, 1, 1).add(Duration(days: weekday - 1));
    return DateFormat('E', locale).format(refDate);
  }

  /// 오늘의 시작 시간 (00:00:00)
  static DateTime get startOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 오늘의 종료 시간 (23:59:59)
  static DateTime get endOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  /// 이번 주의 시작 (월요일)
  static DateTime get startOfWeek {
    final now = DateTime.now();
    final weekday = now.weekday;
    return DateTime(now.year, now.month, now.day - (weekday - 1));
  }

  /// 이번 달의 시작
  static DateTime get startOfMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }
}




