import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miracle_morning/features/statistics/view/widgets/statistics/section_header.dart';
import 'package:miracle_morning/features/statistics/view/widgets/statistics/stat_card.dart';
import 'package:miracle_morning/features/statistics/viewmodel/statistics_viewmodel.dart';

class SummaryStatsCard extends StatelessWidget {
  final DashboardStatisticsData data;

  const SummaryStatsCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // 주간 통계 데이터
    final weeklyCompletionRate = data.weeklyCompletionRate;
    final weeklyCompletedCount = data.completedTodosThisWeek;
    final weeklyTotalCount = data.totalTodosThisWeek;

    // 월간 통계 데이터
    final monthlyCompletionRate = data.monthlyCompletionRate;
    final monthlyCompletedCount = data.completedTodosThisMonth;
    final monthlyTotalCount = data.totalTodosThisMonth;

    return Column(
      children: [
        const SectionHeader(title: '이번 달/이번 주 통계', icon: Icons.assessment),
        const SizedBox(height: 8),
        Row(
          children: [
            // 이번 달 통계
            Expanded(
              child: StatCard(
                title: '이번 달',
                date: _getCurrentMonthText(),
                completedCount: monthlyCompletedCount,
                totalCount: monthlyTotalCount,
                completionRate: monthlyCompletionRate,
                icon: Icons.calendar_month,
                iconColor: Colors.indigo,
                gradientColors: [Colors.indigo.shade100, Colors.indigo.shade50],
              ),
            ),

            const SizedBox(width: 12),

            // 이번 주 통계
            Expanded(
              child: StatCard(
                title: '이번 주',
                date: _getCurrentWeekText(),
                completedCount: weeklyCompletedCount,
                totalCount: weeklyTotalCount,
                completionRate: weeklyCompletionRate,
                icon: Icons.view_week,
                iconColor: Colors.teal,
                gradientColors: [Colors.teal.shade100, Colors.teal.shade50],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 이번 주 텍스트 (예: 3월 11일 ~ 3월 17일)
  String _getCurrentWeekText() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final startText = DateFormat('M월 d일').format(startOfWeek);
    final endText = DateFormat('M월 d일').format(endOfWeek);

    return '$startText ~ $endText';
  }

  // 이번 달 텍스트 (예: 2025년 3월)
  String _getCurrentMonthText() {
    final now = DateTime.now();
    return DateFormat('yyyy년 M월').format(now);
  }
}
