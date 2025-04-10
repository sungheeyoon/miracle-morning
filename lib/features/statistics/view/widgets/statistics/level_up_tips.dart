import 'package:flutter/material.dart';

class LevelUpTips extends StatelessWidget {
  final int level;

  const LevelUpTips({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    String tipText;

    // 레벨에 따른 팁 지정
    if (level < 5) {
      tipText = '매일 아침 같은 시간에 앱을 열어 할 일을 정하는 습관을 들이면 더 빠르게 레벨업할 수 있어요!';
    } else if (level < 10) {
      tipText = '모든 할 일에 상세한 리뷰를 작성하면 추가 경험치를 얻을 수 있어요. 오늘 하루를 돌아보세요.';
    } else {
      tipText = '연속 30일을 달성하면 특별한 뱃지와 보너스 경험치를 획득할 수 있어요!';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: Colors.amber.shade700, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '레벨업 팁',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tipText,
                  style: TextStyle(
                    color: Colors.amber.shade900,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
