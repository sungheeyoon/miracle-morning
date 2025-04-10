// 날짜 관련 공통 유틸리티 함수

/// 날짜를 'YYYY-MM-DD' 형태의 문자열로 변환
String getDateKey(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// 과거 날짜 여부 확인
bool isPastDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final compareDate = DateTime(date.year, date.month, date.day);
  return compareDate.isBefore(today);
}

/// 어제 날짜 반환
DateTime getYesterday() {
  final now = DateTime.now();
  return now.subtract(const Duration(days: 1));
}

/// 특정 월의 마지막 날짜 반환
int getLastDayOfMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}
