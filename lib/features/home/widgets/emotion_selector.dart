import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_durations.dart';
import '../../../data/models/emotion_type.dart';

/// Emotion selection widget
class EmotionSelector extends StatelessWidget {
  final EmotionType? selectedEmotion;
  final ValueChanged<EmotionType> onEmotionSelected;

  const EmotionSelector({
    super.key,
    this.selectedEmotion,
    required this.onEmotionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How do you feel right now?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: EmotionType.values.asMap().entries.map((entry) {
            final index = entry.key;
            final emotion = entry.value;
            return _EmotionCard(
              emotion: emotion,
              isSelected: selectedEmotion == emotion,
              onTap: () => onEmotionSelected(emotion),
              delay: Duration(milliseconds: 100 * index),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Single emotion card
class _EmotionCard extends StatefulWidget {
  final EmotionType emotion;
  final bool isSelected;
  final VoidCallback onTap;
  final Duration delay;

  const _EmotionCard({
    required this.emotion,
    required this.isSelected,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_EmotionCard> createState() => _EmotionCardState();
}

class _EmotionCardState extends State<_EmotionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: AppDurations.animFast,
        child: AnimatedContainer(
          duration: AppDurations.animNormal,
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.emotion.color.withValues(alpha: 0.2)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? widget.emotion.color
                  : AppColors.surfaceLight,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.emotion.color.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji
              Text(
                widget.emotion.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              // Emotion label
              Text(
                widget.emotion.label(context),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: widget.isSelected
                      ? widget.emotion.color
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: widget.delay)
        .fadeIn(duration: AppDurations.animNormal)
        .slideY(begin: 0.3, end: 0);
  }
}

/// Card showing details of the selected emotion
class EmotionInfoCard extends StatelessWidget {
  final EmotionType emotion;

  const EmotionInfoCard({
    super.key,
    required this.emotion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: emotion.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: emotion.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Emoji and info
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: emotion.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                emotion.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emotion.label(context),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: emotion.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  emotion.description(context),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Recommended time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: emotion.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${emotion.recommendedDuration} min',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: emotion.color,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.animNormal)
        .slideY(begin: 0.2, end: 0);
  }
}

