import 'package:flutter/material.dart';
import 'package:teacher_app/style/style.dart';
import 'package:teacher_app/util/Adapt.dart';

/*
* 自定義點名界面的listviewItem
* 思路：
*   顯示學生頭像，姓名，點名狀態 下拉修改狀態
* */

class RollCallItem extends StatelessWidget {


  String stu_img;//頭像
  String stu_name;//姓名
  final Widget state;//狀態


//  @required VoidCallback onTap;

  RollCallItem(this.stu_img,this.stu_name,this.state);

  @override
  Widget build(BuildContext context) {

    return Container(
        child: Column(
          children: <Widget>[
            Container(
              height: Adapt.px(120),
                child: _stuStateItem(stu_img, stu_name,state),
            ),
          ],
        )
    );
  }

  Widget _stuStateItem(String stuImg,String stuName, Widget stuState){

    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: Adapt.px(80),
              height: Adapt.px(80),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(stuImg),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
          ),
          Expanded(
            flex: 5,
            child: Text(
              stuName,
              style: TextStyle(fontSize: 18,color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 2,
            child: stuState,
          ),

          Expanded(
            flex: 1,
            child: Container(
              child: Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
