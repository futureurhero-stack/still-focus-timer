import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
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
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              SvgIcon(
                assetPath: AppAssets.iconStats,
                size: 48,
                color: AppColors.accent,
              ),
              const SizedBox(width: 16),
              Text(
                 'Weekly focus time',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Chart
          SizedBox(
            height: 400,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                       final stat = stats[groupIndex];
                       return BarTooltipItem(
                         '${stat.totalFocusMinutes} min',
                         const TextStyle(
                           color: AppColors.textPrimary,
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
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              AppDateUtils.getWeekdayName(date.weekday),
                              style: TextStyle(
                                color: isToday
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                                fontSize: 24,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 80,
                      getTitlesWidget: (value, meta) {
                         return Text(
                           '${value.toInt()} min',
                           style: const TextStyle(
                             color: AppColors.textMuted,
                             fontSize: 20,
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
                      color: AppColors.surfaceLight,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                barGroups: _generateBarGroups(),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(
                color: AppColors.primary,
                label: 'Focus time',
              ),
            ],
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
            gradient: isToday
                ? AppColors.primaryGradient
                : LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.accent.withValues(alpha: 0.5),
                      AppColors.accent.withValues(alpha: 0.8),
                    ],
                  ),
            width: 56,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
        ],
      );
    }).toList();
  }
}

/// 범례 아이템
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

