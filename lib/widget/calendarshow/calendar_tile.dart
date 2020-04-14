import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';

import 'day.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback onDateSelected;
  final DateTime date;
  final String dayOfWeek;
  final bool isDayOfWeek;
  final bool isSelected;
  final bool inMonth;
  final List<Map> events;
  final TextStyle dayOfWeekStyles;
  final TextStyle dateStyles;
  final Widget child;
  final Color selectedColor;
  final Color eventColor;
  final Color eventDoneColor;

  CalendarTile({
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyles,
    this.isDayOfWeek: false,
    this.isSelected: false,
    this.inMonth: true,
    this.events,
    this.selectedColor,
    this.eventColor,
    this.eventDoneColor,
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isDayOfWeek) {
      return new InkWell(
        child: new Container(
          alignment: Alignment.center,
          child: new Text(
            Day.week(dayOfWeek),
            style: TextStyle(
                color: Color(
                  0xff2d7fc7,
                ),
//                fontSize: ScreenUtil().setSp(16),
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      int eventCount = 0;
      return InkWell(
          onTap: onDateSelected,
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: isSelected
                      ? new BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    color: Color(0xff93bb23),
                  )
                      : BoxDecoration(),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Utils.formatDay(date).toString(),
                        style: TextStyle(
//                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.white
                              : inMonth ? Color(0xff2d7fc7) : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    events != null && events.length > 0
                        ? Container(
                      margin: EdgeInsets.fromLTRB(15.0, 16, 5.0, 15.0),
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                          color: Color(0xff93bb23),
                          borderRadius:
                          BorderRadius.all(Radius.circular(5))),
                      child: Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    )
                        : Container()
                  ],
                ),
              ],
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return new InkWell(
        child: child,
        onTap: onDateSelected,
      );
    }
    return new Container(
      child: renderDateOrDayOfWeek(context),
    );
  }
}
