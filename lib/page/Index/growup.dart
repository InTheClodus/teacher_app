import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/module/StudentSign.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
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
  @override
  _GrowUpState createState() => _GrowUpState();
}

class _GrowUpState extends State<GrowUp> with SingleTickerProviderStateMixin {
  List<StudentSign> _listSignData = [];
  var student = ParseObject("Student"); //學生的對象
  var employee = ParseObject("Employee");
  bool isExpanded = false;
  int i=0;//標記默認選中身高
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

//  获得学生对应的成长数据
  Future<void> _getStudentSign(num i) async {
    var empId;
    var branchId;
    final user = await ParseUser.currentUser() as ParseUser;
    if (user != null) {
      QueryBuilder<ParseObject> querUser =
          QueryBuilder<ParseObject>(ParseObject('_User'))
            ..whereEqualTo('objectId', user.objectId)
            ..includeObject([
              'employee',
            ]);
      var repuser = await querUser.query();
      if (repuser.result != null) {
        repuser.result.map((map) {
          setState(() {
            empId = map['employee']['objectId'];
          });
        }).toList();
        QueryBuilder<ParseObject> queryEmp =
            QueryBuilder<ParseObject>(ParseObject('Employee'))
              ..whereEqualTo('objectId', empId)
              ..includeObject(['branch']);
        var repEmp = await queryEmp.query();
        if (repEmp.result != null) {
          repEmp.result.map((map) {
            setState(() {
              branchId = map['branch']['objectId'];
              print("-----------");
              print(map['branch']['objectId']);
            });
          }).toList();
        }

//        查詢所有學生姓名
        QueryBuilder<ParseObject> queryAllStuName =
            QueryBuilder<ParseObject>(ParseObject('Student'))
              ..whereRelatedTo('students', 'Branch', branchId) //查詢的學生信息是與Branch表的students字段相關對應的BranchObjectId
              ..includeObject(['member']); //包含會員對象
        var repAllstuName = await queryAllStuName.query();
        if (repAllstuName.result != null) {
          print('會員對象不為空');
          for (var stuData in repAllstuName.result) {
            setState(() {
              student.set("objectId", stuData['objectId']);
              student.save();
            });
            QueryBuilder queryStuSign = QueryBuilder(ParseObject("StudentSign"))
              ..whereEqualTo('student', student)
              ..whereEqualTo('type', i==0?'BH':'BW')
              ..includeObject(['student', 'input']);
            print(empId);
            var rep = await queryStuSign.query();
            if (rep.result != null) {
              for (var dataSign in rep.result) {
                print(dataSign["input"]["displayName"]);
                setState(() {
                  _listSignData.add(StudentSign(
                      stuobjectId: stuData['objectId'],
                      stuName: stuData['member']['displayName'],
                      type: dataSign['type'],
                      BHandW:dataSign['value'].toString(),
                      updateAt: dataSign['updatedAt'],
                      empobjectId: dataSign["input"]["objectId"]));
                });
              }
              setState(() {
                _listSignData
                    .sort((a, b) => (a.updateAt).compareTo(b.updateAt));
              });
            }
        var emp=ParseObject("Employee");
        emp.set("objectId", empId);
        emp.save();
        for (int i = 0; i <_listSignData.length; i++) {
          var student=ParseObject("Student");
          student.set("objectId", _listSignData[i].stuobjectId);
          student.save();
          var sign = ParseObject("StudentSign")
            ..set("student", student)
            ..set("type", "BH")
            ..set("value", 170)
            ..set('input', emp);
          var r=await sign.save();
          if(r.statusCode==201||r.statusCode==200){
            print('插入成功');
          }
        }
          }
        }
      }
    }
  }

  Future<void> addStudentBAndW(stuId,empId) async {
    for(int i=0;i<2;i++){
      student.set("objectId", stuId);
      employee.set('objectId', empId);
      student.save();
      employee.save();
      var sign = ParseObject("StudentSign")
        ..set("student", student)
        ..set("input", employee)
        ..set("type", i==0?"BH":"BW")
        ..set("value", i==0?double.parse(_txtBH.text):double.parse(_txtBW.text));
      var rep = await sign.save();
      if (rep.statusCode == 201) {
        _getStudentSign(i);
        Toast.show("添加成功", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }else if(rep.statusCode==111){
        Toast.show("數據格式錯誤，請檢查", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStudentSign(i);
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

            onTap: (f){
              setState(() {
                i=f;
                _listSignData.clear();
                _getStudentSign(i);
              });
            },
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
            physics: new NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              GrowupWidget('身高'),
              GrowupWidget('體重'),
            ],
          ),
        ));
  }

  Widget GrowupWidget(title) {

    return Container(
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
                rows: _listSignData.map((post) {
                  return DataRow(cells: [
                    DataCell(Text(post.stuName)),
                    DataCell(Text(post.BHandW)),
                    DataCell(FlatButton(
                      onPressed: () {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('新增${post.stuName}紀錄'),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 8),
                                      child: Text("身高"),
                                    ),
                                    CupertinoTextField(
                                      controller: _txtBH,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 8),
                                      child: Text("體重"),
                                    ),
                                    CupertinoTextField(
                                      controller: _txtBW,
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
                                      addStudentBAndW(post.stuobjectId,post.empobjectId);
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
                    DataCell(Text(
                        formatDate(post.updateAt, [yyyy, '-', mm, '-', dd])))
                  ]);
                }).toList()),
          ),
        ],
      ),
    );
  }
}

class StudentSign {
  final Object stuobjectId;
  final String stuName;
  final String BHandW;
  final DateTime updateAt;
  final String type;
  final Object empobjectId;

  const StudentSign(
      {this.stuobjectId,
      this.stuName,
      this.BHandW,
      this.updateAt,
      this.type,
      this.empobjectId});
}
