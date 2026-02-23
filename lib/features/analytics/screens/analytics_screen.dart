import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/repositories/analytics_repository.dart';
import '../../../data/models/daily_stats_model.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../widgets/stats_card.dart';
import '../widgets/daily_story_card.dart';
import '../widgets/weekly_chart.dart';

/// Analytics screen
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _analyticsRepository = AnalyticsRepository();
  DailyStatsModel? _todayStats;
  List<DailyStatsModel>? _weekStats;
  int? _bestFocusHour;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final todayStats = await _analyticsRepository.getTodayStats();
      final weekStats = await _analyticsRepository.getWeekStats();
      final bestHour = await _analyticsRepository.getBestFocusHour();

      setState(() {
        _todayStats = todayStats;
        _weekStats = weekStats;
        _bestFocusHour = bestHour;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    // Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: _buildHeader(),
                      ),
                    ),

                    // Today's story
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: DailyStoryCard(stats: _todayStats),
                      ),
                    ),

                    // Statistic cards
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: _buildStatsGrid(),
                      ),
                    ),

                    // Weekly chart
                    if (_weekStats != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: WeeklyChart(stats: _weekStats!),
                        ),
                      ),

                    // Spacer
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 48),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Back button
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            AppStrings.analyticsTitle(context),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: AppDurations.animNormal)
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatsCard(
                iconPath: AppAssets.iconFocus,
                label: 'Today\'s focus time',
                value: AppDateUtils.formatMinutes(
                  _todayStats?.totalFocusMinutes ?? 0,
                ),
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: StatsCard(
                iconPath: AppAssets.iconCheck,
                label: 'Completed sessions',
                value: '${_todayStats?.completedSessions ?? 0}',
                color: AppColors.success,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: AppDurations.animNormal, delay: 100.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: StatsCard(
                iconPath: AppAssets.iconStar,
                label: 'Completion rate',
                value: '${((_todayStats?.completionRate ?? 0) * 100).toInt()}%',
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: StatsCard(
                iconPath: AppAssets.iconCalendar,
                label: 'Best time of day',
                value: _bestFocusHour != null
                    ? '$_bestFocusHour:00'
                    : 'Not enough data',
                color: AppColors.accent,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: AppDurations.animNormal, delay: 200.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }
}

