import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final String title;
  final String content;
  final bool isJt;

  OrderItem(
    this.title,
    this.content,
    this.isJt,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Container(
              height: 35,
              padding: EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              height: 35,
              alignment: Alignment.centerRight,
              child: Text(
                content,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          isJt == false
              ? Expanded(flex: 1,child: Container(),)
              : Expanded(
                  flex: 1,
                  child: Container(
                    height: 35,
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.keyboard_arrow_right,
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
