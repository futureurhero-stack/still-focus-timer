import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/svg_icon.dart';
import '../../../core/constants/app_durations.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 집중 통계 카드 - 산뜻한 화이트 카드 스타일
class FocusStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String message;
  final bool isLoading;
  final String? iconPath;

  const FocusStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.message,
    this.isLoading = false,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;
    final padding = isCompact ? 16.0 : 20.0;
    final valueFontSize = isCompact ? 32.0 : 40.0;
    final titleFontSize = isCompact ? 16.0 : 18.0;
    final radius = isCompact ? 20.0 : 24.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconPath != null) ...[
            SvgIcon(
              assetPath: iconPath!,
              size: isCompact ? 20 : 24,
              color: AppColors.accent,
            ),
            SizedBox(height: isCompact ? 8 : 10),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              fontFamily: 'Pretendard',
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: isCompact ? 8 : 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  isLoading ? '--' : value,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Pretendard',
                    height: 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: EdgeInsets.only(bottom: isCompact ? 4 : 6),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    fontFamily: 'Pretendard',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 6 : 8),
          Text(
            message,
            style: TextStyle(
              fontSize: isCompact ? 12 : 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              fontFamily: 'Pretendard',
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.animNormal, delay: 100.ms)
        .slideY(begin: 0.08, end: 0);
  }
}
