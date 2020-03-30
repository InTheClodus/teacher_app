import 'package:flutter/material.dart';

class CuriculumInfoItem extends StatelessWidget {
   String title;
   String content;
  CuriculumInfoItem(this.title,this.content);
  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      height: 30,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(title,textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
          ),
          Expanded(
            flex: 4,
            child: Text(content,style: TextStyle(fontSize: 18),),
          )
        ],
      ),
    );
  }

}
