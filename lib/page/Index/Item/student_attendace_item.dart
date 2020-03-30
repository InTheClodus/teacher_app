import 'package:cool_ui/cool_ui.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/util/Adapt.dart';
import 'package:teacher_app/util/SizeConfig.dart';

/*
  顯示學生編號
  學生姓名
  到達時間
  離開時間
  狀態
  功能（點擊狀態的時候彈窗提示修改狀態，點擊其他進入學生詳情）
  學生詳情：顯示一個訂單列表信息，出勤信息
* */
class StudentAttendanceItem extends StatefulWidget {
  final IconData icons;
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final num height;
  final num width;

  final String stuName;
  final String stuId;
  final DateTime toTime;
  final DateTime formTime;
  final String state;
  final callback;

  const StudentAttendanceItem({Key key, this.icons, this.title, this.onPressed, this.backgroundColor, this.height, this.width, this.stuName, this.stuId, this.toTime, this.formTime, this.state, this.callback}) : super(key: key);


  @override
  _StudentAttendanceItemState createState() => _StudentAttendanceItemState();
}

class _StudentAttendanceItemState extends State<StudentAttendanceItem> {
  String value;
  void firedA() {
    widget.callback('$value');
  }
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return new InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color(0xffDAF6F4),
        ),
        child: Padding(
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.stuName,
                    style: TextStyle(
                        color: Color(0xff144d7c),
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.safeBlockHorizontal * 5),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Text(
                    'CT1001',
                    style: TextStyle(
                        color: Color(0xff9EA3BA),
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.safeBlockHorizontal * 3),
                  ),
                ],
              ),
              new Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        '到達時間:' +
                            widget.toTime.hour.toString() +
                            ":" +
                            widget.toTime.minute.toString(),
                        style: TextStyle(
                            color: Color(0xff9EA3BA),
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 30,
                        height: 1,
                        color: Color(0xff9EA3BA),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Text(
                        '離開時間:' +
                            widget.formTime.hour.toString() +
                            ":" +
                            widget.toTime.minute.toString(),
                        style: TextStyle(
                            color: Color(0xff9EA3BA),
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )),
              Column(
                children: <Widget>[_buildPopoverButton("接送中")],
              )
            ],
          ),
          padding: EdgeInsets.only(top: 10, left: 15, bottom: 10, right: 10),
        ),
      ),
    );
  }
  Widget _buildPopoverButton(String btnTitle) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: CupertinoPopoverButton(
            child: Container(
              width: 80.0,
              height: 40.0,
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
                      print('接送中');
//                      setState(() {
//                        value="接送中";
//                      });
                      firedA();
                      Navigator.pop(context);
                      return true;
                    },
                  ),
                  CupertinoPopoverMenuItem(
                    leading: Icon(Icons.edit),
                    child: Text("家長自行接送"),
                    onTap: () {
                      print('家長自行接送');
//                      setState(() {
//                        value="家長自行接送";
//                      });
//                      firedA();
                      Navigator.pop(context);
                      return true;
                    },
                  ),
                  CupertinoPopoverMenuItem(
                    leading: Icon(Icons.edit),
                    child: Text("補習中"),
                    onTap: () {
//                      setState(() {
//                        value="接送中";
//                      });
                      print('接送中');
//                      firedA();
                      Navigator.pop(context);
                      return true;
                    },
                  )
                ],
              );
            }));
  }
}
