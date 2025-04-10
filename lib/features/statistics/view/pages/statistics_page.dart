import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/core/theme/app_colors.dart';
import 'package:miracle_morning/core/theme/app_text_styles.dart';
import 'package:miracle_morning/core/widgets/common_widgets.dart';
import 'package:miracle_morning/features/statistics/view/widgets/statistics/achievement_badges.dart';
import 'package:miracle_morning/features/statistics/viewmodel/statistics_viewmodel.dart';
import 'package:miracle_morning/features/statistics/view/widgets/statistics/level_up_tips.dart';
import 'package:miracle_morning/features/statistics/view/widgets/statistics/summary_stats_card.dart';
import 'package:miracle_morning/features/statistics/view/widgets/statistics/weekly_activity_chart.dart';
import 'package:miracle_morning/features/statistics/view/widgets/statistics/user_level_card.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardDataAsync = ref.watch(dashboardStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '나의 성장 통계',
          style: AppTextStyles.headline3,
        ),
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: _buildStatisticsContent(dashboardDataAsync),
      ),
    );
  }

  Widget _buildStatisticsContent(AsyncValue dashboardDataAsync) {
    return dashboardDataAsync.when(
      data: (dashboardData) => _buildStatisticsDashboard(dashboardData),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          '데이터 로드 오류: $error',
          style: const TextStyle(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildStatisticsDashboard(dynamic dashboardData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserLevelCard(data: dashboardData),
          const SizedBox(height: 24),
          
          SummaryStatsCard(data: dashboardData),
          const SizedBox(height: 24),
          
          const SectionHeader(title: '주간 완료율', icon: Icons.insert_chart),
          const SizedBox(height: 8),
          WeeklyActivityChart(data: dashboardData),
          const SizedBox(height: 24),
          
          const SectionHeader(title: '획득한 뱃지', icon: Icons.emoji_events),
          const SizedBox(height: 8),
          AchievementBadges(data: dashboardData),
          const SizedBox(height: 24),
          
          LevelUpTips(level: dashboardData.currentLevel),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}