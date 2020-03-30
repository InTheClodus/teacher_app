library flutter_clean_calendar;

import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';
import './simple_gesture_detector.dart';
import './calendar_tile.dart';

typedef DayBuilder(BuildContext context, DateTime day);

class Range {
  final DateTime from;
  final DateTime to;

  Range(this.from, this.to);
}

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected; //on Date Selected
  final ValueChanged onRangeSelected;
  final bool isExpandable;
  final DayBuilder dayBuilder;
  final bool showArrows;
  final bool showTodayIcon;
  final Map events;
  final Color selectedColor;
  final DateTime initialDate;
  final bool isExpanded;
  final bool isDisableSwipeUpAndDow;

  Calendar({
    Key key,
    this.onDateSelected,
    this.onRangeSelected,
    this.isExpandable: false,
    this.events,
    this.dayBuilder,
    this.showTodayIcon: true,
    this.showArrows: true,
    this.selectedColor,
    this.initialDate,
    this.isExpanded = true,
    this.isDisableSwipeUpAndDow,
  }) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  final calendarUtils = Utils();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  DateTime _selectedDate = DateTime.now();
  String currentMonth;
  bool isExpanded = false;
  bool isDisableSwipeUpAndDow=true;
  String displayMonth;
  DateTime get selectedDate => _selectedDate;

  void initState() {
    super.initState();
    _selectedDate = widget?.initialDate ?? DateTime.now();
    isExpanded = widget?.isExpanded ?? false;
    selectedMonthsDays = Utils.daysInMonth(_selectedDate);
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);
    selectedWeeksDays =
        Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
            .toList()
            .sublist(0, 7);
    displayMonth = Utils.formatMonth(_selectedDate);
  }

  Widget get calendarGridView {
    return Container(
      child: SimpleGestureDetector(
        onSwipeLeft: _onSwipeLeft,
        onSwipeRight: _onSwipeRight,
        onSwipeUp:_onSwipeUp,
        onSwipeDown: _onSwipeDown,
        swipeConfig: SimpleSwipeConfig(
          verticalThreshold: 10.0,
          horizontalThreshold: 40.0,
          swipeDetectionMoment: SwipeDetectionMoment.onUpdate,
        ),
        child: Column(children: <Widget>[
          GridView.count(
            primary: false,
            shrinkWrap: true,
            crossAxisCount: 7,
            padding: EdgeInsets.only(bottom: 0.0),
            children: calendarBuilder(),
          ),
        ]),
      ),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays =
    isExpanded ? selectedMonthsDays : selectedWeeksDays;

    Utils.weekdays.forEach(
          (day) {
        dayWidgets.add(
          CalendarTile(
            selectedColor: widget.selectedColor,
            events: widget.events[day],
            isDayOfWeek: true,
            dayOfWeek: day,
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
          (day) {
        if (day.hour > 0) {
          day = day.toLocal();

          day = day.subtract(new Duration(hours: day.hour));
        }

        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        if (this.widget.dayBuilder != null) {
          dayWidgets.add(
            CalendarTile(
              selectedColor: widget.selectedColor,
              child: this.widget.dayBuilder(context, day),
              date: day,
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
            ),
          );
        } else {
          dayWidgets.add(
            CalendarTile(
                selectedColor: widget.selectedColor,
                events: widget.events[day],
                onDateSelected: () => handleSelectedDateAndUserCallback(day),
                date: day,
                dateStyles: configureDateStyle(monthStarted, monthEnded),
                isSelected: Utils.isSameDay(selectedDate, day),
                inMonth: day.month == selectedDate.month),
          );
        }
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles;
    final TextStyle body1Style = Theme.of(context).textTheme.body1;

    if (isExpanded) {
      final TextStyle body1StyleDisabled = body1Style.copyWith(
          color: Color.fromARGB(
            100,
            body1Style.color.red,
            body1Style.color.green,
            body1Style.color.blue,
          ));

      dateStyles =
      monthStarted && !monthEnded ? body1Style : body1StyleDisabled;
    } else {
      dateStyles = body1Style;
    }
    return dateStyles;
  }

  @override
  Widget build(BuildContext context) {
    print(isExpanded);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ExpansionCrossFade(
            collapsed: calendarGridView,
            expanded: calendarGridView,
            isExpanded: isExpanded,
          ),
        ],
      ),
    );
  }

  void resetToToday() {
    setToDate(DateTime.now());
  }

  void setEvent(Map events) {}

  void setToDate(DateTime dateTime, {isWeek: false}) {
    print(dateTime);
    setState(() {
      _selectedDate = dateTime;

      if (isWeek) {
        var firstDayOfCurrentWeek = Utils.firstDayOfWeek(dateTime);
        var lastDayOfCurrentWeek = Utils.lastDayOfWeek(dateTime);
        updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
        selectedWeeksDays =
            Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
                .toList()
                .sublist(0, 7);
      } else {
        var firstDateOfNewMonth = Utils.firstDayOfMonth(dateTime);
        var lastDateOfNewMonth = Utils.lastDayOfMonth(dateTime);
        updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
        selectedMonthsDays = Utils.daysInMonth(dateTime); //选定的月份
      }
      displayMonth = Utils.formatMonth(dateTime);
    });

    _launchDateSelectionCallback(dateTime);
  }

// 下一月
  void nextMonth() {
    setToDate(Utils.nextMonth(_selectedDate));
  }

//上一月
  void previousMonth() {
    setToDate(Utils.previousMonth(_selectedDate));
  }

  void nextWeek() {
    setToDate(Utils.nextWeek(_selectedDate), isWeek: true);
  }

  void previousWeek() {
    setToDate(Utils.previousWeek(_selectedDate), isWeek: true);
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    Range _rangeSelected = Range(start, end);
    if (widget.onRangeSelected != null) {
      widget.onRangeSelected(_rangeSelected);
    }
  }

  void _onSwipeUp() {
    print(isExpanded);
    if (isExpanded) toggleExpanded();
  }

  void _onSwipeDown() {
    if (!isExpanded) toggleExpanded();
  }

//  右滑動
  void _onSwipeRight() {
    print(isExpanded);
    if (isExpanded) {
      previousMonth();
    } else {
      previousWeek();
    }
  }

//左滑動
  void _onSwipeLeft() {
    if (isExpanded) {
      nextMonth();
    } else {
      nextWeek();
    }
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(day);
    if (_selectedDate.month > day.month) {
      previousMonth();
    }
    if (_selectedDate.month < day.month) {
      nextMonth();
    }
    setState(() {
      _selectedDate = day;
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = Utils.daysInMonth(day);
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected(day);
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool isExpanded;

  ExpansionCrossFade({this.collapsed, this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AnimatedCrossFade(
        firstChild: collapsed,
        secondChild: expanded,
        firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.decelerate,
        crossFadeState:
        isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
