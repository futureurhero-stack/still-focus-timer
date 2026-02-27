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
  static String howAreYouFeelingNow(BuildContext context) => _isKorean(context)
      ? '지금 기분이 어떠세요?'
      : 'How are you feeling now?';

  // ===== Bottom navigation =====
  static String navHome(BuildContext context) =>
      _isKorean(context) ? '홈' : 'Home';
  static String navStats(BuildContext context) =>
      _isKorean(context) ? '통계' : 'Stats';
  static String navSettings(BuildContext context) =>
      _isKorean(context) ? '설정' : 'Settings';

  // ===== Emotions =====
  static String emotionTired(BuildContext context) =>
      _isKorean(context) ? '산만함' : 'Distracted';
  static String emotionStressed(BuildContext context) =>
      _isKorean(context) ? '부담됨' : 'Overwhelmed';
  static String emotionSleepy(BuildContext context) =>
      _isKorean(context) ? '저에너지' : 'Low Energy';
  static String emotionGood(BuildContext context) =>
      _isKorean(context) ? '몰입 정점' : 'In the Zone';

  static String emotionTiredDesc(BuildContext context) =>
      _isKorean(context) ? '집중이 잘 안 될 때' : 'Hard to stay on task?';
  static String emotionStressedDesc(BuildContext context) =>
      _isKorean(context) ? '할 일이 너무 많을 때' : 'Too much on your mind?';
  static String emotionSleepyDesc(BuildContext context) =>
      _isKorean(context) ? '몸이 무거울 때' : 'Running low today?';
  static String emotionGoodDesc(BuildContext context) =>
      _isKorean(context) ? '최상의 컨디션일 때' : 'Ready to dive in?';

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
  static String giveUpReasonTired(BuildContext context) => "I'm feeling exhausted";
  static String giveUpReasonDistracted(BuildContext context) => "I can't stay focused";
  static String giveUpReasonUrgent(BuildContext context) => "Something else came up";
  static String giveUpReasonOther(BuildContext context) => "Just taking a break";

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
  static String weeklyFocusTime(BuildContext context) =>
      _isKorean(context) ? '주간 집중 시간' : 'Weekly focus time';
  static String bestFocusTime(BuildContext context) =>
      _isKorean(context) ? '최적 집중 시간' : 'Best focus time';
  static String totalFocusTime(BuildContext context) =>
      _isKorean(context) ? '총 집중 시간' : 'Total focus time';
  static String focusTime(BuildContext context) =>
      _isKorean(context) ? '집중 시간' : 'Focus time';
  static String sessions(BuildContext context) =>
      _isKorean(context) ? '세션' : 'Sessions';
  static String goalRate(BuildContext context) =>
      _isKorean(context) ? '목표 달성률' : 'Goal rate';
  static String bestHour(BuildContext context) =>
      _isKorean(context) ? '최적 시간' : 'Best hour';
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
  static String quickStart(BuildContext context) =>
      _isKorean(context) ? '퀵 스타트' : 'Quick Start';
  static String defaultDuration(BuildContext context) =>
      _isKorean(context) ? '나의 루틴' : 'Start my routine';
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
