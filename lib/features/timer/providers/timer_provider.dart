import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/emotion_type.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/give_up_reason.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/repositories/task_repository.dart';

/// 타이머 상태
enum TimerStatus {
  initial,
  running,
  paused,
  completed,
  givenUp,
}

/// 타이머 상태 클래스
class TimerState {
  final TimerStatus status;
  final int totalSeconds;
  final int remainingSeconds;
  final int elapsedSeconds;
  final SessionModel? session;
  final String? errorMessage;
  /// 포기 시 선택한 이유 (Analytics용)
  final GiveUpReason? lastGiveUpReason;

  const TimerState({
    this.status = TimerStatus.initial,
    this.totalSeconds = 0,
    this.remainingSeconds = 0,
    this.elapsedSeconds = 0,
    this.session,
    this.errorMessage,
    this.lastGiveUpReason,
  });

  /// 진행률 (0.0 ~ 1.0)
  double get progress {
    if (totalSeconds == 0) return 0;
    return elapsedSeconds / totalSeconds;
  }

  /// 완료 여부
  bool get isCompleted => status == TimerStatus.completed;

  /// 실행 중 여부
  bool get isRunning => status == TimerStatus.running;

  /// 일시정지 여부
  bool get isPaused => status == TimerStatus.paused;

  TimerState copyWith({
    TimerStatus? status,
    int? totalSeconds,
    int? remainingSeconds,
    int? elapsedSeconds,
    SessionModel? session,
    String? errorMessage,
    GiveUpReason? lastGiveUpReason,
  }) {
    return TimerState(
      status: status ?? this.status,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      session: session ?? this.session,
      errorMessage: errorMessage ?? this.errorMessage,
      lastGiveUpReason: lastGiveUpReason ?? this.lastGiveUpReason,
    );
  }
}

/// 타이머 Notifier
class TimerNotifier extends StateNotifier<TimerState> {
  final SessionRepository _sessionRepository;
  final TaskRepository _taskRepository;
  Timer? _timer;

  TimerNotifier({
    SessionRepository? sessionRepository,
    TaskRepository? taskRepository,
  })  : _sessionRepository = sessionRepository ?? SessionRepository(),
        _taskRepository = taskRepository ?? TaskRepository(),
        super(const TimerState());

  /// 타이머 시작
  Future<void> start({
    required EmotionType emotion,
    required int durationMinutes,
    String? taskDescription,
  }) async {
    try {
      // 세션 생성
      final session = await _sessionRepository.createSession(
        emotion: emotion,
        plannedDuration: durationMinutes,
        taskDescription: taskDescription,
      );

      // 작업이 있으면 저장
      if (taskDescription != null && taskDescription.isNotEmpty) {
        await _taskRepository.createOrUpdateTask(taskDescription);
      }

      final totalSeconds = durationMinutes * 60;

      state = state.copyWith(
        status: TimerStatus.running,
        totalSeconds: totalSeconds,
        remainingSeconds: totalSeconds,
        elapsedSeconds: 0,
        session: session,
      );

      _startTimer();
    } catch (e) {
      state = state.copyWith(
        status: TimerStatus.initial,
        errorMessage: e.toString(),
      );
    }
  }

  /// 타이머 시작 (내부)
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
          elapsedSeconds: state.elapsedSeconds + 1,
        );
      } else {
        _completeSession();
      }
    });
  }

  /// 일시정지
  void pause() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  /// 재개
  void resume() {
    state = state.copyWith(status: TimerStatus.running);
    _startTimer();
  }

  /// 세션 완료
  Future<void> _completeSession() async {
    _timer?.cancel();
    
    if (state.session != null) {
      await _sessionRepository.completeSession(
        sessionId: state.session!.id,
        actualDurationSeconds: state.elapsedSeconds,
      );
    }

    state = state.copyWith(status: TimerStatus.completed);
  }

  /// 세션 포기
  Future<void> giveUp(GiveUpReason reason) async {
    _timer?.cancel();
    
    if (state.session != null) {
      await _sessionRepository.giveUpSession(
        sessionId: state.session!.id,
        actualDurationSeconds: state.elapsedSeconds,
        reason: reason,
      );
    }

    state = state.copyWith(status: TimerStatus.givenUp, lastGiveUpReason: reason);
  }

  /// 집중 이탈 기록
  Future<void> recordDistraction() async {
    if (state.session != null) {
      await _sessionRepository.incrementDistraction(state.session!.id);
    }
  }

  /// 초기화
  void reset() {
    _timer?.cancel();
    state = const TimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// 타이머 Provider
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});




