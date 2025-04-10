import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/core/app_state_notifier.dart';
import 'package:miracle_morning/core/init/app_initializer.dart';
import 'package:miracle_morning/core/providers/all_boxes_provider.dart';
import 'package:miracle_morning/core/theme/app_theme.dart';
import 'package:miracle_morning/error_screen.dart';
import 'package:miracle_morning/loading_screen.dart';
import 'package:miracle_morning/root_tab.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBoxesState = ref.watch(allBoxesProvider);
    ref.watch(appStateNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Miracle Morning',
      theme: AppTheme.lightTheme,
      home: _buildHomeScreen(allBoxesState),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko', 'KR'),
    );
  }

  Widget _buildHomeScreen(AsyncValue allBoxesState) {
    return allBoxesState.when(
      data: (allBoxes) => const RootTab(),
      loading: () => const LoadingScreen(),
      error: (error, stack) => ErrorScreen(
        message: '데이터 초기화 중 오류: ${error.toString()}',
      ),
    );
  }
}