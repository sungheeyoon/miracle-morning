import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/features/statistics/viewmodel/streak_viewmodel.dart';

class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakViewModelProvider);

    return streakAsync.when(
      data: (streakData) {
        final currentStreak = streakData["currentStreak"] ?? 0;
        final maxStreak = streakData["maxStreak"] ?? 0;

        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  '🔥 Current Streak',
                ),
                const SizedBox(height: 8),
                Text(
                  '$currentStreak days',
                ),
                const Divider(),
                const Text(
                  '🏆 Max Streak',
                ),
                const SizedBox(height: 8),
                Text(
                  '$maxStreak days',
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
