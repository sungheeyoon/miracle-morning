import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlarmTimePicker extends StatelessWidget {
  final TimeOfDay initialTime;

  const AlarmTimePicker({super.key, required this.initialTime});

  @override
  Widget build(BuildContext context) {
    DateTime initialDateTime = DateTime(
      0,
      0,
      0,
      initialTime.hour,
      initialTime.minute,
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // 다이얼로그 너비
        height: 400, // 다이얼로그 높이
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '알람 설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: initialDateTime,
                onDateTimeChanged: (DateTime newTime) {
                  initialDateTime = newTime;
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    final selectedTime = TimeOfDay(
                      hour: initialDateTime.hour,
                      minute: initialDateTime.minute,
                    );
                    Navigator.of(context).pop(selectedTime);
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
