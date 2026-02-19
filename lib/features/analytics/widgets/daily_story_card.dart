import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/daily_stats_model.dart';

/// 일일 스토리 카드
class DailyStoryCard extends StatelessWidget {
  final DailyStatsModel? stats;

  const DailyStoryCard({
    super.key,
    this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.secondary.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Row(
            children: [
              const Text(
                '📖',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.dailyStoryTitle(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 스토리 내용
          Text(
            _generateStory(context),
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),

          // 공유 버튼
          if (stats?.hasAnySession == true) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _shareStory(context),
                  icon: const Icon(
                    Icons.share_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    AppStrings.shareStory(context),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.animNormal)
        .slideY(begin: 0.2, end: 0);
  }

  String _generateStory(BuildContext context) {
    if (stats == null || !stats!.hasAnySession) {
      final base = AppStrings.noSessionToday(context);
      final isKo = Localizations.localeOf(context).languageCode == 'ko';
      final prompt = isKo
          ? '\n\n지금 첫 세션을 시작해보세요! 🚀'
          : '\n\nStart your first session now! 🚀';
      return '$base$prompt';
    }

    final buffer = StringBuffer();

    final isKo = Localizations.localeOf(context).languageCode == 'ko';

    // Sessions summary
    if (stats!.totalSessions == 1) {
      buffer.writeln(isKo
          ? '오늘 당신은 한 번의 집중 세션을 시작했습니다.'
          : 'Today you started one focus session.');
    } else {
      buffer.writeln(isKo
          ? '오늘 당신은 ${stats!.totalSessions}번의 집중 세션에 도전했습니다.'
          : 'Today you attempted ${stats!.totalSessions} focus sessions.');
    }

    // Completion summary
    if (stats!.completedSessions > 0) {
      if (stats!.completedSessions == stats!.totalSessions) {
        buffer.writeln(isKo
            ? '그리고 모든 세션을 완료했어요! 👏'
            : 'And you completed every session! 👏');
      } else {
        buffer.writeln(isKo
            ? '그 중 ${stats!.completedSessions}개를 완료했습니다.'
            : 'You completed ${stats!.completedSessions} of them.');
      }
    }

    // Given-up sessions
    if (stats!.givenUpSessions > 0) {
      buffer.writeln(isKo
          ? '중간에 멈춘 세션도 있지만, 시작한 것만으로도 대단해요.'
          : 'You stopped a few sessions, but just starting is a win.');
    }

    // Best focus time
    if (stats!.bestFocusHour != null) {
      final hour = stats!.bestFocusHour!;
      final timeLabel = AppDateUtils.getTimeOfDayString(
        DateTime.now().copyWith(hour: hour),
      );
      buffer.writeln(isKo
          ? '\n가장 집중이 잘 된 시간은 $timeLabel ${hour % 12 == 0 ? 12 : hour % 12}시였습니다. ⏰'
          : '\nYour best focus time was around $timeLabel ${hour % 12 == 0 ? 12 : hour % 12} o\'clock. ⏰');
    }

    // Total focus time
    if (stats!.totalFocusMinutes > 0) {
      final formattedTime =
          AppDateUtils.formatMinutes(stats!.totalFocusMinutes);
      buffer.writeln(isKo
          ? '\n총 $formattedTime 동안 집중했어요! 🔥'
          : '\nYou focused for a total of $formattedTime today! 🔥');
    }

    return buffer.toString().trim();
  }

  /// 스토리 공유 기능
  void _shareStory(BuildContext context) {
    final story = _generateStory(context);
    final today = DateTime.now();
    final dateStr = '${today.year}.${today.month}.${today.day}';
    
    final isKo = Localizations.localeOf(context).languageCode == 'ko';

    final shareText = isKo
        ? '''
📖 오늘의 집중 스토리 ($dateStr)

$story

#FocusFlow #집중 #포모도로
'''
        : '''
📖 Today's focus story ($dateStr)

$story

#FocusFlow #focus #pomodoro
''';
    
    Share.share(shareText);
  }
}

