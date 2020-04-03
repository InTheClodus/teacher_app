import 'dart:async';
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:teacher_app/util/SizeConfig.dart';
import 'package:teacher_app/util/stu_attend_state.dart';
import 'package:teacher_app/widget/contact_item.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'Item/rollcallItem.dart';

/*
* 點名界面
* 除了可以點名
* 還可以查看距離上課時間還有多近
* 顯示各個情況的數據
* */
class RollCallPage extends StatefulWidget {
  final String className;
  final DateTime clssTime;
  final String adderss;

  const RollCallPage({Key key, this.className, this.clssTime, this.adderss})
      : super(key: key);

  @override
  _RollCallPageState createState() => _RollCallPageState();
}

class _RollCallPageState extends State<RollCallPage> {
  int qingjia = 0; //請假
  int chuxi = 0; //出席
  int quexi = 0; //缺席
  int chidao = 0; //遲到
  int allStu = 0;
  String url;
  String teaName;
  String teaObejctId;
  String sk = "即將到達上課時間";
  var course = ParseObject("CourseClass");
  var lesson = ParseObject("CourseLesson");
  var scholar = ParseObject("Scholar");
  var member = ParseObject("Member");
  var branch = ParseObject("Branch");
  var teacher = ParseObject("Teacher");
  List<String> _listMember = [];
  List<String> _listScholarId = [];
  var CourseobejectId;

  List<StuAttendance> _listStuAttendance = [];

  //region count
  Future<void> _addStudentToScholar(objectId, value) async {
    print("${objectId}   ${value}");
    scholar.set('objectId', objectId);
    var attendance = ParseObject("CourseAttendance")
      ..set('class', course)
      ..set('lesson', lesson)
      ..set('scholar', scholar)
      ..set('status', StuAttendState.LabelToStatus(value));
    var repatend = await attendance.save();
    if (repatend.statusCode == 201) {
      print('插入成功');
    }
  }

