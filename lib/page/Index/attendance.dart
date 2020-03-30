import 'dart:convert';

import 'package:cool_ui/cool_ui.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:teacher_app/common/eventBus.dart';
import 'package:teacher_app/login/login.dart';
import 'package:teacher_app/module/StudentSignIn.dart';
import 'package:teacher_app/page/Index/diet.dart';
import 'package:teacher_app/server/ServiceLocator.dart';
import 'package:teacher_app/server/TelAndSmsService.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/util/SizeConfig.dart';
import 'package:teacher_app/widget/calendarshow/flutter_clean_calendar.dart';
import 'Item/attendance_item.dart';
import 'charge.dart';
import 'growup.dart';

/*
* 補習狀態
* 主要功能：
* 顯示學生的接送狀態（待接送，家長自行接送，補習中）
* 修改補習狀態，
* 待接送 -> 已接送，補習老師到
* 待接送 或 家長自行接送 -> 補習中，學生到達後拍卡考勤，更新狀態，或者補習老師代為打卡
* 通知家長接送
* */
class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

const String MIN_DATETIME = '2019-05-17';
const String MAX_DATETIME = '2020-12-31';

class _AttendanceState extends State<Attendance> {
  final TelAndSmsService _service = locator<TelAndSmsService>(); //电话的服务
  String barcode = ""; //掃描二維碼信息
  String phone = '10086';
  bool isMyStu = true;
  int _selectedColorIndex = 0;
  String stuName = '未選擇';
  String picurl;
  int exisUnpaid = 0;
  String arrivalTime = '10:00';
  String leaveTime = '补习中';

  List<StudentSignIn> _liststuSign = [];
  List<String> _listStuName = [];
  List<String> _listId = [];
  List<String> _stuList = [];

  String dateTime = formatDate(DateTime.now(), [yyyy, '年', mm, '月']);
  DateTime _dateTime;
  bool _showTitle = true;
  String _format = 'yyyy-MMMM';
  DateTimePickerLocale _locale = DateTimePickerLocale.zh_cn;
  Course course;

