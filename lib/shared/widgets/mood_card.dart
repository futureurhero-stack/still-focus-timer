import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../data/models/emotion_type.dart';

/// 감정 선택 카드 위젯 (Neumorphism 스타일)
/// 2x2 그리드에서 사용되는 카드
class MoodCard extends StatefulWidget {
  final EmotionType emotion;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodCard({
    super.key,
    required this.emotion,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<MoodCard> {
  bool _isPressed = false;

  /// 감정별 배경 색상 (이미지 기반)
  Color _getBackgroundColor() {
    switch (widget.emotion) {
      case EmotionType.tired:
        return const Color(0xFFE3F2FD); // 연한 파란색 (Reluctant)
      case EmotionType.stressed:
        return const Color(0xFFFFE0E6); // 연한 빨강/핑크 (Stressed)
      case EmotionType.sleepy:
        return const Color(0xFFE0F2F1); // 연한 청록/녹색 (Sleepy)
      case EmotionType.good:
        return const Color(0xFFE8F5E9); // 연한 녹색 (Good)
    }
  }

  /// 세션 시간 범위 텍스트 (언어별)
  String _getSessionRange(BuildContext context) {
    final isKo = Localizations.localeOf(context).languageCode == 'ko';

    switch (widget.emotion) {
      case EmotionType.tired:
        return isKo ? '5-10분 세션' : '5-10m session';
      case EmotionType.stressed:
        return isKo ? '10-15분 세션' : '10-15m session';
      case EmotionType.sleepy:
        return isKo ? '15-20분 세션' : '15-20m session';
      case EmotionType.good:
        return isKo ? '20-25분 세션' : '20-25m session';
    }
  }

  /// 감정 아이콘 (이미지 설명 기반)
  Widget _buildIcon() {
    switch (widget.emotion) {
      case EmotionType.tired:
        // 슬럼프한 사람 아이콘
        return CustomPaint(
          size: const Size(48, 48),
          painter: _ReluctantIconPainter(),
        );
      case EmotionType.stressed:
        // 번개 구름 아이콘
        return CustomPaint(
          size: const Size(48, 48),
          painter: _StressedIconPainter(),
        );
      case EmotionType.sleepy:
        // 달과 별 아이콘
        return CustomPaint(
          size: const Size(48, 48),
          painter: _SleepyIconPainter(),
        );
      case EmotionType.good:
        // 웃는 태양 아이콘
        return CustomPaint(
          size: const Size(48, 48),
          painter: _GoodIconPainter(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: AppDurations.animFast,
        child: Container(
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              // Neumorphism 효과: 외부 그림자
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.7),
                blurRadius: 8,
                offset: const Offset(-4, -4),
                spreadRadius: 0,
              ),
              // Neumorphism 효과: 내부 그림자
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(4, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(),
                const SizedBox(height: 16),
                Text(
                  widget.emotion.label(context),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getSessionRange(context),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reluctant 아이콘 페인터 (슬럼프한 사람)
class _ReluctantIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // 머리 (원)
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.25),
      size.width * 0.12,
      paint,
    );

    // 몸통 (슬럼프한 자세)
    final path = Path();
    path.moveTo(size.width / 2, size.height * 0.37);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.2,
      size.height * 0.7,
    );
    canvas.drawPath(path, paint);

    // 팔 (내려진 자세)
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.45),
      Offset(size.width * 0.15, size.height * 0.65),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Stressed 아이콘 페인터 (번개 구름)
class _StressedIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // 구름
    final cloudPath = Path();
    cloudPath.moveTo(size.width * 0.2, size.height * 0.4);
    cloudPath.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.3,
      size.width * 0.3,
      size.height * 0.3,
    );
    cloudPath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.15,
      size.width * 0.5,
      size.height * 0.15,
    );
    cloudPath.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.05,
      size.width * 0.7,
      size.height * 0.1,
    );
    cloudPath.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.05,
      size.width * 0.85,
      size.height * 0.2,
    );
    cloudPath.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.2,
      size.width * 0.9,
      size.height * 0.35,
    );
    cloudPath.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.45,
    );
    cloudPath.lineTo(size.width * 0.2, size.height * 0.45);
    cloudPath.close();
    canvas.drawPath(cloudPath, paint);

    // 번개
    final lightningPath = Path();
    lightningPath.moveTo(size.width * 0.5, size.height * 0.2);
    lightningPath.lineTo(size.width * 0.45, size.height * 0.4);
    lightningPath.lineTo(size.width * 0.55, size.height * 0.4);
    lightningPath.lineTo(size.width * 0.5, size.height * 0.7);
    canvas.drawPath(lightningPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Sleepy 아이콘 페인터 (달과 별)
class _SleepyIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // 달 (초승달)
    final moonPath = Path();
    moonPath.addArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.35, size.height * 0.4),
        radius: size.width * 0.15,
      ),
      -0.5,
      3.14,
    );
    canvas.drawPath(moonPath, paint);

    // 별 1
    _drawStar(canvas, Offset(size.width * 0.7, size.height * 0.3), 8, paint);
    // 별 2
    _drawStar(canvas, Offset(size.width * 0.8, size.height * 0.5), 6, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - (math.pi / 2);
      final x = center.dx + radius * (i % 2 == 0 ? 1 : 0.5) * math.cos(angle);
      final y = center.dy + radius * (i % 2 == 0 ? 1 : 0.5) * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Good 아이콘 페인터 (웃는 태양)
class _GoodIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // 태양 원
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.2,
      paint,
    );

    // 웃는 얼굴
    // 왼쪽 눈
    canvas.drawCircle(
      Offset(size.width * 0.42, size.height * 0.45),
      size.width * 0.03,
      paint..style = PaintingStyle.fill,
    );
    // 오른쪽 눈
    canvas.drawCircle(
      Offset(size.width * 0.58, size.height * 0.45),
      size.width * 0.03,
      paint..style = PaintingStyle.fill,
    );

    // 웃는 입
    final smilePath = Path();
    smilePath.addArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.55),
        width: size.width * 0.15,
        height: size.height * 0.1,
      ),
      0,
      3.14159,
    );
    canvas.drawPath(smilePath, paint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

