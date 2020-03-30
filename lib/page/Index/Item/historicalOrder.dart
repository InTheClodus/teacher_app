import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/util/SizeConfig.dart';

class HistoricalOrder extends StatelessWidget {
  final String state;
  final String title;
  final String stuName;
  final DateTime dateTime;
  final num amount;
  final VoidCallback onPressed;

  const HistoricalOrder({Key key, this.state, this.title, this.stuName, this.dateTime, this.amount, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    SizeConfig().init(context);
    return Container(
//      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.all(15),
      child: Container(
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: _mineItem(textTheme,title,stuName,dateTime,amount,state),
      ),
    );
  }

  Widget _mineItem(textTheme,String title,String stuName,DateTime dateTime,num amount,state) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child:AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius:
                    BorderRadius.all(Radius.circular(100.0)),
                    //设置四周边框
                    border: new Border.all(
                      width: 2,
                      color: Color(0xff9EA3BA),
                    ),
                  ),
                  child: Text(
                    state,
                    style: TextStyle(
                      color: Color( 0xff9EA3BA),
                      fontSize: SizeConfig.blockSizeVertical*1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            flex: 8,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            style: textTheme.title,
                          ),
                          Text(stuName,style: textTheme.caption,),
                          Text(formatDate(dateTime.toLocal(), [yyyy,'-',mm,'-',dd]),style: textTheme.caption,)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        amount.toString(),
                        style: textTheme.title,
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
                Container(
                  height: 1,
                  color: Color(0xffeaeaea),
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}
