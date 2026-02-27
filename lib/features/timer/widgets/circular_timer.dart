import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Still Focus Timer - 산뜻한 원형 타이머 (샘플 스타일)
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

    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 320,
        height: 320,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 배경 트랙 (진행 색상의 연한 버전으로 선명하게 표시)
            CustomPaint(
              size: const Size(320, 320),
              painter: _CircularProgressPainter(
                progress: 1.0,
                color: progressColor.withOpacity(0.12),
                strokeWidth: 16,
              ),
            ),
            // 내부 테두리 (입체감을 위한 보조 선)
            CustomPaint(
              size: const Size(320, 320),
              painter: _CircularProgressPainter(
                progress: 1.0,
                color: Colors.black.withOpacity(0.03),
                strokeWidth: 1,
              ),
            ),
            // 진행 링 (액센트 컬러)
            CustomPaint(
              size: const Size(320, 320),
              painter: _CircularProgressPainter(
                progress: progress,
                color: progressColor,
                strokeWidth: 16,
              ),
            ),
            // 중앙 시간 표시
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(remainingSeconds),
                  style: const TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF121318),
                    fontFamily: 'Pretendard',
                    letterSpacing: -1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
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
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -90 * 3.14159 / 180;
    final sweepAngle = 2 * 3.14159 * progress;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

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
