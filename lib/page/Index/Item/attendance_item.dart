import 'package:flutter/material.dart';

class AttendanceItem extends StatelessWidget {
  AttendanceItem({Key key, this.icons, this.title, this.onPressed, this.color, this.height, this.width})
      : super(key: key);

  final IconData icons;
  final String title;
  final VoidCallback onPressed;
  final Color color;
  final num height;
  final num width;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          decoration: new BoxDecoration(
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
            color: color
          ),
          height: height,
          width: width,
          //设置 child 居中
          alignment: Alignment.center,
          child: new Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 5),),
              new Icon(
                icons,
                color: Colors.white,
              ),
              new Text(title,
                  style: new TextStyle(color: Colors.white, fontSize: 14.0)),
            ],
          ),
        ));
  }
}
