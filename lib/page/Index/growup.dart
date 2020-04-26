import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/base/api_response.dart';
import 'package:teacher_app/domian/collection_utils.dart';
import 'package:teacher_app/module/StudentSign.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/repositorries/employee/contract_provider_employee.dart';
import 'package:teacher_app/repositorries/employee/reoisitory_employee.dart';
import 'package:teacher_app/util/SizeConfig.dart';
import 'package:teacher_app/widget/calendarshow/simple_gesture_detector.dart';
import 'package:toast/toast.dart';

/*
* 成長紀錄
* 主要功能
* 成長數據
* 輸入學生的身高，體重，默認學生最後一次測量時間
* 按照時間昇旭排列
* */

class GrowUp extends StatefulWidget {
  const GrowUp(this.employeeProvideContract);

  final EmployeeProvideContract employeeProvideContract;

  @override
  _GrowUpState createState() => _GrowUpState();
}

class _GrowUpState extends State<GrowUp> with SingleTickerProviderStateMixin {
  List<StudentSign> _listSignData = [];
  List<StudentSign> _listSignDatas = [];
  var student = ParseObject("Student"); //學生的對象
  var employee = ParseObject("Employee");
  List<String> listStuName = [];
  bool isExpanded = false;
  int i = 0; //標記默認選中身高
  final TextEditingController _textStuName = TextEditingController();
  final TextEditingController _txtBH = TextEditingController();
  final TextEditingController _txtBW = TextEditingController();

  final List<Tab> tabs = <Tab>[
    new Tab(text: "身高"),
    new Tab(text: "體重"),
  ];
  TabController _tabController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> test() async {
    setState(() {
      _listSignData.clear();
    });
    final ApiResponse response =
        await widget.employeeProvideContract.getByUser();
    if (response.success) {
      QueryBuilder<ParseObject> queryAllStuName =
          QueryBuilder<ParseObject>(ParseObject('Student'))
            ..whereRelatedTo('students', 'Branch',
                response.results.first['branch']['objectId'])
            //查詢的學生信息是與Branch表的students字段相關對應的BranchObjectId
            ..includeObject(['member']); //包含會員對象
      var repAllstuName = await queryAllStuName.query();
      if (repAllstuName.success && isValidList(repAllstuName.results)) {
        for (var data in repAllstuName.result) {
          setState(() {
            listStuName.add(data['member']['displayName']);
          });
          student.set('objectId', data['objectId']);
          QueryBuilder queryStuSign = QueryBuilder(ParseObject("StudentSign"))
            ..whereEqualTo('student', student)
//            ..whereEqualTo('type', i == 0 ? 'BH' : 'BW')
            ..whereGreaterThan('createdAt', DateTime.parse(formatDate(DateTime.now(), [yyyy,'-',mm,'-','01'])))
            ..includeObject(['student', 'input']);
          var rep = await queryStuSign.query();
          print(rep.results);
          if (rep.statusCode == 200 && isValidList(rep.results)) {
            print('-------------');
            rep.result.map((map) {
              setState(() {
                if (map['type'] == "BH") {
                  _listSignData.add(StudentSign(
                      stuobjectId: data['objectId'],
                      stuName: data['member']['displayName'],
                      type: map['type'],
                      BHandW: map['value'].toString(),
                      updateAt: map['updatedAt'],
                      createAt: map['createdAt'],
                      empobjectId: map["input"]["objectId"]));
                } else {
                  _listSignDatas.add(StudentSign(
                      stuobjectId: data['objectId'],
                      stuName: data['member']['displayName'],
                      type: map['type'],
                      BHandW: map['value'].toString(),
                      updateAt: map['updatedAt'],
                      createAt: map['createdAt'],
                      empobjectId: map["input"]["objectId"]));
                }
              });
            }).toList();
            setState(() {
              _listSignData.sort((a, b) => (a.createAt).compareTo(b.createAt));
            });
          } else {
//            print('-----------------無成長紀錄');
//            var emp = ParseObject("Employee");
//            emp.set("objectId", response.results.first['objectId']);
//            emp.save();
//            var student = ParseObject("Student");
//            student.set("objectId", data['objectId']);
//            student.save();
//            var sign = ParseObject("StudentSign")
//              ..set("student", student)
//              ..set("type", "BW")
//              ..set("value", 70)
//              ..set('input', emp);
//            var r = await sign.save();
//            if (r.statusCode == 201 || r.statusCode == 200) {
//              print('插入成功');
//            }
          }
        }
      }
    }
  }

  Future<Null> _refresh() async {
    _listSignData.clear();
    await test();
    return;
  }

