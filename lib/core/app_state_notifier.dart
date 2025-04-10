import 'package:miracle_morning/features/statistics/repositories/growth_repository.dart';
import 'package:miracle_morning/features/statistics/viewmodel/growth_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_state_notifier.g.dart';

@riverpod
class AppStateNotifier extends _$AppStateNotifier {
  @override
  Future<void> build() async {
    await _checkAndUpdateGrowth();
    return;
  }

  Future<void> _checkAndUpdateGrowth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month}-${today.day}';
      final lastUpdateStr = prefs.getString('last_growth_update');

      if (lastUpdateStr != todayStr) {
        final yesterday = DateTime(today.year, today.month, today.day - 1);

        final growthRepo = await ref.watch(growthRepositoryProvider.future);
        final viewModel = ref.read(growthViewModelProvider.notifier);
        await viewModel.updateGrowth(yesterday);
        await prefs.setString('last_growth_update', todayStr);
      }
    } catch (e) {
      // 오류 발생 시 정적 로그만 남기고 진행
    }
  }

  Future<void> manualUpdateGrowth() async {
    state.whenData((_) async {
      await _checkAndUpdateGrowth();
    });
  }
}
