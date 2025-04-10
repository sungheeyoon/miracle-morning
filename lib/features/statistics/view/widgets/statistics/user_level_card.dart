import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/features/statistics/viewmodel/statistics_viewmodel.dart';

class UserLevelCard extends ConsumerWidget {
  final DashboardStatisticsData data;
  const UserLevelCard({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 레벨에 따른 타이틀 결정
    String getLevelTitle(int level) {
      if (level < 5) return "아침의 시작자";
      if (level < 10) return "습관 형성자";
      if (level < 20) return "아침 마스터";
      return "인생 기획자";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade500,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 레벨 및 타이틀 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 레벨 디스플레이
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber[300],
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Lv.${data.currentLevel}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // 타이틀
              Text(
                getLevelTitle(data.currentLevel),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 경험치 프로그레스 바
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "경험치: ${data.currentExp.toInt()} / ${data.requiredExp.toInt()}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "다음 레벨까지 ${data.remainingExp}일",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: data.progressPercentage,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.amber[300] ?? Colors.amber),
                  minHeight: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 스트릭 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStreakItem(
                icon: Icons.local_fire_department,
                value: data.currentStreak,
                label: "현재 스트릭",
                color: Colors.orange,
              ),
              _buildStreakItem(
                icon: Icons.emoji_events,
                value: data.maxStreak,
                label: "최고 스트릭",
                color: Colors.amber,
              ),
              _buildStreakItem(
                icon: Icons.add_circle,
                value: data.streakBonus,
                label: "스트릭 보너스",
                color: Colors.greenAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakItem({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
