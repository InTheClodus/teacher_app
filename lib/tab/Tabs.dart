import 'package:flutter/material.dart';
import 'package:teacher_app/page/Index/attendance.dart';
import 'package:teacher_app/page/curriculum/curriculum_page.dart';
class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {

  int _currentIndex=0;
  List _pageList=[
    Attendance(),
    CurriculumPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,   //配置对应的索引值选中
        onTap: (int index){
          setState(() {  //改变状态
            this._currentIndex=index;
          });
        },
        iconSize:36.0,      //icon的大小
        fixedColor:Colors.blue,  //选中的颜色
        type:BottomNavigationBarType.fixed,   //配置底部tabs可以有多个按钮
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("首页")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              title: Text("課程")
          ),
        ],
      ),
    );
  }
}