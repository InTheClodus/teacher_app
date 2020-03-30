import 'package:flutter/material.dart';
import 'package:teacher_app/util/Adapt.dart';

/*
* 水平佈局。顯示標題和內容
* */
class rowItem extends StatelessWidget {
  final String title;
  final String content;

   rowItem(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return (Container(
      width: Adapt.px(700),
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              decoration: new BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, .1),
                //设置10弧度的圆角
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color:Colors.orangeAccent),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
          ],
        ),
      ),
    ));
  }
}
