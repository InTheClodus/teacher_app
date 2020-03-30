import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool isLeftWidget;
  final bool isRightWidget;
  final Color topcColor;
  final Color bottomColor;
  final num appBarHeight;

  const MyAppBar(
      {Key key,
        this.title,
        this.isLeftWidget,
        this.isRightWidget,
        this.topcColor,
        this.bottomColor,
        this.appBarHeight})
      : super(key: key);

  @override
  Size get preferredSize {
    return new Size.fromHeight(56.0);
  }

  @override
  State createState() {
    return new MyAppBarState();
  }
}

class MyAppBarState extends State<MyAppBar> {
  Color topColor;
  Color bottomColor;
  String title = '';
  bool isLeftWidget;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      topColor =
      widget.topcColor == null ? Color(0xff2d7fc7) : widget.topcColor;
      bottomColor =
      widget.bottomColor == null ? Color(0xffc7d6eb) : widget.bottomColor;
      title = widget.title == null || widget.title == '' ? '標題' : widget.title;
      isLeftWidget = widget.isLeftWidget == null ? false : widget.isLeftWidget;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, top: 10),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
                color: bottomColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
          ),
          Container(
            width: double.infinity,
            height: 90,
            decoration: BoxDecoration(
                color: topColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    isLeftWidget==true?
                    IconButton(
                      color: Color(0xffffffff),
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 30,
                    ):Container(),
                    Center(
                      child: Text(
                        title,
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
    );
  }
}