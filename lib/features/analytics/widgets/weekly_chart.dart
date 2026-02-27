import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/svg_icon.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/daily_stats_model.dart';

/// Weekly statistics chart
class WeeklyChart extends StatelessWidget {
  final List<DailyStatsModel> stats;

  const WeeklyChart({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.insert_chart_outlined_rounded,
                  size: 20,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.weeklyFocusTime(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF121318),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Chart
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: const Color(0xFF121318),
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final stat = stats[groupIndex];
                      return BarTooltipItem(
                        '${stat.totalFocusMinutes}m',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < stats.length) {
                          final date = stats[index].date;
                          final isToday = AppDateUtils.isToday(date);
                          final fullName =
                              AppDateUtils.getWeekdayName(date.weekday);
                          final label = fullName.length <= 3
                              ? fullName
                              : fullName.substring(0, 3);
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: isToday
                                    ? AppColors.accent
                                    : const Color(0xFF121318)
                                        .withValues(alpha: 0.3),
                                fontSize: 11,
                                fontWeight: isToday
                                    ? FontWeight.w900
                                    : FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 32,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: _getMaxY() / 4,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const Text('');
                        return Text(
                          '${value.toInt()}m',
                          style: TextStyle(
                            color: const Color(0xFF121318).withValues(alpha: 0.2),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getMaxY() / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFF121318).withValues(alpha: 0.05),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: _generateBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    if (stats.isEmpty) return 60;
    final maxMinutes = stats
        .map((s) => s.totalFocusMinutes)
        .reduce((a, b) => a > b ? a : b);
    return (maxMinutes + 10).toDouble().clamp(30, double.infinity);
  }

  List<BarChartGroupData> _generateBarGroups() {
    return stats.asMap().entries.map((entry) {
      final index = entry.key;
      final stat = entry.value;
      final isToday = AppDateUtils.isToday(stat.date);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: stat.totalFocusMinutes.toDouble(),
            color: isToday ? AppColors.accent : AppColors.accent.withValues(alpha: 0.2),
            width: 16,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxY(),
              color: const Color(0xFF121318).withValues(alpha: 0.03),
            ),
          ),
        ],
      );
    }).toList();
  }
}

