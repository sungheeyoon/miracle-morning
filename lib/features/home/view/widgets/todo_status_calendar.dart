import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:miracle_morning/core/theme/app_colors.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/models/todos_by_month_model.dart';
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:miracle_morning/core/providers/selected_date_provider.dart';

class TodoStatusCalendar extends ConsumerStatefulWidget {
  const TodoStatusCalendar({
    super.key,
    required this.monthData,
    required this.selectedDate,
    required this.focusedDate,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  final TodosByMonthModel monthData;
  final DateTime selectedDate;
  final DateTime focusedDate;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  @override
  ConsumerState<TodoStatusCalendar> createState() => _TodoStatusCalendarState();
}

class _TodoStatusCalendarState extends ConsumerState<TodoStatusCalendar> {
  late DateTime _focusedDay;
  bool _isExpanded = false;
  final Map<String, List<String>> _eventCache = {};

  final Color _primaryColor = AppColors.primary;
  final Color _successColor = AppColors.success;
  final Color _errorColor = AppColors.error;
  final Color _textColor = AppColors.grey800;
  final Color _weekendColor = AppColors.error.withOpacity(0.7);
  final Color _selectedTextColor = AppColors.white;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDate;

    final calendarFormat = ref.read(calendarFormatProvider);
    _isExpanded = calendarFormat == CalendarFormat.month;
  }

  @override
  void didUpdateWidget(TodoStatusCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusedDate.month != widget.focusedDate.month ||
        oldWidget.focusedDate.year != widget.focusedDate.year) {
      _focusedDay = widget.focusedDate;
    }

    if (oldWidget.isLoading && !widget.isLoading) {
      _clearEventCache();
    }

    if (!widget.isLoading &&
        (oldWidget.monthData.year != widget.monthData.year ||
            oldWidget.monthData.month != widget.monthData.month ||
            oldWidget.monthData.totalTodosCount !=
                widget.monthData.totalTodosCount ||
            oldWidget.monthData.completedTodosCount !=
                widget.monthData.completedTodosCount)) {
      _clearEventCache();
    }
  }

  void _clearEventCache() {
    _eventCache.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final calendarFormat = ref.watch(calendarFormatProvider);

    return Stack(
      children: [
        TableCalendar(
          firstDay: DateTime(2000),
          lastDay: DateTime(2100),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(widget.selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            ref.read(selectedDateProvider.notifier).state = selectedDay;

            if (!isSameDay(_focusedDay, focusedDay)) {
              setState(() {
                _focusedDay = focusedDay;
              });
            }
          },
          calendarFormat: calendarFormat,
          onFormatChanged: (format) {
            ref.read(calendarFormatProvider.notifier).state = format;
            setState(() {
              _isExpanded = format == CalendarFormat.month;
            });
          },
          headerVisible: true,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            leftChevronVisible: false,
            rightChevronVisible: false,
            headerMargin: const EdgeInsets.only(left: 20),
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
            headerPadding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          onPageChanged: (currentViewDay) {
            final oldMonth = _focusedDay.month;
            final oldYear = _focusedDay.year;
            final newMonth = currentViewDay.month;
            final newYear = currentViewDay.year;

            setState(() {
              _focusedDay = currentViewDay;
            });

            if (oldMonth != newMonth || oldYear != newYear) {
              ref.read(focusedDateProvider.notifier).state = currentViewDay;
            }
          },
          locale: 'ko-KR',
          startingDayOfWeek: StartingDayOfWeek.monday,
          eventLoader: (day) {
            if (widget.isLoading) {
              return [];
            }

            final dateKey = '${day.year}-${day.month}-${day.day}';

            if (_eventCache.containsKey(dateKey)) {
              return _eventCache[dateKey]!;
            }

            try {
              bool isSameMonthAsFocused = day.year == widget.monthData.year &&
                  day.month == widget.monthData.month;

              if (!isSameMonthAsFocused) {
                _eventCache[dateKey] = [];
                return [];
              }

              final dayTodos = widget.monthData.getTodosByDate(day);
              final todos = dayTodos.todos;
              List<String> result = [];

              if (todos.isEmpty) {
                _eventCache[dateKey] = result;
                return result;
              }

              int completed = 0;
              int total = todos.length;

              for (final todo in todos) {
                if ((todo).isCompleted) {
                  completed++;
                }
              }

              if (completed == total && total > 0) {
                result = ['completed'];
              } else if (completed > 0) {
                result = ['partial'];
              } else if (total > 0) {
                result = ['incomplete'];
              }

              _eventCache[dateKey] = result;
              return result;
            } catch (e) {
              return [];
            }
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: _textColor,
                    ),
                    onPressed: () {
                      final newExpanded = !_isExpanded;
                      final newFormat = newExpanded
                          ? CalendarFormat.month
                          : CalendarFormat.week;

                      setState(() {
                        _isExpanded = newExpanded;
                      });

                      ref.read(calendarFormatProvider.notifier).state =
                          newFormat;
                    },
                  ),
                ],
              );
            },
            defaultBuilder: (context, day, focusedDay) {
              final isToday = isSameDay(DateTime.now(), day);
              final isSelected = isSameDay(widget.selectedDate, day);

              return Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isToday
                      ? _primaryColor.withOpacity(0.1)
                      : Colors.transparent,
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
              Color markerColor;
              double size = 4.0;

              if (eventType == 'completed') {
                markerColor = _successColor;
              } else if (eventType == 'partial') {
                markerColor = Colors.orange;
              } else {
                markerColor = _errorColor;
              }

              return Positioned(
                bottom: 6,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: markerColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),

        if (widget.isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              child: const Center(
                child: SizedBox(width: 0, height: 0),
              ),
            ),
          ),

        if (widget.hasError)
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.white,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '데이터 로딩 오류',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
