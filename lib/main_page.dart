import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:miracle_morning/core/notification/notification_service.dart';
import 'package:miracle_morning/features/statistics/view/pages/statistics_page.dart';
import 'package:miracle_morning/features/setting/view/pages/setting_page.dart';
import 'package:miracle_morning/features/home/view/pages/home_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int selectedIndex = 0;

  final pages = const [
    HomePage(),
    StatisticsPage(),
    SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    final localNotificationService = LocalNotificationService();
    await localNotificationService.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
