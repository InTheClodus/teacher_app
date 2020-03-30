import 'package:flutter/material.dart';
import 'package:teacher_app/util/Adapt.dart';
/*
*
* */
class ScheduleItem extends StatelessWidget {
  String sc_img;
  String sc_name;
  String sc_time;
  String sc_address;

  @required
  VoidCallback onTap;

  ScheduleItem(this.sc_img, this.sc_name, this.sc_time, this.sc_address,
      {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: Adapt.px(250),
              child: _mineItem(sc_img, sc_name, sc_time, sc_address),
            ),
            Container(
              color: Color(0xffeaeaea),
              constraints: BoxConstraints.expand(height: 1.0),
            ),
          ],
        ));
  }

  Widget _mineItem(String sc_img, String sc_name, String sc_time, String sc_address) {
    return InkWell(
      onTap: () {
        this.onTap();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                width: 200,
                height: 100,
                padding: EdgeInsets.only(left: 16),
                child: Image.asset(
                  sc_img,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(left: 10, top: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    Text(
                      sc_name,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Text(
                      sc_time,
                      style: TextStyle(color: Colors.black38, fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Text(
                      sc_address,
                      style: TextStyle(color: Colors.black38, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
