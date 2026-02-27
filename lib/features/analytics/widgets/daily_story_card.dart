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
    const glowColor = Color(0xFFE87D54);
    final glowB = glowColor.withValues(alpha: 0.04);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFFFFF),
            glowB,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF121318).withValues(alpha: 0.08), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // Background glow
            Positioned(
              left: -30,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: glowColor.withValues(alpha: 0.06),
                ),
              ),
            ),

            // Bottom accent bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      glowColor.withValues(alpha: 0.6),
                      glowColor.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          size: 24,
                          color: glowColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        AppStrings.dailyStoryTitle(context),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF121318),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Story content
                  Text(
                    _generateStory(context),
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF121318).withValues(alpha: 0.7),
                    ),
                  ),

                  // Share button
                  if (stats?.hasAnySession == true) ...[
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _shareStory(context),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        icon: const Icon(Icons.share_rounded, size: 18),
                        label: Text(
                          AppStrings.shareStory(context),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10), // Padding for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
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
          AppDateUtils.formatMinutes(context, stats!.totalFocusMinutes);
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

    final appBrand = 'Still: Focus Timer';
    final shareText = isKo
        ? '''
📖 오늘의 집중 스토리 ($dateStr)

$story

$appBrand
#StillFocusTimer #스틸포커스타이머 #집중 #고요한집중
'''
        : '''
📖 Today's focus story ($dateStr)

$story

$appBrand
#StillFocusTimer #FocusTimer #Still #MindfulFocus
''';
    
    Share.share(shareText);
  }
}

