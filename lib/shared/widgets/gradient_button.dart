import 'package:flutter/material.dart';
import '../../core/constants/app_durations.dart';

/// 그라데이션 버튼 위젯 (Quick Start 버튼용)
/// 보라색 중심의 그라데이션 배경
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppDurations.animFast,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 64,
          decoration: BoxDecoration(
            // 보라색 중심 그라데이션 (이미지 기반)
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF9C88FF), // 보라색 중심
                Color(0xFFB19DFF), // 밝은 보라색
                Color(0xFFFFB84D), // 오렌지 (테두리 효과)
              ],
              stops: [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              // 부드러운 그림자
              BoxShadow(
                color: const Color(0xFF9C88FF).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Pretendard',
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

