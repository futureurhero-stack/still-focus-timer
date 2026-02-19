/// FocusFlow 앱의 시간/애니메이션 관련 상수
class AppDurations {
  AppDurations._();

  // ===== Session Durations (in minutes) =====
  /// 기본 세션 시간
  static const int defaultSession = 10;
  
  /// 감정별 세션 시간
  static const int emotionTiredMin = 5;
  static const int emotionTiredMax = 10;
  static const int emotionStressedSession = 10;
  static const int emotionSleepySession = 15;
  static const int emotionGoodMin = 25;
  static const int emotionGoodMax = 40;

  /// 짧은 휴식
  static const int shortBreak = 5;
  
  /// 긴 휴식
  static const int longBreak = 15;

  // ===== Animation Durations =====
  /// 빠른 애니메이션
  static const Duration animFast = Duration(milliseconds: 150);
  
  /// 일반 애니메이션
  static const Duration animNormal = Duration(milliseconds: 300);
  
  /// 느린 애니메이션
  static const Duration animSlow = Duration(milliseconds: 500);
  
  /// 페이지 전환 애니메이션
  static const Duration pageTransition = Duration(milliseconds: 400);

  // ===== Timer Related =====
  /// 타이머 틱 간격
  static const Duration timerTick = Duration(seconds: 1);
  
  /// 백그라운드 전환 감지 딜레이
  static const Duration backgroundDetectionDelay = Duration(seconds: 3);
  
  /// 알림 표시 후 자동 숨김 시간
  static const Duration notificationAutoHide = Duration(seconds: 5);

  // ===== UI Feedback =====
  /// 버튼 피드백 딜레이
  static const Duration buttonFeedback = Duration(milliseconds: 100);
  
  /// 토스트 표시 시간
  static const Duration toastDuration = Duration(seconds: 2);
  
  /// 스낵바 표시 시간
  static const Duration snackbarDuration = Duration(seconds: 3);
}




