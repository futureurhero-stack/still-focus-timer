import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_durations.dart';
import '../../../shared/widgets/svg_icon.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Still Focus Timer - 산뜻한 화이트 카드 스타일 시작 버튼
class CircularTimerHome extends StatelessWidget {
  final VoidCallback onStart;

  const CircularTimerHome({
    super.key,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final isKo = Localizations.localeOf(context).languageCode == 'ko';

    return FittedBox(
      fit: BoxFit.contain,
      child: GestureDetector(
        onTap: onStart,
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgIcon(
                      assetPath: AppAssets.iconPlay,
                      size: 48,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isKo ? '시작하기' : 'Start',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1, 1),
            duration: AppDurations.animSlow,
          )
          .fadeIn(duration: AppDurations.animNormal),
    );
  }
}
