import 'package:flutter/material.dart';
/*
*收銀台，可選用那種方式收款
* */
class CashRegister extends StatefulWidget {
  @override
  _CashRegisterState createState() => _CashRegisterState();
}

class _CashRegisterState extends State<CashRegister> {
  String _value = "掃學生二維碼";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "收銀台",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: new Color.fromARGB(255, 242, 242, 245),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "掃學生二維碼",
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Radio<String>(
                        value: '掃學生二維碼',
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "掃家長二維碼",
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Radio<String>(
                        value: '掃家長二維碼',
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "現金收款",
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Radio<String>(
                        value: '現金收款',
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "網上支付",
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Radio<String>(
                        value: '網上支付',
                        groupValue: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              SizedBox(
                width: 200,
                child: FlatButton(
                  onPressed: () {
                    showDialog(context: context,builder: (context){
                      return AlertDialog(
                        content: Text("施工隊正在施工中"),
                      );
                    });
                  },
                  child: Text(
                    "收款",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
