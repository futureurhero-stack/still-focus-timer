import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/svg_icon.dart';
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
        backgroundColor: const Color(0xFFF7F8FC),
        body: Stack(
          children: [
            // 1) Soft wave background (same as HomeScreen)
            const _SoftWaveBackground(),
            
            // 2) Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Header
                    _buildHeader(timerState),
                    const SizedBox(height: 48),

                    // Task Info Card
                    if (widget.taskDescription != null)
                      _buildTaskInfo()
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.1, end: 0),

                    const Spacer(),

                    // Timer Circular View
                    CircularTimer(
                      remainingSeconds: timerState.remainingSeconds,
                      totalSeconds: timerState.totalSeconds,
                      isRunning: timerState.isRunning,
                      isPaused: timerState.isPaused,
                      progressColor: widget.emotion.color,
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                          duration: 600.ms,
                          curve: Curves.easeOutBack,
                        )
                        .fadeIn(),

                    const Spacer(),

                    // Control Buttons
                    _buildControls(timerState),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TimerState timerState) {
    // Header label: match quick_start / start_my_routine keys for localized label
    String headerLabel;
    if (widget.taskDescription == 'start_my_routine') {
      headerLabel = AppStrings.defaultDuration(context);
    } else if (widget.taskDescription == 'quick_start') {
      headerLabel = AppStrings.quickStart(context);
    } else {
      headerLabel = widget.emotion.label(context);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Emotion Label Bagde
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.emotion.icon,
                size: 22,
                color: widget.emotion.color,
              ),
              const SizedBox(width: 8),
              Text(
                headerLabel,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: widget.emotion.color,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.1, end: 0),

        // Give Up Button
        TextButton(
          onPressed: _showGiveUpDialog,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            AppStrings.giveUpButton(context),
            style: TextStyle(
              color: Colors.black.withOpacity(0.35),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms),
      ],
    );
  }

  String _getTaskDisplayLabel(BuildContext context) {
    if (widget.taskDescription == 'start_my_routine') {
      return AppStrings.defaultDuration(context);
    }
    if (widget.taskDescription == 'quick_start') {
      return AppStrings.quickStart(context);
    }
    return widget.taskDescription!;
  }

  Widget _buildTaskInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.75), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.emotion.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.task_alt,
              color: widget.emotion.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Localizations.localeOf(context).languageCode == 'ko'
                      ? '현재 작업'
                      : 'Current task',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getTaskDisplayLabel(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF121318),
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
        // Pause/Resume Button
        GestureDetector(
          onTap: _togglePause,
          child: AnimatedContainer(
            duration: 300.ms,
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: timerState.isPaused
                  ? widget.emotion.color
                  : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: (timerState.isPaused ? widget.emotion.color : Colors.black)
                      .withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
              border: timerState.isPaused 
                  ? null 
                  : Border.all(color: Colors.black.withOpacity(0.05)),
            ),
            child: Icon(
              timerState.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              size: 40,
              color: timerState.isPaused ? Colors.white : const Color(0xFF121318),
            ),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
              duration: 400.ms,
            )
            .fadeIn(delay: 400.ms),
      ],
    );
  }
}

// Replicating Home's background for visual harmony
class _SoftWaveBackground extends StatelessWidget {
  const _SoftWaveBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF7F8FC),
              Color(0xFFF3F5FB),
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 260,
            width: double.infinity,
            child: CustomPaint(
              painter: _WavePainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradient1 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF12A594).withOpacity(0.05),
        const Color(0xFF12A594).withOpacity(0.01),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint1 = Paint()
      ..shader = gradient1
      ..style = PaintingStyle.fill;

    // Wave 1
    final p1 = Path();
    p1.moveTo(0, size.height * 0.7);
    p1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.5,
      size.width * 0.50,
      size.height * 0.7,
    );
    p1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.7,
    );
    p1.lineTo(size.width, size.height);
    p1.lineTo(0, size.height);
    p1.close();
    canvas.drawPath(p1, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

