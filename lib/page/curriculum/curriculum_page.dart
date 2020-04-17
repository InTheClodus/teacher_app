import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/courseLesson.dart';
import 'package:teacher_app/util/TimeConversion.dart';
import 'package:teacher_app/widget/calendarshow/flutter_clean_calendar.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'data/data.dart';
import 'rollcall_page.dart';
/*
* 課程主要界面，使用頂部標籤蘭，分別顯示即將上課和之後課程兩個界面
* */

const String MIN_DATETIME = '2019-05-17';
const String MAX_DATETIME = '2020-12-31';

class CurriculumPage extends StatefulWidget {
  @override
  _CurriculumPageState createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  final PageController pageController =
      PageController(initialPage: 1, keepPage: true);
  int pageIx = 1;

  String dateTime = formatDate(DateTime.now(), [yyyy, '年', mm, '月']);
  DateTime _dateTime;
  bool _showTitle = true;
  String _format = 'yyyy-MMMM';
  DateTimePickerLocale _locale = DateTimePickerLocale.zh_cn;
  final Map _events = {};
  List<Doodle> _listDoodle = [];

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  final GlobalKey<CalendarState> calendarKey = GlobalKey();
  List _selectedEvents;
  DateTime _selectedDay;

// 檢測用戶是否為教師
  Future<void> _getQueryCourse() async {
    final ParseUser user = await ParseUser.currentUser() as ParseUser;
    bool istea = false;
    Object tea;
    if (user != null) {
      QueryBuilder queryIsnTea = QueryBuilder(ParseObject('_User'))
        ..whereEqualTo('objectId', user.objectId)
        ..includeObject(['teacher']);
      var rep = await queryIsnTea.query();
      if (rep.success) {
        rep.result.map((map) {
          if (map['teacher'] != null) {
            setState(() {
              tea = map['teacher'];
              istea = true;
            });
          } else {
            print('當前用戶不是老師身份');
          }
        }).toList();
      }
      if (istea == true) {
        print("當前身份是老師");
        QueryBuilder quercourseIsmy = QueryBuilder(ParseObject('CourseLesson'))
          ..whereEqualTo('teacher', tea)
          ..includeObject(['location']);
        var rep = await quercourseIsmy.query();
        if (rep.success) {
          for (var data in rep.result) {
            if (formatDate(data['date'], [yyyy, '-', mm, '-', dd]) ==
                formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd])) {
              QueryBuilder queraddres = QueryBuilder(ParseObject('BranchRoom'))
                ..whereEqualTo('objectId', data['location']['objectId'])
                ..includeObject(['branch']);
              var address = await queraddres.query();
              if (address.success) {
                for (var datas in address.result) {
                  print(datas['branch']['address']);
                  setState(() {
                    _listDoodle.add(Doodle(
                      name: data['title'],
                      address: datas['branch']['address'],
                      time: TimeConversion.timeConversion(data['time']),
                    ));
                  });
                }
              }
            }
          }
        }
      }
    }
  }

  Future<Null> _refresh() async {
    _listDoodle.clear();
    await _getQueryCourse();
    return;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getQueryCourse();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      timelineModel(TimelinePosition.Left),
    ];
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              width: double.infinity,
              height: 96,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffc7d6eb), Color(0xffc7d6eb)]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff2d7fc7), Color(0xff2d7fc7)]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: SafeArea(
                  child: Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      "課程",
                      style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )),
            ),
          ],
        ),
        preferredSize: Size(double.infinity, 90),
      ),
      body: Column(
        children: <Widget>[
          my_calendar(width),
          Expanded(
            child: PageView(
              onPageChanged: (i) => setState(() => pageIx = i),
              controller: pageController,
              children: pages,
            ),
          )
        ],
      ),
    );
  }

  //  彈窗選擇日期
  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        backgroundColor: Color(0xfff9f9f9),
        showTitle: _showTitle,
        confirm: Text("完成",
            style: TextStyle(
                color: Color(0xff017afe),
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        cancel: Text("取消", style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          this.dateTime = formatDate(dateTime, [yyyy, '-', mm]);
          calendarKey.currentState.setToDate(dateTime, isWeek: false);
        });
      },
    );
  }

  Widget my_calendar(width) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: new BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0.0, 16.0),
          color: Color(0xfffefeff),
          blurRadius: 25.0,
          spreadRadius: -9.0,
        ),
      ]),
      child: Container(
          width: width * 0.95,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          margin: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 16.0),
              color: Color(0xfffefeff),
              blurRadius: 25.0,
              spreadRadius: -9.0,
            ),
          ]),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: dateTime,
                            style: TextStyle(
                                color: Color(0xff144d7c),
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xff144d7c),
                    )
                  ],
                ),
                onTap: _showDatePicker,
              ),
              Calendar(
                key: calendarKey,
                events: _events,
                isExpanded: false,
                onRangeSelected: (range) {
                  print("${range.from}, ${range.to}");
                  setState(() {
                    dateTime = formatDate(range.from, [yyyy, '年', mm, '月']);
//                        _handleNewDate(date);
                  });
                },
                onDateSelected: (date) => _handleNewDate(date),
                isExpandable: true,
                showTodayIcon: true,
              ),
            ],
          )),
    );
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      itemBuilder: centerTimelineBuilder,
      itemCount: _listDoodle.length,
      physics: position == TimelinePosition.Left
          ? ClampingScrollPhysics()
          : BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = _listDoodle[i];
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    return TimelineModel(
        InkWell(
          onTap: () {
            print('點擊了' + doodle.address);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RollCallPage(
                          className: doodle.name,
                          adderss: doodle.address,
                          clssTime: DateTime.now(),
                        )));
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            clipBehavior: Clip.antiAlias,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                    Image.network(doodle.doodle),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(doodle.time, style: textTheme.subtitle),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        doodle.name,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.title,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '地址：' + doodle.address,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.body1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 1.0,
                      ),
                    ],
                  ),
                )),
          ),
        ),
        position:
            i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == _listDoodle.length,
        iconBackground: doodle.iconBackground,
        icon: doodle.icon);
  }
}
