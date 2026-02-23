import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/svg_icon.dart';

/// 통계 카드 위젯
class StatsCard extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final String label;
  final String value;
  final Color color;

  const StatsCard({
    super.key,
    this.icon,
    this.iconPath,
    required this.label,
    required this.value,
    required this.color,
  }) : assert(icon != null || iconPath != null, 'icon or iconPath required');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: iconPath != null
                ? SvgIcon(
                    assetPath: iconPath!,
                    size: 48,
                    color: color,
                  )
                : Icon(
                    icon!,
                    color: color,
                    size: 48,
                  ),
          ),
          const SizedBox(height: 32),

          // 레이블
          Text(
            label,
            style: const TextStyle(
              fontSize: 24,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // 값
          Text(
            value,
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

