
import 'package:flutter/material.dart';

class CashReceipts extends StatefulWidget {
  @override
  _CashReceiptsState createState() => _CashReceiptsState();
}

class _CashReceiptsState extends State<CashReceipts> {

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(left: 10),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient:
            LinearGradient(colors: [Color(0xff00d7ee), Color(0xff00a7ff)]),
          ),
          child: SafeArea(
              child: Row(
                children: <Widget>[
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 18,
                  ),
                  Text("现金收款", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              )),
        ),
        preferredSize: Size(double.infinity, 60),
      ),
      body: Scrollbar(
        child: Container(
          color: Colors.white,
          width: width*0.98,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: width*0.9,
                child: Text('¥55.00',style: TextStyle(fontSize: 33),textAlign: TextAlign.center,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
