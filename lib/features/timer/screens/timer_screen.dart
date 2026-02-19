import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../data/models/emotion_type.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../providers/timer_provider.dart';
import '../widgets/circular_timer.dart';
import '../widgets/give_up_dialog.dart';

/// 타이머 화면
class TimerScreen extends ConsumerStatefulWidget {
  final EmotionType emotion;
  final int duration;
  final String? taskDescription;

  const TimerScreen({
    super.key,
    required this.emotion,
    required this.duration,
    this.taskDescription,
  });

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with WidgetsBindingObserver {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      // 타이머 시작
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(timerProvider.notifier).start(
              emotion: widget.emotion,
              durationMinutes: widget.duration,
              taskDescription: widget.taskDescription,
            );
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final timerState = ref.read(timerProvider);
    
    if (state == AppLifecycleState.paused && timerState.isRunning) {
      // 앱이 백그라운드로 갔을 때 집중 이탈 기록
      ref.read(timerProvider.notifier).recordDistraction();
    }
  }

  void _togglePause() {
    final timerState = ref.read(timerProvider);
    if (timerState.isRunning) {
      ref.read(timerProvider.notifier).pause();
    } else if (timerState.isPaused) {
      ref.read(timerProvider.notifier).resume();
    }
  }

  void _showGiveUpDialog() {
    showDialog(
      context: context,
      builder: (context) => GiveUpDialog(
        onGiveUp: (reason) {
          ref.read(timerProvider.notifier).giveUp(reason);
        },
      ),
    );
  }

  void _navigateToReflection({bool isCompleted = true}) {
    final timerState = ref.read(timerProvider);
    
    context.pushReplacementNamed(
      'reflection',
      extra: {
        'sessionId': timerState.session?.id ?? '',
        'actualDuration': timerState.elapsedSeconds,
        'isCompleted': isCompleted,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerProvider);

    // 완료되면 회고 화면으로 이동
    ref.listen<TimerState>(timerProvider, (previous, next) {
      if (next.isCompleted && previous?.isCompleted != true) {
        _navigateToReflection(isCompleted: true);
      }
      if (next.status == TimerStatus.givenUp &&
          previous?.status != TimerStatus.givenUp) {
        _navigateToReflection(isCompleted: false);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && timerState.isRunning) {
          _showGiveUpDialog();
        }
      },
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 헤더
                  _buildHeader(timerState),
                  const SizedBox(height: 40),

                  // 작업 정보
                  if (widget.taskDescription != null)
                    _buildTaskInfo()
                        .animate()
                        .fadeIn(duration: AppDurations.animNormal)
                        .slideY(begin: -0.2, end: 0),

                  const Spacer(),

                  // 타이머
                  CircularTimer(
                    remainingSeconds: timerState.remainingSeconds,
                    totalSeconds: timerState.totalSeconds,
                    isRunning: timerState.isRunning,
                    isPaused: timerState.isPaused,
                    progressColor: widget.emotion.color,
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        duration: AppDurations.animSlow,
                      )
                      .fadeIn(),

                  const Spacer(),

                  // 컨트롤 버튼
                  _buildControls(timerState),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TimerState timerState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 감정 표시
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.emotion.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.emotion.emoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                widget.emotion.label(context),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.emotion.color,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: AppDurations.animNormal)
            .slideX(begin: -0.2, end: 0),

        // 종료 버튼
        TextButton(
          onPressed: _showGiveUpDialog,
          child: Text(
            AppStrings.giveUpButton(context),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: AppDurations.animNormal, delay: 200.ms),
      ],
    );
  }

  Widget _buildTaskInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.emotion.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.task_alt,
              color: widget.emotion.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Localizations.localeOf(context).languageCode == 'ko'
                      ? '현재 작업'
                      : 'Current task',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.taskDescription!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(TimerState timerState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 일시정지/재개 버튼
        GestureDetector(
          onTap: _togglePause,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: timerState.isPaused
                  ? AppColors.primaryGradient
                  : null,
              color: timerState.isPaused ? null : AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: (timerState.isPaused
                          ? AppColors.primary
                          : Colors.black)
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              timerState.isPaused ? Icons.play_arrow : Icons.pause,
              size: 40,
              color: Colors.white,
            ),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
            )
            .fadeIn(delay: 300.ms),
      ],
    );
  }
}

