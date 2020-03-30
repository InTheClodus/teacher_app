import 'dart:async';
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:teacher_app/module/studentStatus.dart';
import 'package:teacher_app/widget/contact_item.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:toast/toast.dart';
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

  const RollCallPage({Key key, this.className, this.clssTime, this.adderss}) : super(key: key);

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
  String sk = "即將到達上課時間";

  List<String> Item = <String>[
    '出席',
    '遲到',
    '請假',
    '缺席',
  ];

//  获取学生状态信息
  List<StudentStatus> _listStudentstatus = [];

  Future<void> _getStuStatus() async {
    var response = await ParseObject('StudentStatus').getAll();
    if (response.success) {
      setState(() {
        _listStudentstatus.clear();
        for (var data in response.result) {
          _listStudentstatus.add(StudentStatus(data['objectId'],
              data['stuName'], data['stuStatus'], data['curriculum']));
        }
        allStu = response.count;
      });
    }
  }


//  修改
//  Future<void> _update_stuStatu(String Id, String status) async {
//    var statusparse = ParseObject('StudentStatus')
//      ..set('objectId', Id)
//      ..set('stuStatus', status);
//    var response = await statusparse.save();
//    if (response.success) {
//      setState(() {
//        _getStuStatus();
//        Toast.show('签到成功${status}', context,
//            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//      });
//      _getStuStatus();
//      _getChuXi();
//    }
//    print('--------------------');
//  }

  //region count
  Future<void> _getChuXi() async {
    QueryBuilder<ParseObject> queryChuXi =
        QueryBuilder<ParseObject>(ParseObject('StudentStatus'))
          ..whereEqualTo('stuStatus', '出席');
    var response = await queryChuXi.count();
    if (response.success && response.result != null) {
      setState(() {
        chuxi = response.count;
      });
    }
  }
  //endregion

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCourseImg();
    _getTeaname();
  }

  Future<void> _getCourseImg()async{
    QueryBuilder queryimg=QueryBuilder(ParseObject("CourseClass"))
        ..whereEqualTo('title', widget.className)
        ..includeObject(['course']);
    var rep=await queryimg.query();
    if(rep.success){
      rep.result.map((map){
        setState(() {
          print(map['course']['cover']['url']);
          url=map['course']['cover']['url'];
        });
      }).toList();
    }
  }
  Future<void>_getTeaname()async{
    final ParseUser user = await ParseUser.currentUser() as ParseUser;
    QueryBuilder queryTea=QueryBuilder(ParseObject("_User"))
      ..whereEqualTo('objectId', user.objectId)
      ..includeObject(['teacher']);
    var rep=await queryTea.query();
    if(rep.success){
      for(var data in rep.result){
        setState(() {
          teaName=data['teacher']['displayName'];
        });
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                                width: 130,
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: ClipRRect(
                                    child: Image.network(
                                      url!=null?url:'https://macauscholar.uat.macau520.com:8443/api/files/macauscholar/e1df8f6a424b8778253b0526ae558d16_course2.jpg',
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
                                          widget.adderss==null?'澳門水灣坑':widget.adderss,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style:
                                          TextStyle(color: Color(0xffb5b8c2)),
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
                                        '20人',
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
                                        teaName!=null?teaName:'李長安',
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

              Padding(
                padding: EdgeInsets.only(top: 10),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10),
              ),

              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    RollCallItem(
                        'https://upload.jianshu.io/users/upload_avatars/2958544/02ddb7097fbe?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240',
                        '张三',
                      _buildPopoverButton("未签到"),)
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildPopoverButton(String btnTitle) {
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
                child: Text("出席"),
                onTap: () {
                  print('出席');
                  Navigator.pop(context);
                  return true;
                },
              ),
              CupertinoPopoverMenuItem(
                leading: Icon(Icons.edit),
                child: Text("遲到"),
                onTap: () {
                  print('遲到');
                  Navigator.pop(context);
                  return true;
                },
              ),
              CupertinoPopoverMenuItem(
                leading: Icon(Icons.edit),
                child: Text("早退"),
                onTap: () {
                  print('早退');
                  Navigator.pop(context);
                  return true;
                },
              ),
              CupertinoPopoverMenuItem(
                leading: Icon(Icons.edit),
                child: Text("請假"),
                onTap: () {
                  print('請假');
                  Navigator.pop(context);
                  return true;
                },
              )
            ],
          );
        });
  }


//  String status = '出席';

//  void showPub(int index) {
//    showModalBottomSheet(
//        context: context,
//        builder: (BuildContext context) {
//          return _shareWidget(index);
//        });
//  }
//
//  Widget _shareWidget(int i) {
//    final width = MediaQuery.of(context).size.width;
//    final FixedExtentScrollController scrollController =
//        FixedExtentScrollController(initialItem: _selectedColorIndex);
//    return new Container(
//      height: 240.0,
//      child: new Column(
//        children: <Widget>[
//          Container(
//            width: width * 0.92,
//            child: Row(
//              children: <Widget>[
//                Expanded(
//                    flex: 1,
//                    child: GestureDetector(
//                      child: Text(
//                        '取消',
//                        style: TextStyle(
//                            color: Colors.lightBlueAccent, fontSize: 24),
//                        textAlign: TextAlign.left,
//                      ),
//                      onTap: () {
//                        Navigator.pop(context);
//                      },
//                    )),
//                Expanded(
//                  flex: 1,
//                  child: GestureDetector(
//                    child: Container(
//                      padding: EdgeInsets.only(top: 5),
//                      child: Text(
//                        '确认',
//                        style: TextStyle(
//                            color: Colors.lightBlueAccent, fontSize: 24),
//                        textAlign: TextAlign.right,
//                      ),
//                    ),
//                    onTap: () {
//                      _update_stuStatu(_listStudentstatus[i].objectId, status);
//                      Navigator.pop(context);
//                      initState();
//                    },
//                  ),
//                ),
//              ],
//            ),
//          ),
//          new Padding(
//            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
//            child: new Container(
//              height: 190.0,
//              child: new CupertinoPicker(
//                magnification: 1.0,
//                scrollController: scrollController,
//                itemExtent: 35,
//                backgroundColor: CupertinoColors.white,
//                useMagnifier: true,
//                onSelectedItemChanged: (index) {
//                  setState(() {
//                    status = Item[index];
//                  });
//                },
//                children: List<Widget>.generate(Item.length, (int index) {
//                  return Center(
//                    child: Text(Item[index]),
//                  );
//                }),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
}