  Future<void> addStudentBAndW(stuId, empId,HorW) async {
    student.set("objectId", stuId);
    employee.set('objectId', empId);
    student.save();
    employee.save();
    var sign = ParseObject("StudentSign")
      ..set("student", student)
      ..set("input", employee)
      ..set("type", HorW)
      ..set("value",
          i == 0 ? double.parse(_txtBH.text) : double.parse(_txtBW.text));
    var rep = await sign.save();
    if (rep.statusCode == 201) {
      setState(() {
        _listSignData.clear();
        test();
      });
      Toast.show("添加成功", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else if (rep.statusCode == 111) {
      Toast.show("數據格式錯誤，請檢查", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

//
//  Future<void> addStudentBAndWs(stuName, empId) async {
//    for (int i = 0; i < 2; i++) {
//      student.set("objectId", stuId);
//      employee.set('objectId', empId);
//      student.save();
//      employee.save();
//      var sign = ParseObject("StudentSign")
//        ..set("student", student)
//        ..set("input", employee)
//        ..set("type", i == 0 ? "BH" : "BW")
//        ..set("value", i == 0 ? double.parse(_txtBH.text) : double.parse(_txtBW.text));
//      var rep = await sign.save();
//      if (rep.statusCode == 201) {
//        setState(() {
//          _listSignData.clear();
//          test(i);
//        });
//        Toast.show("添加成功", context,
//            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//      } else if (rep.statusCode == 111) {
//        Toast.show("數據格式錯誤，請檢查", context,
//            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//      }
//    }
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

//  右滑動
  void _onSwipeRight() {
    if (isExpanded) {
      print("右滑動");
    }
  }

//左滑動
  void _onSwipeLeft() {
    if (isExpanded) {
      print("左滑動");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return Scaffold(
        appBar: new AppBar(
          title: Text(
            '成長紀錄',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.add),
//              onPressed: () {
//                print("點擊");
//                showCupertinoDialog(
//                    context: context,
//                    builder: (context) {
//                      return CupertinoAlertDialog(
//                        title: Text('新增一個學生數據'),
//                        content: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Padding(
//                              padding: EdgeInsets.only(top: 8, bottom: 8),
//                              child: Text("學生姓名"),
//                            ),
//                            CupertinoTextField(
//                              controller: _textStuName,
//                            ),
//                            Padding(
//                              padding: EdgeInsets.only(top: 8, bottom: 8),
//                              child: Text("身高"),
//                            ),
//                            CupertinoTextField(
//                              controller: _txtBH,
//                            ),
//                            Padding(
//                              padding: EdgeInsets.only(top: 8, bottom: 8),
//                              child: Text("體重"),
//                            ),
//                            CupertinoTextField(
//                              controller: _txtBW,
//                            ),
//                          ],
//                        ),
//                        actions: <Widget>[
//                          CupertinoDialogAction(
//                            onPressed: () {
//                              Navigator.pop(context);
//                            },
//                            child: Text('取消'),
//                          ),
//                          CupertinoDialogAction(
//                            onPressed: () {
//                              print(listStuName.contains(_textStuName.text));
//                              print(listStuName);
//                              if (listStuName.contains(_textStuName.text)) {
//                              } else {}
//                            },
//                            child: Text('确定'),
//                          ),
//                        ],
//                      );
//                    });
//              },
//            )
          ],
          centerTitle: true,
          backgroundColor: Color(0xff2d7fc7),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          bottom: new TabBar(
            isScrollable: true,
            unselectedLabelColor: Color(0xfff5f5f5),
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: new BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: Color(0xffffc82c),
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            tabs: tabs,
            controller: _tabController,
          ),
        ),
        body: SimpleGestureDetector(
          onSwipeLeft: _onSwipeLeft,
          onSwipeRight: _onSwipeRight,
          swipeConfig: SimpleSwipeConfig(
            verticalThreshold: 10.0,
            horizontalThreshold: 40.0,
            swipeDetectionMoment: SwipeDetectionMoment.onUpdate,
          ),
          child: TabBarView(
//            physics: new NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              _listSignData.length == 0 ? Center(child: Text("沒有任何紀錄"))
                  : GrowupWidget('身高'),
              _listSignData.length == 0 ? Center(child: Text("沒有任何紀錄"))
                  : GrowupWidget('體重'),
            ],
          ),
        ));
  }

  Widget GrowupWidget(title) {
    return Container(
        child: RefreshIndicator(
      child: ListView(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: [
                  DataColumn(label: Text("姓名")),
                  DataColumn(label: Text(title)),
                  DataColumn(label: Text('操作')),
                  DataColumn(label: Text('日期'))
                ],
                rows: title == "身高"
                    ? _listSignData.map((post) {
                        return DataRow(cells: [
                          DataCell(Text(post.stuName)),
                          DataCell(Text(post.BHandW)),
                          DataCell(FlatButton(
                            onPressed: () {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                          '新增 ${post.stuName} ${title} 紀錄'),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            child: Text(title),
                                          ),
                                          CupertinoTextField(
                                            controller: _txtBH,
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('取消'),
                                        ),
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            addStudentBAndW(post.stuobjectId,
                                                post.empobjectId,"BH");
                                            Navigator.pop(context);
                                            print(_txtBW.text);
                                          },
                                          child: Text('确定'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              "新增",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )),
                          DataCell(Text(formatDate(
                              post.updateAt, [yyyy, '-', mm, '-', dd])))
                        ]);
                      }).toList()
                    : _listSignDatas.map((post) {
                        print(post);
                        return DataRow(cells: [
                          DataCell(Text(post.stuName)),
                          DataCell(Text(post.BHandW)),
                          DataCell(FlatButton(
                            onPressed: () {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text('新增 ${post.stuName} ${title} 紀錄'),
                                      content: Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(top: 8, bottom: 8),
                                            child: Text(title),
                                          ),
                                          CupertinoTextField(
                                            controller: _txtBH,
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          onPressed: () {Navigator.pop(context);},
                                          child: Text('取消'),
                                        ),
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            addStudentBAndW(post.stuobjectId,
                                                post.empobjectId,"BW");
                                            Navigator.pop(context);
                                            print(_txtBW.text);
                                          },
                                          child: Text('确定'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              "新增",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )),
                          DataCell(Text(formatDate(
                              post.updateAt, [yyyy, '-', mm, '-', dd])))
                        ]);
                      }).toList()),
          ),
        ],
      ),
      onRefresh: _refresh,
    ));
  }
}

class StudentSign {
  final Object stuobjectId;
  final String stuName;
  final String BHandW;
  final DateTime updateAt;
  final DateTime createAt;
  final String type;
  final Object empobjectId;

  const StudentSign(
      {this.stuobjectId,
      this.stuName,
      this.BHandW,
      this.createAt,
      this.updateAt,
      this.type,
      this.empobjectId});
}
