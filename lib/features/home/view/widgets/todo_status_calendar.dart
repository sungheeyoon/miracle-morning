import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:miracle_morning/core/providers/selected_date_provider.dart';
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';

class TodoStatusCalendar extends ConsumerStatefulWidget {
  const TodoStatusCalendar({
    super.key,
    required this.todosByMonthModel,
    required this.onFocusedDayChanged,
  });

  final dynamic todosByMonthModel;
  final Function(DateTime) onFocusedDayChanged;

  @override
  ConsumerState<TodoStatusCalendar> createState() => _TodoStatusCalendarState();
}

class _TodoStatusCalendarState extends ConsumerState<TodoStatusCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late DateTime _focusedDay;
  bool _isExpanded = false;

  // 캘린더용 색상 정의
  final Color _primaryColor = const Color(0xFF6B8AFE);
  final Color _secondaryColor = const Color(0xFF4A6CF7);
  final Color _successColor = const Color(0xFF4CAF50);
  final Color _errorColor = const Color(0xFFE57373);
  final Color _textColor = const Color(0xFF2D3142);
  final Color _weekendColor = const Color(0xFFE57373);
  final Color _selectedColor = const Color(0xFF4A6CF7); // 선택된 날짜 배경색
  final Color _selectedTextColor = Colors.white; // 선택된 날짜 텍스트 색상

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);

    return TableCalendar(
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        ref.read(selectedDateProvider.notifier).state = selectedDay;
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      headerVisible: true,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        headerMargin: EdgeInsets.only(left: 20),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        headerPadding: EdgeInsets.symmetric(vertical: 8.0),
      ),
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
        widget.onFocusedDayChanged(focusedDay);
      },
      locale: 'ko-KR',
      eventLoader: (day) {
        final dayTodos = widget.todosByMonthModel.getTodosByDate(day);
        if (dayTodos.todos.isEmpty) {
          return [];
        }
        final allCompleted =
            dayTodos.todos.every((todo) => (todo as TodoModel).isCompleted);
        return allCompleted ? ['completed'] : ['incomplete'];
      },
      calendarStyle: CalendarStyle(
        cellMargin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        cellPadding: EdgeInsets.zero,
        cellAlignment: Alignment.center,
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(
          color: _textColor,
          fontSize: 14,
        ),
        weekendTextStyle: TextStyle(
          color: _weekendColor,
          fontSize: 14,
        ),
        holidayTextStyle: TextStyle(
          color: _weekendColor,
          fontSize: 14,
        ),
        todayDecoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: _primaryColor,
          shape: BoxShape.circle,
        ),
      ),
      daysOfWeekHeight: 30,
      rowHeight: 45,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: _textColor),
        weekendStyle: TextStyle(color: _weekendColor),
      ),
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                DateFormat('yyyy년 MM월').format(_focusedDay),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                    _calendarFormat = _isExpanded
                        ? CalendarFormat.month
                        : CalendarFormat.week;
                  });
                },
              ),
            ],
          );
        },
        defaultBuilder: (context, day, focusedDay) {
          final isToday = isSameDay(DateTime.now(), day);
          final isSelected = isSameDay(selectedDate, day);

          return Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  isToday ? _primaryColor.withOpacity(0.1) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: isSelected
                    ? _selectedTextColor
                    : isToday
                        ? _primaryColor
                        : _textColor,
                fontSize: 14,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return const SizedBox.shrink();

          final eventType = events.first;
          Color markerColor =
              eventType == 'completed' ? _successColor : _errorColor;

          return Positioned(
            bottom: 6,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: markerColor,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}
