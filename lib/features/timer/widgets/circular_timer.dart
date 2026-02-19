import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// 원형 타이머 위젯
class CircularTimer extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final bool isPaused;
  final Color progressColor;

  const CircularTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.isRunning,
    required this.isPaused,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds > 0
        ? (totalSeconds - remainingSeconds) / totalSeconds
        : 0.0;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 배경 원
          CustomPaint(
            size: const Size(280, 280),
            painter: _CircularProgressPainter(
              progress: 1.0,
              color: AppColors.surfaceLight,
              strokeWidth: 8,
            ),
          ),
          // 진행 원
          CustomPaint(
            size: const Size(280, 280),
            painter: _CircularProgressPainter(
              progress: progress,
              color: progressColor,
              strokeWidth: 8,
            ),
          ),
          // 중앙 텍스트
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(remainingSeconds),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isPaused
                    ? (Localizations.localeOf(context).languageCode == 'ko'
                        ? '일시정지'
                        : 'Paused')
                    : isRunning
                        ? (Localizations.localeOf(context).languageCode == 'ko'
                            ? '집중 중'
                            : 'Focusing')
                        : (Localizations.localeOf(context).languageCode == 'ko'
                            ? '준비'
                            : 'Ready'),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

/// 원형 프로그레스 페인터
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 시작 각도: 상단에서 시작 (12시 방향)
    const startAngle = -90 * 3.14159 / 180;
    final sweepAngle = 2 * 3.14159 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

