import 'package:flutter/material.dart';
import 'package:miracle_morning/features/statistics/viewmodel/statistics_viewmodel.dart';

class AchievementBadges extends StatelessWidget {
  final DashboardStatisticsData data;

  const AchievementBadges({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // 성취 뱃지 데이터 (실제로는 repository에서 가져올 것)
    // 현재 스트릭 및 완료율에 따라 뱃지 잠금 해제 여부 설정
    final badges = [
      {
        'name': '이른 새',
        'desc': '아침 7시 전 앱 사용',
        'icon': Icons.wb_sunny,
        'earned': true
      },
      {
        'name': '${data.currentStreak}일 연속',
        'desc': '현재 스트릭',
        'icon': Icons.local_fire_department,
        'earned': data.currentStreak > 0
      },
      {
        'name': '완벽한 하루',
        'desc': '하루 모든 할 일 완료',
        'icon': Icons.check_circle,
        'earned': data.weeklyCompletionRate >= 100
      },
      {
        'name': '30일 챌린지',
        'desc': '한 달 연속 사용',
        'icon': Icons.calendar_month,
        'earned': data.monthlyCompletionRate >= 100
      },
    ];

    return Container(
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
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              final isEarned = badge['earned'] as bool;

              return Container(
                decoration: BoxDecoration(
                  color: isEarned ? Colors.blue.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isEarned ? Colors.blue.shade200 : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      badge['icon'] as IconData,
                      color: isEarned
                          ? Colors.blue.shade700
                          : Colors.grey.shade400,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      badge['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isEarned
                            ? Colors.blue.shade800
                            : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badge['desc'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isEarned
                            ? Colors.blue.shade600
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              // 모든 뱃지를 보는 페이지로 이동
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.blue.shade200),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              '모든 뱃지 보기',
              style: TextStyle(color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
