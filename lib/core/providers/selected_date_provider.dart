import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// 사용자가 현재 보고 있는 달력 페이지의 날짜
final focusedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// 캘린더 포맷 상태를 전역적으로 관리
final calendarFormatProvider = StateProvider<CalendarFormat>((ref) {
  return CalendarFormat.week; // 기본값은 주 단위 보기
});
