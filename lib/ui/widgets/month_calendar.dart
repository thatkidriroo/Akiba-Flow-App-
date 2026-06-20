import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_theme.dart';

class MonthCalendar extends StatefulWidget {
  const MonthCalendar({super.key});

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  void _prev() {
    setState(() {
      _month--;
      if (_month == 0) {
        _month = 12;
        _year--;
      }
    });
  }

  void _next() {
    setState(() {
      _month++;
      if (_month == 13) {
        _month = 1;
        _year++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, prov, _) {
        final t = prov.themeTokens;
        final profitLoss = prov.getDailyProfitLoss(_year, _month);
        final firstDay = DateTime(_year, _month, 1);
        final daysInMonth = DateTime(_year, _month + 1, 0).day;
        final startWeekday = firstDay.weekday % 7;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _prev,
                  child: Icon(Icons.chevron_left_rounded, color: AppColors.primary, size: 24),
                ),
                Text(
                  _monthNames[_month - 1],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: t.text),
                ),
                SizedBox(
                  width: 40,
                  child: Text('$_year',
                      style: TextStyle(fontSize: 11, color: t.muted)),
                ),
                GestureDetector(
                  onTap: _next,
                  child: Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) => Expanded(
                child: Text(d, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: t.muted)),
              )).toList(),
            ),
            const SizedBox(height: 4),
            ...List.generate(_weeks(startWeekday, daysInMonth).length, (wi) {
              final week = _weeks(startWeekday, daysInMonth)[wi];
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: week.map((day) => Expanded(
                    child: day == 0
                        ? const SizedBox(height: 40)
                        : _dayCell(day, profitLoss[day], t, prov),
                  )).toList(),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  List<List<int>> _weeks(int startWeekday, int daysInMonth) {
    final weeks = <List<int>>[];
    var currentWeek = List.filled(7, 0);
    var day = 1;
    var col = startWeekday;
    while (day <= daysInMonth) {
      currentWeek[col] = day;
      day++;
      col++;
      if (col == 7) {
        weeks.add(currentWeek);
        currentWeek = List.filled(7, 0);
        col = 0;
      }
    }
    if (currentWeek.any((d) => d != 0)) {
      weeks.add(currentWeek);
    }
    return weeks;
  }

  Widget _dayCell(int day, double? net, ThemeTokens t, DashboardProvider prov) {
    final hasData = net != null;
    final isProfit = hasData && net >= 0;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: hasData
            ? (isProfit
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.coral.withValues(alpha: 0.08))
            : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$day',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: hasData
                    ? (isProfit ? AppColors.primary : AppColors.coral)
                    : t.muted,
              )),
          if (hasData)
            Text(
              '${isProfit ? '+' : ''}${prov.fmtCompact(net.abs())}',
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w500,
                color: isProfit ? AppColors.primary : AppColors.coral,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
