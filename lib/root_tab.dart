import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:miracle_morning/core/notification/notification_service.dart';
import 'package:miracle_morning/core/theme/app_colors.dart';
import 'package:miracle_morning/features/statistics/view/pages/statistics_page.dart';
import 'package:miracle_morning/features/setting/view/pages/setting_page.dart';
import 'package:miracle_morning/features/home/view/pages/home_page.dart';

class RootTab extends ConsumerStatefulWidget {
  const RootTab({super.key});

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab> {
  int selectedIndex = 0;

  final pages = const [
    HomePage(),
    StatisticsPage(),
    SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    final localNotificationService = LocalNotificationService();
    await localNotificationService.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDivider(),
          BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.grey400,
            backgroundColor: AppColors.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: '통계',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                label: '설정',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.grey200.withOpacity(0.1),
            AppColors.grey200.withOpacity(0.2),
            AppColors.grey200.withOpacity(0.1),
          ],
        ),
      ),
    );
  }
}
