import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/core/theme/app_colors.dart';
import 'package:miracle_morning/core/theme/app_text_styles.dart';
import 'package:miracle_morning/core/widgets/common_widgets.dart';
import 'package:miracle_morning/features/setting/view/widgets/alarm_time_picker.dart';
import 'package:miracle_morning/features/setting/view/widgets/permission_dialog.dart';
import 'package:miracle_morning/features/setting/viewmodel/setting_viewmodel.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(settingViewModelProvider);
    final notifier = ref.watch(settingViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
          style: AppTextStyles.headline3,
        ),
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: viewModel.when(
        data: (state) => _buildSettingsContent(context, state, notifier),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContent(
    BuildContext context, 
    dynamic state, 
    dynamic notifier
  ) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildNotificationSection(context, state, notifier),
        const SizedBox(height: 24),
        _buildAppInfoSection(),
      ],
    );
  }

  Widget _buildNotificationSection(
    BuildContext context, 
    dynamic state, 
    dynamic notifier
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '알림 설정',
          icon: Icons.notifications_outlined,
        ),
        AppCard(
          child: Column(
            children: [
              _buildSwitchRow(
                title: '전체 알림',
                subtitle: '모든 알림 활성화/비활성화',
                value: state.isAllNotificationEnabled,
                onChanged: (value) async {
                  if (value && !state.hasNotificationPermission) {
                    // 권한 없이 활성화 시도하면 다이얼로그 표시
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => const PermissionDialog(),
                    );
                    
                    if (result == true) {
                      // 설정으로 이동
                      await notifier.openNotificationSettings();
                    }
                  } else {
                    // 권한 있거나 비활성화인 경우 정상 처리
                    await notifier.toggleAllNotifications(value);
                  }
                },
              ),
              const Divider(color: AppColors.grey200),

              _buildSwitchRow(
                title: '투두리스트 작성 알림',
                subtitle: '설정한 시간에 할 일 작성 알림 받기',
                value: state.isTodoNotificationEnabled,
                enabled: state.isAllNotificationEnabled, // 전체 알림이 꺼져있으면 비활성화
                onChanged: (value) async {
                  if (value && !state.hasNotificationPermission) {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => const PermissionDialog(),
                    );
                    
                    if (result == true) {
                      await notifier.openNotificationSettings();
                    }
                  } else {
                    final success = await notifier.toggleTodoNotification(value);
                    // 실패 시 추가 처리가 필요하면 여기에 코드 추가
                  }
                },
              ),
              _buildTimePickerRow(
                context: context,
                title: '알림 시간',
                time: state.todoNotificationTime,
                enabled: state.isTodoNotificationEnabled && state.isAllNotificationEnabled,
                onTimePicked: () async {
                  if (!state.hasNotificationPermission) {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => const PermissionDialog(),
                    );
                    
                    if (result == true) {
                      await notifier.openNotificationSettings();
                    }
                    return;
                  }
                  
                  final selectedTime = await _pickTime(
                    context: context,
                    initialTime: state.todoNotificationTime,
                  );
                  if (selectedTime != null) {
                    notifier.updateTodoNotificationTime(selectedTime);
                  }
                },
              ),
              const Divider(color: AppColors.grey200),

              _buildSwitchRow(
                title: '투두리스트 확인 알림',
                subtitle: '설정한 시간에 할 일 확인 알림 받기',
                value: state.isCheckNotificationEnabled,
                enabled: state.isAllNotificationEnabled, // 전체 알림이 꺼져있으면 비활성화
                onChanged: (value) async {
                  if (value && !state.hasNotificationPermission) {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => const PermissionDialog(),
                    );
                    
                    if (result == true) {
                      await notifier.openNotificationSettings();
                    }
                  } else {
                    final success = await notifier.toggleCheckNotification(value);
                    // 실패 시 추가 처리가 필요하면 여기에 코드 추가
                  }
                },
              ),
              _buildTimePickerRow(
                context: context,
                title: '확인 알림 시간',
                time: state.checkNotificationTime,
                enabled: state.isCheckNotificationEnabled && state.isAllNotificationEnabled,
                onTimePicked: () async {
                  if (!state.hasNotificationPermission) {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => const PermissionDialog(),
                    );
                    
                    if (result == true) {
                      await notifier.openNotificationSettings();
                    }
                    return;
                  }
                  
                  final selectedTime = await _pickTime(
                    context: context,
                    initialTime: state.checkNotificationTime,
                  );
                  if (selectedTime != null) {
                    notifier.updateCheckNotificationTime(selectedTime);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '앱 정보',
          icon: Icons.info_outline,
        ),
        AppCard(
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  '버전 정보',
                  style: AppTextStyles.body1,
                ),
                trailing: const Text(
                  '1.0.0',
                  style: AppTextStyles.body2,
                ),
                onTap: () {},
              ),
              const Divider(color: AppColors.grey200),
              ListTile(
                title: const Text(
                  '개인정보 처리방침',
                  style: AppTextStyles.body1,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.grey500,
                ),
                onTap: () {},
              ),
              const Divider(color: AppColors.grey200),
              ListTile(
                title: const Text(
                  '오픈소스 라이선스',
                  style: AppTextStyles.body1,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.grey500,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    bool enabled = true,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle2.copyWith(
                    color: enabled ? AppColors.grey800 : AppColors.grey400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: enabled ? AppColors.grey600 : AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: enabled ? AppColors.primary : AppColors.grey300,
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerRow({
    required BuildContext context,
    required String title,
    required TimeOfDay time,
    required VoidCallback onTimePicked,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.body2.copyWith(
              color: enabled ? AppColors.grey700 : AppColors.grey400,
            ),
          ),
          InkWell(
            onTap: enabled ? onTimePicked : null,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    time.format(context),
                    style: AppTextStyles.subtitle2.copyWith(
                      color: enabled ? AppColors.primary : AppColors.grey400,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: enabled ? AppColors.primary : AppColors.grey400,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay?> _pickTime({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) async {
    return await showDialog<TimeOfDay>(
      context: context,
      builder: (context) => AlarmTimePicker(
        initialTime: initialTime,
      ),
    );
  }
}
