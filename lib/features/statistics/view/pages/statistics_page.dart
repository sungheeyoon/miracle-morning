import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/features/statistics/view/widgets/streak_card.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SafeArea(
      child: Column(
        children: [
          Text('Statistics'),
          StreakCard(),
        ],
      ),
    );
  }
}
