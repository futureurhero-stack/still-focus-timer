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
    final isKo = Localizations.localeOf(context).languageCode == 'ko';

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              // Subtle brand accent glow
              Positioned(
                top: -60,
                right: -60,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withOpacity(0.12),
                        AppColors.accent.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Icon with Brand Identity
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.self_improvement_rounded,
                        size: 32,
                        color: AppColors.accent,
                      ),
                    )
                        .animate()
                        .scale(begin: const Offset(0.7, 0.7), end: const Offset(1, 1), curve: Curves.easeOutBack)
                        .fadeIn(duration: 400.ms),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      isKo ? '잠시 쉬어갈까요?' : 'Taking a break?',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF121318),
                        letterSpacing: -0.8,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      isKo
                          ? '괜찮아요! 쉬는 것도 과정의 일부예요.\n지금까지 쌓인 진전은 여전히 소중해요.'
                          : "It's okay! Rest is part of the process.\nYour progress is always valuable.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF121318).withOpacity(0.5),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Reason Section Title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isKo ? '왜 멈추려고 하나요?' : 'WHY ARE YOU STOPPING?',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accent.withOpacity(0.6),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Reasons List
                    ...GiveUpReason.values.asMap().entries.map((entry) {
                      final index = entry.key;
                      final reason = entry.value;
                      return _ReasonOption(
                        reason: reason,
                        isSelected: _selectedReason == reason,
                        onTap: () => setState(() => _selectedReason = reason),
                        delay: Duration(milliseconds: 100 + (50 * index)),
                      );
                    }),

                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.black.withOpacity(0.06)),
                              ),
                            ),
                            child: Text(
                              isKo ? '계속하기' : 'Keep going',
                              style: const TextStyle(
                                color: Color(0xFF121318),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                widget.onGiveUp(_selectedReason ?? GiveUpReason.other);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                isKo ? '세션 종료' : 'End session',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
              ? AppColors.accent.withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.black.withOpacity(0.05),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              reason.icon,
              size: 24,
              color: isSelected ? AppColors.accent : const Color(0xFF121318).withOpacity(0.3),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                reason.label(context),
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? AppColors.accent : const Color(0xFF121318),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.accent,
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

