import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_durations.dart';
import '../../../data/models/give_up_reason.dart';

/// 포기 확인 다이얼로그
class GiveUpDialog extends StatefulWidget {
  final Function(GiveUpReason) onGiveUp;

  const GiveUpDialog({
    super.key,
    required this.onGiveUp,
  });

  @override
  State<GiveUpDialog> createState() => _GiveUpDialogState();
}

class _GiveUpDialogState extends State<GiveUpDialog> {
  GiveUpReason? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 이모지
            const Text(
              '💪',
              style: TextStyle(fontSize: 48),
            )
                .animate()
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1))
                .fadeIn(),

            const SizedBox(height: 16),

            // 타이틀
            const Text(
              '오늘은 여기까지 할게요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // 서브타이틀
            const Text(
              '괜찮아요, 다음에 다시 도전해요!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // 이유 선택
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '이유를 선택해주세요 (선택)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 이유 목록
            ...GiveUpReason.values.asMap().entries.map((entry) {
              final index = entry.key;
              final reason = entry.value;
              return _ReasonOption(
                reason: reason,
                isSelected: _selectedReason == reason,
                onTap: () => setState(() => _selectedReason = reason),
                delay: Duration(milliseconds: 50 * index),
              );
            }),

            const SizedBox(height: 24),

            // 버튼들
            Row(
              children: [
                // 취소 버튼
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.surfaceLight),
                      ),
                    ),
                    child: const Text(
                      '계속하기',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 포기 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onGiveUp(_selectedReason ?? GiveUpReason.other);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withValues(alpha: 0.8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      Localizations.localeOf(context).languageCode == 'ko'
                          ? '종료하기'
                          : 'End session',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 이유 선택 옵션
class _ReasonOption extends StatelessWidget {
  final GiveUpReason reason;
  final bool isSelected;
  final VoidCallback onTap;
  final Duration delay;

  const _ReasonOption({
    required this.reason,
    required this.isSelected,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.animFast,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              reason.emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                reason.label(context),
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: AppDurations.animNormal)
        .slideX(begin: 0.1, end: 0);
  }
}

