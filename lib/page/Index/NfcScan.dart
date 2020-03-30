import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/StudentSign.dart';
import 'package:toast/toast.dart';

class NfcScan extends StatefulWidget {
  @override
  _NfcScanState createState() => _NfcScanState();
}

class _NfcScanState extends State<NfcScan> {
  bool _supportsNFC = false;
  bool _reading = false;
  StreamSubscription<NDEFMessage> _stream;
  NDEFMessage message;
//  List<AdjustUser> _listAdjustuser = [];

  @override
  void initState() {
    super.initState();
    _getAllAdjustUser();
    NFC.isNDEFSupported.then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
      });
    });
    NFC.writeNDEF(message);
  }

  Future<void> _getAllAdjustUser() async {
//    var response = await ParseObject('AdjustUser').getAll();
//    if (response.success) {
//      setState(() {
//        for (var data in response.result) {
//          _listAdjustuser.add(AdjustUser(
//              data['objectId'],
//              data['UserName'],
//              data['arrivalTime'],
//              data['leaveTime'],
//              data['pickUpMode'],
//              data['phone'],
//              data['exisUnpaid']));
//        }
//      });
//    }
  }

  Future<void> _nfc_signIn(String name) async {
//    final ParseUser user = await ParseUser.currentUser() as ParseUser;
//    if (user != null) {
//      try {
//        for (int i = 0; i <= _listAdjustuser.length; i++) {
//          if (name == _listAdjustuser[i].userName) {
//            var pubchClock = ParseObject('AdjustUser')
//              ..set('objectId', _listAdjustuser[i].objectId)
//              ..set('arrivalTime',
//                  formatDate(DateTime.now(), [hh, ':', nn]).toString())
//              ..set('pickUpMode', '已接送');
//            Toast.show('已签到', context,
//                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//            await pubchClock.save();
//            print('=========================${_listAdjustuser[i].exisUnpaid}');
//            if (_listAdjustuser[i].exisUnpaid > 0) {
//              showDialog(
//                  context: context,
//                  builder: (context) => new AlertDialog(
//                        title: Text('有未支付订单'),
//                        content: Text('是否前往收款'),
//                        actions: <Widget>[
//                          new FlatButton(
//                            child: Text('取消'),
//                            onPressed: () {
//                              Navigator.pop(context);
//                            },
//                          ),
//                          new FlatButton(
//                              onPressed: () {
//                                Navigator.pop(context);
//                              },
//                              child: Text('确定'))
//                        ],
//                      ));
//            }
//          } else {
//            Toast.show('查询中', context,
//                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//          }
//        }
//      } catch (e) {
//        Toast.show('查无此人', context,
//            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//      }
//    } else {
//      Toast.show('登錄超時，請重新登錄', context,
//          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_supportsNFC) {
      return Scaffold(
        appBar: PreferredSize(
          child: Container(
            padding: EdgeInsets.only(left: 10),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff00d7ee), Color(0xff00a7ff)]),
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
                Text("NFC打卡",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            )),
          ),
          preferredSize: Size(double.infinity, 60),
        ),
        body: Scrollbar(
          child: Center(
            child: FlatButton(
                child: Text(
                  "NFC功能未打開",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ),
      );
    }

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
              Text("NFC打卡",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          )),
        ),
        preferredSize: Size(double.infinity, 60),
      ),
      body: Scrollbar(
        child: Center(
          child: FlatButton(
              child: Text(
                _reading ? "停止读卡" : "开始读卡",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              color: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              onPressed: () {
                if (_reading) {
                  _stream?.cancel();
                  setState(() {
                    _reading = false;
                  });
                } else {
                  setState(() {
                    _reading = true;
                    //使用NFC.readNDEF（）开始读取
                    _stream = NFC
                        .readNDEF(
                      once: true,
                      throwOnUserCancel: false,
                    )
                        .listen((NDEFMessage message) {
                      print("读取NFC消息: ${message.payload}");
                      print('INFO==========================>${_stream}');
                      String stuName = message.data;
                      _nfc_signIn(stuName);
                      Toast.show('读取NFC消息: ${message.data}', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    }, onError: (e) {
                      // 检查下面的错误处理指南
                      print('ERROR==========================>$e');
                    });
                  });
                }
              }),
        ),
      ),
    );
  }
}
