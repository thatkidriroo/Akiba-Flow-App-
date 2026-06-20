import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_theme.dart';

class WeeklySpendingChart extends StatelessWidget {
  const WeeklySpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, prov, _) {
        final t = prov.themeTokens;
        final data = prov.getWeeklySpending();
        if (data.isEmpty || data.every((v) => v == 0)) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text('No expense data yet', style: TextStyle(fontSize: 12, color: t.muted)),
            ),
          );
        }
        final maxY = data.reduce((a, b) => a > b ? a : b);
        final adjustedMax = maxY * 1.2;

        return SizedBox(
          height: 100,
          child: BarChart(
            BarChartData(
              maxY: adjustedMax,
              minY: 0,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: adjustedMax / 4,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: t.border.withValues(alpha: 0.3),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                      getTitlesWidget: (value, _) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= 7) return const SizedBox.shrink();
                      final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(days[idx],
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: t.muted)),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(data.length, (i) {
                final pct = maxY > 0 ? data[i] / maxY : 0.0;
                final color = pct > 0.7 ? AppColors.coral : pct > 0.4 ? AppColors.accent : AppColors.primary;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: data[i],
                      color: color,
                      width: 14,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
