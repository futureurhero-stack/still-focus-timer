import 'package:flutter/widgets.dart';

/// Centralized app strings with simple EN/KR support.
/// All methods take [BuildContext] so we can switch by Locale.
class AppStrings {
  AppStrings._();

  static bool _isKorean(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ko';

  // ===== App Info =====
  static String appName(BuildContext context) => 'FocusFlow';

  static String appTagline(BuildContext context) => _isKorean(context)
      ? '행동 기반 포모도로 코치'
      : 'Action-based Pomodoro coach';

  // ===== Home Screen =====
  static String startButton(BuildContext context) => _isKorean(context)
      ? '지금 10분만 시작하기'
      : 'Start 10 minutes now';

  static String welcomeMessage(BuildContext context) => _isKorean(context)
      ? '오늘도 한 걸음 나아가볼까요?'
      : 'Ready to take one small step today?';

  static String selectEmotion(BuildContext context) => _isKorean(context)
      ? '지금 기분이 어떠세요?'
      : 'How do you feel right now?';

  // ===== Emotions =====
  static String emotionTired(BuildContext context) =>
      _isKorean(context) ? '하기 싫음' : 'Don\'t want to do it';
  static String emotionStressed(BuildContext context) =>
      _isKorean(context) ? '스트레스' : 'Stressed';
  static String emotionSleepy(BuildContext context) =>
      _isKorean(context) ? '졸림' : 'Sleepy';
  static String emotionGood(BuildContext context) =>
      _isKorean(context) ? '괜찮음' : 'Feeling okay';

  static String emotionTiredDesc(BuildContext context) =>
      _isKorean(context) ? '5~10분만 해봐요' : 'Just 5–10 minutes to start';
  static String emotionStressedDesc(BuildContext context) =>
      _isKorean(context) ? '부담 없이 가볍게' : 'Light, no-pressure mode';
  static String emotionSleepyDesc(BuildContext context) =>
      _isKorean(context) ? '15분 + 움직임 알림' : '15 minutes + movement reminder';
  static String emotionGoodDesc(BuildContext context) =>
      _isKorean(context) ? '25~40분 딥워크' : '25–40 minutes deep work';

  // ===== Timer =====
  static String timerTitle(BuildContext context) =>
      _isKorean(context) ? '집중 중' : 'Focusing';
  static String timerPaused(BuildContext context) =>
      _isKorean(context) ? '일시정지' : 'Paused';
  static String timerCompleted(BuildContext context) =>
      _isKorean(context) ? '완료!' : 'Done!';
  static String pauseButton(BuildContext context) =>
      _isKorean(context) ? '잠시 멈추기' : 'Pause';
  static String resumeButton(BuildContext context) =>
      _isKorean(context) ? '다시 시작' : 'Resume';
  static String stopButton(BuildContext context) =>
      _isKorean(context) ? '종료하기' : 'End session';
  static String giveUpButton(BuildContext context) =>
      _isKorean(context) ? '오늘은 여기까지' : 'Stop for today';

  // ===== Task Input =====
  static String taskInputHint(BuildContext context) =>
      _isKorean(context) ? '무엇을 할 건가요?' : 'What are you going to do?';
  static String taskInputTitle(BuildContext context) =>
      _isKorean(context) ? '작업 입력' : 'Task';
  static String recentTasks(BuildContext context) =>
      _isKorean(context) ? '최근 작업' : 'Recent tasks';
  static String startTask(BuildContext context) =>
      _isKorean(context) ? '시작하기' : 'Start';

  // ===== Reflection =====
  static String reflectionTitle(BuildContext context) =>
      _isKorean(context) ? '10초 회고' : '10-second reflection';
  static String reflectionQuestion(BuildContext context) =>
      _isKorean(context) ? '방금 무엇을 했나요?' : 'What did you just work on?';
  static String reflectionHint(BuildContext context) =>
      _isKorean(context) ? '간단히 적어주세요...' : 'Write a short note...';
  static String reflectionSkip(BuildContext context) =>
      _isKorean(context) ? '건너뛰기' : 'Skip';
  static String reflectionSave(BuildContext context) =>
      _isKorean(context) ? '저장하기' : 'Save';

  // ===== Task Status =====
  static String statusStarted(BuildContext context) =>
      _isKorean(context) ? '시작' : 'Started';
  static String statusInProgress(BuildContext context) =>
      _isKorean(context) ? '진행 중' : 'In progress';
  static String statusCompleted(BuildContext context) =>
      _isKorean(context) ? '완료' : 'Completed';

  // ===== Give Up Reasons =====
  static String giveUpReasonTired(BuildContext context) =>
      _isKorean(context) ? '너무 피곤해요' : 'I\'m too tired';
  static String giveUpReasonDistracted(BuildContext context) =>
      _isKorean(context) ? '집중이 안 돼요' : 'I can\'t focus';
  static String giveUpReasonUrgent(BuildContext context) =>
      _isKorean(context) ? '급한 일이 생겼어요' : 'Something urgent came up';
  static String giveUpReasonOther(BuildContext context) =>
      _isKorean(context) ? '기타' : 'Other';

  // ===== Daily Story =====
  static String dailyStoryTitle(BuildContext context) =>
      _isKorean(context) ? '오늘의 집중 스토리' : 'Today\'s focus story';
  static String shareStory(BuildContext context) =>
      _isKorean(context) ? '공유하기' : 'Share';
  static String noSessionToday(BuildContext context) =>
      _isKorean(context) ? '아직 오늘 세션이 없어요' : 'No sessions yet today';

  // ===== Analytics =====
  static String analyticsTitle(BuildContext context) =>
      _isKorean(context) ? '집중 패턴 분석' : 'Focus pattern analytics';
  static String weeklyReport(BuildContext context) =>
      _isKorean(context) ? '주간 리포트' : 'Weekly report';
  static String monthlyReport(BuildContext context) =>
      _isKorean(context) ? '월간 리포트' : 'Monthly report';
  static String bestFocusTime(BuildContext context) =>
      _isKorean(context) ? '최적 집중 시간' : 'Best focus time';
  static String totalFocusTime(BuildContext context) =>
      _isKorean(context) ? '총 집중 시간' : 'Total focus time';
  static String completionRate(BuildContext context) =>
      _isKorean(context) ? '완료율' : 'Completion rate';

  // ===== Distraction Alert =====
  static String distractionTitle(BuildContext context) =>
      _isKorean(context) ? '집중 세션 중이에요 👀' : 'You\'re in a focus session 👀';
  static String distractionMessage(BuildContext context) =>
      _isKorean(context) ? '돌아올까요?' : 'Come back to your session?';
  static String distractionReturn(BuildContext context) =>
      _isKorean(context) ? '돌아가기' : 'Return to session';
  static String distractionEnd(BuildContext context) =>
      _isKorean(context) ? '세션 종료' : 'End session';

  // ===== Settings =====
  static String settingsTitle(BuildContext context) =>
      _isKorean(context) ? '설정' : 'Settings';
  static String settingsLanguage(BuildContext context) =>
      _isKorean(context) ? '언어' : 'Language';
  static String defaultDuration(BuildContext context) =>
      _isKorean(context) ? '기본 세션 시간' : 'Default session length';
  static String defaultSessionSubtitle(BuildContext context) =>
      _isKorean(context) ? '기본 집중 세션 시간' : 'Default focus session length';
  static String notifications(BuildContext context) =>
      _isKorean(context) ? '알림 설정' : 'Notifications';
  static String darkMode(BuildContext context) =>
      _isKorean(context) ? '다크 모드' : 'Dark mode';
  static String about(BuildContext context) =>
      _isKorean(context) ? '앱 정보' : 'About app';

  // ===== Common =====
  static String confirm(BuildContext context) =>
      _isKorean(context) ? '확인' : 'OK';
  static String cancel(BuildContext context) =>
      _isKorean(context) ? '취소' : 'Cancel';
  static String save(BuildContext context) =>
      _isKorean(context) ? '저장' : 'Save';
  static String close(BuildContext context) =>
      _isKorean(context) ? '닫기' : 'Close';
  static String minutes(BuildContext context) =>
      _isKorean(context) ? '분' : 'min';
  static String seconds(BuildContext context) =>
      _isKorean(context) ? '초' : 'sec';
  static String hours(BuildContext context) =>
      _isKorean(context) ? '시간' : 'hours';
}
