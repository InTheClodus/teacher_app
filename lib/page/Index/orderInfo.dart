import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/module/OrderInfo.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'Item/order_item.dart';

class OrderInfo extends StatefulWidget {
  final num number;

  const OrderInfo({Key key, this.number}) : super(key: key);

  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  List<OrderInfoModel> _listOrderinfo = [];

  Future<void> _getALlOrderInfo() async {
    var response = await ParseObject('OrderInfo').getAll();
    if (response.success) {
      setState(() {
        for (var data in response.result) {
          _listOrderinfo.add(OrderInfoModel(
              data['objectId'],
              data['amount'],
              data['drawee'],
              data['draweePhone'],
              data['receivingParty'],
              data['receivingType'],
              data['comdescription'],
              data['createTiem'],
              data['orderNumber'],
              data['paymentMethod']));
        }
      });
    }
  }

  Future<void> _payment() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getALlOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
              Text("訂單詳情", style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          )),
        ),
        preferredSize: Size(double.infinity, 60),
      ),
      body: Scrollbar(
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    _listOrderinfo.length == 0
                        ? Text("暂无数据")
                        : Text(
                            _listOrderinfo[widget.number].drawee,
                            style:
                                TextStyle(color: Colors.black87, fontSize: 25),
                          ),
                    _listOrderinfo.length == 0
                        ? Text("暂无数据")
                        : Text(
                            "+" +
                                _listOrderinfo[widget.number].amount.toString(),
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 20,
                            ),
                          ),
                  ],
                ),
              ),
            ), //頂部 支付對象，款數，狀態
            _listViewLine,
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Column(
              children: <Widget>[
                _listOrderinfo.length == 0
                    ? Text("暂无数据")
                    : OrderItem('付款方式',
                        _listOrderinfo[widget.number].paymentMethod, false),
                _listOrderinfo.length == 0
                    ? Text("暂无数据")
                    : OrderItem('商品说明',
                        _listOrderinfo[widget.number].receivingType, false),
                _listOrderinfo.length == 0
                    ? Text("暂无数据")
                    : OrderItem(
                        '创建时间',
                        formatDate(_listOrderinfo[widget.number].createTiem,
                            [yyyy, '-', mm, '-', dd, hh, ':', nn]),
                        false),
                _listOrderinfo.length == 0
                    ? Text("暂无数据")
                    : OrderItem('订单号',
                        _listOrderinfo[widget.number].orderNumber, false),
                _fengexian,
                OrderItem('账单分类', '收款', true),
                OrderItem('备注', '添加', true),
                _fengexian,
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "返回",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _listViewLine {
    return Container(
      color: Color(0xffeaeaea),
      height: 1,
    );
  }

  Widget get _fengexian {
    return Container(
      color: Color(0xffeaeaea),
      height: 6,
    );
  }
}
