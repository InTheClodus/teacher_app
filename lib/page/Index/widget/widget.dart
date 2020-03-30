import 'package:flutter/material.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'package:flutter/services.dart';
import 'package:teacher_app/page/Index/Item/attendance_item.dart';

import '../cash_receipts.dart';
// 仿京东付款头部
class PaymentWidget extends StatefulWidget {
  final String mainTitle;
  final String subheading;
  final String subheadingend;
  final String btnName;

  const PaymentWidget(
      {Key key,
      this.mainTitle,
      this.subheading,
      this.subheadingend,
      this.btnName})
      : super(key: key);

  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  String _scanBarcode = "未定義";

  Future<void> scanQR() async {
//    String barcodeScanRes;
//    try {
//      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//          "#ff6666", "取消", true, ScanMode.QR);
//      print(barcodeScanRes);
//    } on PlatformException {
//      barcodeScanRes = '无法获取平台版本.';
//    }
//    if (!mounted) return;
//    setState(() {
//      _scanBarcode = barcodeScanRes;
//    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff00d7ee), Color(0xff00a7ff)],
        ),
      ),
      height: height * 0.2,
      alignment: Alignment.center,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          widget.mainTitle != null
              ? Text(
                  widget.mainTitle,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )
              : null,
          widget.subheading != null
              ? Text(widget.subheading + ' ' + widget.subheadingend,
                  style: TextStyle(color: Colors.white, fontSize: 18))
              : null,
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          widget.btnName != null
              ? FlatButton(
                  onPressed: () {
                    showPub();
                  },
                  child: Text(
                    widget.btnName,
                    style: TextStyle(color: Colors.red),
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                )
              : null,
        ],
      ),
    );
  }

  void showPub() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            height: 190,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.topCenter,
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new AttendanceItem(
                        icons: Icons.camera_alt,
                        title: 'QRCode',
                        onPressed: () => scanQR(),
                      ),
                      new AttendanceItem(
                        icons: Icons.camera_alt,
                        title: '網上支付',
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("網上支付"),
                              );
                            }),
                      ),
                      new AttendanceItem(
                        icons: Icons.camera_alt,
                        title: 'NFC',
                        onPressed: () => showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text("NFC"),
                                );
                              }),
                      ),
                      new AttendanceItem(
                        icons: Icons.camera_alt,
                        title: '現金',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>new CashReceipts()));
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                  iconSize: 45,
                  icon: Icon(Icons.cancel),
                  color: Colors.greenAccent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
