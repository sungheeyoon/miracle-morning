import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miracle_morning/core/notification/notification_service.dart';
import 'package:miracle_morning/core/providers/all_boxes_provider.dart';
import 'package:miracle_morning/main_page.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  tz.initializeTimeZones();
  final localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBoxesState = ref.watch(allBoxesProvider);

    return MaterialApp(
      title: 'Miracle Morning',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: allBoxesState.when(
        data: (allBoxes) {
          // 모든 박스 성공적으로 오픈
          return const MainPage();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          body: Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