  //endregion

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCourseImg();
    _getStuCont();
  }

  Future<void> _getCourseImg() async {
    QueryBuilder queryimg = QueryBuilder(ParseObject("CourseClass"))
      ..whereEqualTo('title', widget.className)
      ..includeObject(['course']);
    var rep = await queryimg.query();
    if (rep.success) {
      rep.result.map((map) {
        setState(() {
          url = map['course']['cover']['url'];
          course.set('objectId', map['objectid']);
        });
      }).toList();
    }
  }

  Future<void> _getStuCont() async {
//      先查询当前上课的是哪个班级
    var location;
    var objectIdBranch;
    print(widget.className);
    //region 頂部Card內容
    QueryBuilder queryCourseTitle = QueryBuilder(ParseObject("CourseLesson"))
      ..whereEqualTo('title', widget.className)
      ..includeObject(['location', 'class', 'teacher']);
    var rep = await queryCourseTitle.query();
    print(rep.result);
    if (rep.result != null) {
      rep.result.map((map) {
        setState(() {
          CourseobejectId = map['objectId'];
          location = map['location']['objectId'];
          teaName = map['teacher']['displayName'];
          lesson.set('objectId', map['objectId']);
          course.set("objectId", map["class"]["objectId"]);
        });
      }).toList();
//  查詢CourseLesson表的location字段
//  通過字段location指向的BranchRoom表
//  查詢該表的branch以方便獲得學生的數據
//  在branch字段指向的Branch表有字段students
//  該表紀錄著登錄的教師所在班級的所有學生
//    因為不能在上一層直接include下一層，所有先查詢分校objectId，再進一步查詢
      QueryBuilder queryBranchRoom = QueryBuilder(ParseObject("BranchRoom"))
        ..whereEqualTo('objectId', location)
        ..includeObject(['branch']);
      var queryRoom = await queryBranchRoom.query();
      if (queryRoom.result != null) {
        print('當查詢BranchRoom不為空');
//      查詢這個分校的這個課程的學生
        QueryBuilder queryBranchRoom =
            QueryBuilder<ParseObject>(ParseObject('Student'))
              ..whereRelatedTo('students', 'Branch',
                  queryRoom.results.first['branch']['objectId'])
              ..includeObject(['member']);
        var repStu = await queryBranchRoom.query();
        if (repStu.statusCode == 200) {
          print("Student查詢成功");
          if (repStu.result != null) {
//          當查詢學生是否為會員不為空時
            print('當查詢學生是否為會員不為空時');
//        將所有學生的會員信息添加到  _listMember列表中,方便用於在學員表中添加
            setState(() {
              allStu = repStu.count;
            });
            for (var dataStu in repStu.result) {
              _listMember.add(dataStu['member']['objectId']);
              print(dataStu['member']['objectId']);
              print(repStu.count);
              //region Scholar表
//            將_listMember中的id放入Scholar表中查找，如果不存在就添加進去
              member.set("objectId", dataStu['member']['objectId']);
              branch.set(
                  'objectId', queryRoom.results.first['branch']['objectId']);
              QueryBuilder queryScholar =
                  QueryBuilder<ParseObject>(ParseObject("Scholar"))
                    ..whereEqualTo('branch', branch)
                    ..whereEqualTo('member', member);
              var repScholar = await queryScholar.query();
              if (repScholar.success) {
                if (repScholar.result != null) {
//              當學生存在學員列表
                  print("當學生存在學員列表");
                  for (var datasc in repScholar.result) {
                    setState(() {
                      _listScholarId.add(datasc['objectId']);
                    });
                    scholar.set('objectId', "X1ACR0LoBp");
                    QueryBuilder queryAttendance = QueryBuilder<ParseObject>(
                        ParseObject('CourseAttendance'))
                      ..whereEqualTo('class', course)
                      ..whereEqualTo('lesson', lesson)
                      ..whereEqualTo('scholar', scholar);
                    var rep = await queryAttendance.query();

                      print('簽到表查詢成功${_listStuAttendance.length}');
                      if (rep.result != null) {
                        for(var repdata in rep.result){
                          setState(() {
                            _listStuAttendance.add(StuAttendance(
                                objectId: repdata['objectId'],
                                name: repdata['objectId'],
                                state: StuAttendState.statusToLabel(
                                    repdata['state'])));
                          });
                        }
                      } else {
                        print('---------------簽到表沒有這個人');
//                        course.set('objectId', "zwRFCi4Aed");
//                        lesson.set('objectId', "xjJG3g86lL");
//                        scholar.set('objectId', "jPJgNdfGhz");
                        print("_____________${course.objectId}");
                        print("_____________${lesson.objectId}");
                        var attendance = ParseObject("CourseAttendance")
                          ..set('class', course)
                          ..set('lesson', lesson)
                          ..set('scholar', scholar)
                          ..set('status', StuAttendState.LabelToStatus("未點名"));
                        var repatend = await attendance.save();
                        if (repatend.statusCode == 201) {
                          print('插入成功');
                        } else {
                          print(repatend.statusCode);
                        }
                      }

                  }
                } else {
//              當學生不存在學員表，則添加
                  print('該學生不處於學員列表');
                  print(member);
                  print(branch);
                  var addScholar = ParseObject("Scholar")
                    ..set("branch", branch)
                    ..set("member", member);
                  var repmember = await addScholar.save();
                  if (repmember.statusCode==201) {
                    print('插入成功');
                  }
                }
              }
              //endregion
            }
          }
        }
      }
    }
    //endregion
  }

  Future<void> add() async {
    course.set('objectId', "zwRFCi4Aed");
    lesson.set('objectId', "xjJG3g86lL");
    scholar.set('objectId', "jPJgNdfGhz");
    var attendance = ParseObject("CourseAttendance")
      ..set('class', course)
      ..set('lesson', lesson)
      ..set('scholar', scholar)
      ..set('status', StuAttendState.LabelToStatus("未點名"));
    var repatend = await attendance.save();
    if (repatend.statusCode == 201) {
      print('插入成功');
    } else {
      print(repatend.statusCode);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                    IconButton(
                      color: Color(0xffffffff),
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 30,
                    ),
                    Center(
                      child: Text(
                        "點名",
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Card(
                  //z轴的高度，设置card的阴影
                  elevation: 5,
                  //设置shape，这里设置成了R角
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
                  clipBehavior: Clip.antiAlias,
                  semanticContainer: false,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 170,
                    child: Center(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 150,
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: ClipRRect(
                                    child: Image.network(
                                      url != null
                                          ? url
                                          : 'https://macauscholar.uat.macau520.com:8443/api/files/macauscholar/e1df8f6a424b8778253b0526ae558d16_course2.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )),
                            Container(
                              height: 160,
                              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.className,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff234271),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '地    址:',
                                        style:
                                            TextStyle(color: Color(0xffb5b8c2)),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.adderss == null
                                              ? '澳門水灣坑'
                                              : widget.adderss,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(
                                              color: Color(0xffb5b8c2)),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '學生總數:',
                                        style:
                                            TextStyle(color: Color(0xffb5b8c2)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        allStu.toString(),
                                        style:
                                            TextStyle(color: Color(0xffb5b8c2)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '任課教師:',
                                        style:
                                            TextStyle(color: Color(0xffb5b8c2)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        teaName != null ? teaName : '李長安',
                                        style:
                                            TextStyle(color: Color(0xffb5b8c2)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //region 出勤狀態
              new Container(
                color: Colors.white,
                child: new Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      new ContactItem(
                        count: chuxi.toString(),
                        title: '出席',
                        onPressed: () => add(),
                      ),
                      new ContactItem(
                        count: qingjia.toString(),
                        title: '請假',
                      ),
                      new ContactItem(
                        count: chidao.toString(),
                        title: '遲到',
                      ),
                      new ContactItem(
                        count: quexi.toString(),
                        title: '缺席',
                      ),
                    ],
                  ),
                ),
              ),
              //endregion
              Container(
                height: 500,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return RollCallItem(
                        _listStuAttendance[index].name,
                        _buildPopoverButton(
                          _listStuAttendance[index].state,
                          _listStuAttendance[index].objectId,
                        ));
                  },
                  itemCount: _listStuAttendance.length,
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildPopoverButton(String btnTitle, objectId) {
    return CupertinoPopoverButton(
        popoverHeight: 160,
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
                child: Text("出席"),
                onTap: () {
                  print('出席');
                  _addStudentToScholar(objectId, '出席');
                  Navigator.pop(context);
                  return true;
                },
              ),
              CupertinoPopoverMenuItem(
                leading: Icon(Icons.edit),
                child: Text("遲到"),
                onTap: () {
                  print('遲到');
                  _addStudentToScholar(objectId, '遲到');
                  Navigator.pop(context);
                  return true;
                },
              ),
              CupertinoPopoverMenuItem(
                leading: Icon(Icons.edit),
                child: Text("早退"),
                onTap: () {
                  print('早退');
                  _addStudentToScholar(objectId, '早退');
                  Navigator.pop(context);
                  return true;
                },
              ),
              CupertinoPopoverMenuItem(
                leading: Icon(Icons.edit),
                child: Text("請假"),
                onTap: () {
                  print('請假');
                  _addStudentToScholar(objectId, '請假');
                  Navigator.pop(context);
                  return true;
                },
              ),
              CupertinoPopoverMenuItem(
                leading: Icon(Icons.edit),
                child: Text("缺席"),
                onTap: () {
                  print('缺席');
                  _addStudentToScholar(objectId, '缺席');
                  Navigator.pop(context);
                  return true;
                },
              )
            ],
          );
        });
  }
}

class StuAttendance {
  final String objectId;
  final String name;
  final String state;

  const StuAttendance({this.objectId, this.name, this.state});
}
