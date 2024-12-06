import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/features/setting/view/widgets/alarm_time_picker.dart';
import 'package:miracle_morning/features/setting/viewmodel/setting_viewmodel.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(settingViewModelProvider);
    final notifier = ref.watch(settingViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: viewModel.when(
        data: (state) {
          print('Current SettingState: $state');
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 전체 알림 스위치
              _buildSwitchRow(
                title: '전체 알림',
                value: state.isAllNotificationEnabled,
                onChanged: notifier.toggleAllNotifications,
              ),
              const Divider(),

              // 투두리스트 작성 알림
              _buildSwitchRow(
                title: '투두리스트 작성 알림',
                value: state.isTodoNotificationEnabled,
                onChanged: notifier.toggleTodoNotification,
              ),
              const SizedBox(height: 8),
              _buildTimePickerRow(
                context: context,
                title: '알림 시간',
                time: state.todoNotificationTime,
                onTimePicked: () async {
                  final selectedTime = await _pickTime(
                    context: context,
                    initialTime: state.todoNotificationTime,
                  );
                  if (selectedTime != null) {
                    notifier.updateTodoNotificationTime(selectedTime);
                  }
                },
              ),
              const Divider(),

              // 투두리스트 확인 알림
              _buildSwitchRow(
                title: '투두리스트 확인 알림',
                value: state.isCheckNotificationEnabled,
                onChanged: notifier.toggleCheckNotification,
              ),
              const SizedBox(height: 8),
              _buildTimePickerRow(
                context: context,
                title: '확인 알림 시간',
                time: state.checkNotificationTime,
                onTimePicked: () async {
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16.0),
        ),
        CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTimePickerRow({
    required BuildContext context,
    required String title,
    required TimeOfDay time,
    required VoidCallback onTimePicked,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16.0),
        ),
        Row(
          children: [
            Text(
              time.format(context),
              style: const TextStyle(fontSize: 16.0),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: onTimePicked,
            ),
          ],
        ),
      ],
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