  void _handleNewDate(date) {
    setState(() {
      print(DateTime.now().weekday);
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  final GlobalKey<CalendarState> calendarKey = GlobalKey();
  List _selectedEvents;
  DateTime _selectedDay;
  String data = '无';

  final Map _events = {};

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

  Future<void> _getStuStatus() async {
    final ParseUser user = await ParseUser.currentUser() as ParseUser;
    if (user != null) {
      QueryBuilder<ParseObject> querUser =
          QueryBuilder<ParseObject>(ParseObject('_User'))
            ..whereEqualTo('objectId', user.objectId)
            ..includeObject(['employee']);
      var repuser = await querUser.query();
//      獲取所有學生姓名
      if (repuser.result != null) {
        for (var empdata in repuser.result) {
          QueryBuilder<ParseObject> queryEmp =
              QueryBuilder<ParseObject>(ParseObject('Employee'))
                ..whereEqualTo('objectId', empdata['employee']['objectId'])
                ..includeObject(['branch']);
          var repEmp = await queryEmp.query();
          if (repEmp.result != null) {
            var objectId;
            for (var data in repEmp.result) {
              setState(() {
                objectId = data['branch']['objectId'];
                print(repEmp.result);
              });
            }
            QueryBuilder<ParseObject> queryBranch =
                QueryBuilder<ParseObject>(ParseObject('Student'))
                  ..whereRelatedTo('students', 'Branch', objectId)
                  ..includeObject(['member']);
            var repstulist = await queryBranch.query();
            int i = 0;
            if (repstulist.result != null) {
              print('------');
              for (var datastu in repstulist.result) {
                setState(() {
                  _listStuName.add(datastu['member']['displayName']);
                  _listId.add(datastu['objectId']);
                });
              }
              int i = 0;
              QueryBuilder<ParseObject> queryStuSign =
                  QueryBuilder<ParseObject>(ParseObject('StudentSignIn'));
              var stusignRep = await queryStuSign.query();
              if (stusignRep.result != null) {
                for (var datastusign in stusignRep.result) {
                  i++;
                  if (formatDate(datastusign['date'], [yyyy, '-', mm, '-', dd]) == formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd])) {
                    setState(() {
                      _liststuSign.add(StudentSignIn(
                          datastusign['objectId'] == null ? "--" : datastusign['objectId'],
                          datastusign['checkInAt'] == null ? '--:--' : formatDate(datastusign['checkInAt'], [hh, ':', nn]),
                          datastusign['state'] == null ? "--" : datastusign['state'],
                          datastusign['checkOutAt'] == null ? '--:--' : formatDate(datastusign['checkOutAt'], [hh, ':', nn]),
                          _listStuName[i] == null ? 'null' : _listStuName[i]));
                    });
                  }
                }
              }
            }
          }
        }
      }
    }
  }


  Future<void> updateState(object, value) async {
    var signState = ParseObject('StudentSignIn')
      ..set('objectId', object)
      ..set('state', value);
    var rep = await signState.save();
    if (rep.success) {
      setState(() {
        _liststuSign.clear();
        _getStuStatus();
      });
    }
  }

  Future<void> _getCourseClass() async {
    QueryBuilder<ParseObject> queryPost =
        QueryBuilder<ParseObject>(ParseObject('CourseClass'))
          ..whereStartsWith('objectId', 'uCjDNK98qF');

    QueryBuilder<ParseObject> queryComment =
        QueryBuilder<ParseObject>(ParseObject('CourseLesson'))
          ..includeObject(['location', 'class'])
          ..whereMatchesQuery('class', queryPost);

    var apiResponse = await queryComment.query();
    if (apiResponse.success) {
      print(apiResponse.result.toString());
    }
  }

  //region 底部彈出框

  void showPub() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return _shareWidget();
        });
  }

  Widget _shareWidget() {
    final width = MediaQuery.of(context).size.width;
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: _selectedColorIndex);
    return new Container(
      height: 200.0,
      child: new Column(
        children: <Widget>[
          Container(
            width: width * 0.92,
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new Container(
              height: 190.0,
              child: new CupertinoPicker(
                magnification: 1.0,
                scrollController: scrollController,
                itemExtent: 35,
                backgroundColor: CupertinoColors.white,
                useMagnifier: true,
                onSelectedItemChanged: (index) {
                  print('選擇：' + _stuList[index]);
                  setState(() {
                    stuName = _stuList[index];
                  });
                },
                children: List<Widget>.generate(_stuList.length, (int index) {
                  return Center(
                    child: Text(_stuList[index]),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //endregion

  //region 初始化
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _getStudentName();
    _selectedEvents = _events[_selectedDay] ?? [];
    eventBus.on<MyEvent>().listen((MyEvent data) => show(data.text));
//    _getCourseClass();
    _getStuStatus();
//    _getStuName();
  }

  void show(String val) {
    setState(() {
      data = val;
    });
    print(val);
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              width: double.infinity,
              height: SizeConfig.blockSizeHorizontal * 32,
              decoration: BoxDecoration(
                  color: Color(0xffc7d6eb),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: double.infinity,
              height: SizeConfig.blockSizeHorizontal * 30,
              decoration: BoxDecoration(
                  color: Color(0xff2d7fc7),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: SafeArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                  ),
                  Row(
                    children: <Widget>[
                      new Expanded(
                          child: AttendanceItem(
                        icons: Icons.account_balance_wallet,
                        title: '收費',
                        onPressed: () {
                          print('收費');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Charge()));
                        },
                      )),
                      new Expanded(
                          child: AttendanceItem(
                              icons: Icons.fastfood,
                              title: '膳食',
                              onPressed: () {
                                print('膳食');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Diet()));
                              })),
                      new Expanded(
                          child: AttendanceItem(
                              icons: Icons.fiber_smart_record,
                              title: '成長紀錄',
                              onPressed: () {
                                print('成長紀錄');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GrowUp()));
                              })),
                    ],
                  )
                ],
              )),
            ),
          ],
        ),
        preferredSize: Size(
          double.infinity,
          SizeConfig.blockSizeHorizontal * 32,
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            my_calendar(width),
            DataTable(
                columns: [
                  DataColumn(label: Text("姓名")),
                  DataColumn(label: Text('到达')),
                  DataColumn(label: Text('离开')),
                  DataColumn(label: Text('操作')),
                ],
//                  rows: _stuList.forEach((f){
//                    return DataRow(
//                      cells: [
//
//                      ]
//                    )
//                  })),
                rows: _liststuSign.map((post) {
                  print(post.objectId);
                  return DataRow(cells: [
                    DataCell(Text(post.stuname)),
                    DataCell(Text(post.checkInAt)),
                    DataCell(Text(post.checkOutAt)),
                    DataCell(_buildPopoverButton(post.state, post.objectId)),
                  ]);
                }).toList()),
          ],
        ),
      ),
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

  Widget _buildPopoverButton(String btnTitle, objectId) {
    return CupertinoPopoverButton(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(color: Colors.transparent, blurRadius: 5.0)
              ]),
          child: Center(
              child: Text(
            btnTitle,
            style: TextStyle(color: Colors.blue, fontSize: 18),
          )),
        ),
        popoverBuild: (context) {
//              return Text("satatastas");
          return CupertinoPopoverMenuList(
            children: <Widget>[
              CupertinoPopoverMenuItem(
                leading: Icon(Icons.edit),
                child: Text("已接送"),
                onTap: () {
                  updateState(objectId, '已接送');
                  Navigator.pop(context);
                  return true;
                },
              ),
              CupertinoPopoverMenuItem(
                leading: Icon(Icons.edit),
                child: Text("家長自行接送"),
                onTap: () {
                  print('家長自行接送');
                  updateState(objectId, '家長自行接送');
                  Navigator.pop(context);
                  return true;
                },
              ),
              CupertinoPopoverMenuItem(
                leading: Icon(Icons.edit),
                child: Text("補習中"),
                onTap: () {
                  print('補習中');
                  updateState(objectId, '補習中');
                  Navigator.pop(context);
                  return true;
                },
              )
            ],
          );
        });
  }
}

class Course {
  final String objectId;
  final String title;
  final String endStartDate;
  final String src;
  final String address;
  final String fee;
  final String enrolled;
  final String capacity;

  Course(this.objectId, this.title, this.endStartDate, this.src, this.address,
      this.fee, this.enrolled, this.capacity);
}
