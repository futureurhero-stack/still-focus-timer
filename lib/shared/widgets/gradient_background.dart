import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// 그라디언트 배경 위젯
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: child,
    );
  }
}

/// 배경 장식용 오브 위젯
class BackgroundOrb extends StatelessWidget {
  final Color color;
  final double size;
  final Alignment alignment;

  const BackgroundOrb({
    super.key,
    required this.color,
    required this.size,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.3),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

