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
      backgroundColor: const Color(0xFFF7F8FC),
      body: Stack(
        children: [
          // 1) Soft wave background
          const _SoftWaveBackground(),

          // 2) Content
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      // Header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          child: _buildHeader(),
                        ),
                      ),

                      // Today's story
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: DailyStoryCard(stats: _todayStats),
                        ),
                      ),

                      // Statistic cards
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: _buildStatsGrid(),
                        ),
                      ),

                      // Weekly chart
                      if (_weekStats != null)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
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
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Back button (explicitly go Home because Stats is a bottom tab)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => context.go('/'),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF121318),
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'YOUR JOURNEY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.accent,
                  letterSpacing: 2,
                ),
              ),
              Text(
                AppStrings.analyticsTitle(context),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF121318),
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: -0.1, end: 0);
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatsCard(
                iconPath: AppAssets.iconFocus,
                label: AppStrings.focusTime(context),
                value: AppDateUtils.formatMinutes(
                  context,
                  _todayStats?.totalFocusMinutes ?? 0,
                ),
                color: AppColors.emotionStressed,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                iconPath: AppAssets.iconCheck,
                label: AppStrings.sessions(context),
                value: '${_todayStats?.completedSessions ?? 0}',
                color: AppColors.emotionTired,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideY(begin: 0.1, end: 0),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: StatsCard(
                iconPath: AppAssets.iconStar,
                label: AppStrings.goalRate(context),
                value: '${((_todayStats?.completionRate ?? 0) * 100).toInt()}%',
                color: AppColors.emotionSleepy,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatsCard(
                iconPath: AppAssets.iconCalendar,
                label: AppStrings.bestHour(context),
                value: _bestFocusHour != null
                    ? '$_bestFocusHour:00'
                    : '--:--',
                color: AppColors.emotionGood,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms)
            .slideY(begin: 0.1, end: 0),
      ],
    );
  }
}

// Replicating Home's background for visual harmony
class _SoftWaveBackground extends StatelessWidget {
  const _SoftWaveBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF7F8FC),
              Color(0xFFF3F5FB),
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 260,
            width: double.infinity,
            child: CustomPaint(
              painter: _WavePainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradient1 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF12A594).withValues(alpha: 0.05),
        const Color(0xFF12A594).withValues(alpha: 0.01),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint1 = Paint()
      ..shader = gradient1
      ..style = PaintingStyle.fill;

    // Wave 1
    final p1 = Path();
    p1.moveTo(0, size.height * 0.7);
    p1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.5,
      size.width * 0.50,
      size.height * 0.7,
    );
    p1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.7,
    );
    p1.lineTo(size.width, size.height);
    p1.lineTo(0, size.height);
    p1.close();
    canvas.drawPath(p1, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

