import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:miracle_morning/features/statistics/viewmodel/statistics_viewmodel.dart';

class WeeklyActivityChart extends StatelessWidget {
  final DashboardStatisticsData data;

  const WeeklyActivityChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final weekdayNames = ['월', '화', '수', '목', '금', '토', '일'];

    // 요일별 완료율 (없는 요일은 0으로 설정)
    final List<double> rates = List.generate(7, (index) {
      // 완료율을 퍼센트로 변환 (0.0~1.0 -> 0~100)
      return (data.weeklyCompletionRateByDay[index + 1] ?? 0.0) * 100;
    });

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '요일별 할 일 완료율 (${(data.weeklyCompletionRate * 100).toStringAsFixed(1)}%)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(1)}%',
                        const TextStyle(
                          color: Colors.white,
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
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < 7) {
                          return Text(
                            weekdayNames[index],
                            style: const TextStyle(
                              color: Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value == 0) return const Text('0%');
                        if (value == 50) return const Text('50%');
                        if (value == 100) return const Text('100%');
                        return const Text('');
                      },
                      reservedSize: 28,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (index) {
                  return _makeBarGroup(index, rates[index]);
                }),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    if (value == 0 || value == 50 || value == 100) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    }
                    return const FlLine(
                      color: Colors.transparent,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    // 요일별로 다른 색상 사용
    final List<List<Color>> colorSets = [
      [Colors.blue.shade300, Colors.blue.shade500], // 월요일
      [Colors.indigo.shade300, Colors.indigo.shade500], // 화요일
      [Colors.purple.shade300, Colors.purple.shade500], // 수요일
      [Colors.green.shade300, Colors.green.shade500], // 목요일
      [Colors.amber.shade300, Colors.amber.shade500], // 금요일
      [Colors.orange.shade300, Colors.orange.shade500], // 토요일
      [Colors.red.shade300, Colors.red.shade500], // 일요일
    ];

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y, // 이미 퍼센트로 변환된 값 (0~100)
          gradient: LinearGradient(
            colors: colorSets[x],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}
