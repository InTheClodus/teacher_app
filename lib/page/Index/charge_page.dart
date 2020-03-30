import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/module/OrderInfo.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:toast/toast.dart';
import 'Item/attendance_item.dart';
import 'Item/order_item.dart';
import 'package:qrscan/qrscan.dart' as scanner;

/*
* 收款詳細信息
* 讓用戶看到有哪些信息再去收款 OrderInfo
* */
class ChargePage extends StatefulWidget {
  final num number;
  final String objectId;

  const ChargePage({Key key, this.number, this.objectId}) : super(key: key);

  @override
  _ChargePageState createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  List<OrderInfoModel> _listOrderinfo = [];
  int zhao_yu = 0;
  final _cash_receipts = TextEditingController(); //实际收款
  bool _sucusse=false;
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
  void _return(){
      Navigator.pop(context);
  }

// 现金收款
  Future<void> _payment() async {
    if (_cash_receipts.text == null ||
        _cash_receipts.text == '' ||
        int.parse(_cash_receipts.text) < _listOrderinfo[widget.number].amount) {
      Toast.show('實際收款不能為空或小於實際收款', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      var payment = ParseObject('OrderRecord')
        ..set('objectId', widget.objectId)
        ..set('OrederStatus', '交易完成');
      var response = await payment.save();
      var pay = ParseObject('OrderInfo')
        ..set('objectId', _listOrderinfo[widget.number].objectId)
        ..set('paymentMethod', '現金交易');
      var rep = await pay.save();
      if (response.success || rep.success) {
        Toast.show('添加成功', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Navigator.pop(context);
        _sucusse=true;
        _return();
      } else {
        Toast.show('添加失敗', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

//  提醒家长网上支付
  Future<void> _paymentIntent() async {
    final ParseUser user = await ParseUser.currentUser() as ParseUser;
    var pay = ParseObject('NoticeParent')
      ..set('noticeTime',
          formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', hh, '', nn]))
      ..set('teaName', user.username)
      ..set('parent', _listOrderinfo[widget.number].drawee);
    var rep = await pay.save();
    if (rep.success) {
      showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: Text('提示'),
                content: Text('已通知，待对方付款'),
                actions: <Widget>[
                  new FlatButton(
                    child: Text('取消'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('确定'))
                ],
              ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getALlOrderInfo();
    print(widget.number);
  }

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
              Text("收款", style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          )),
        ),
        preferredSize: Size(double.infinity, 60),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: _listOrderinfo.length == 0
              ? Text("暂无數據")
              : Column(
                  children: <Widget>[
                    Container(
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
                          Text(
                            '等待收款',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          Text(
                              '需收款' +
                                  ' ' +
                                  _listOrderinfo[widget.number]
                                      .amount
                                      .toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          FlatButton(
                            onPressed: () {
                              showPub();
                            },
                            child: Text(
                              '去收款',
                              style: TextStyle(color: Colors.red),
                            ),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //region 主體
                    Container(
                      padding: EdgeInsets.all(10),
                      color: Color.fromARGB(255, 242, 242, 245),
                      width: width,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: width,
                            height: height * 0.1,
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Text(_listOrderinfo[widget.number]
                                            .drawee),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        Text(
                                          _listOrderinfo[widget.number]
                                              .draweePhone,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text("其他信息"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Container(
                            height: height * 0.2,
                            width: width,
                            color: Colors.white,
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(_listOrderinfo[widget.number]
                                      .receivingParty),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.red,
                                        height: height * 0.1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              _listOrderinfo[widget.number]
                                                  .receivingType,
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              _listOrderinfo[widget.number]
                                                  .condescription,
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              _listOrderinfo[widget.number]
                                                  .amount
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.orange),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    //endregion

                    Container(
                      width: width,
                      height: height * 0.5,
                      child: Column(
                        children: <Widget>[
                          OrderItem('支付方式', '在線支付', true),
                          OrderItem(
                              '商品說明',
                              _listOrderinfo[widget.number].receivingType,
                              false),
                          OrderItem(
                              '創建時間',
                              formatDate(
                                  _listOrderinfo[widget.number].createTiem,
                                  [yyyy, '-', mm, '-', dd, hh, ':', nn]),
                              false),
                          OrderItem('訂單號',
                              _listOrderinfo[widget.number].orderNumber, false)
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void showPub() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: Text('選擇收款方式 '),
                  ),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(CupertinoPageRoute<void>(
                                      maintainState: false, //  是否前一个路由将保留在内存中
                                      builder: (BuildContext context) {
                                        // 生成器
                                        return pageRoute(context);
                                      }));
                            },
                            child: _widget('現金收款'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          InkWell(
                            onTap: () {
                              _paymentIntent();
                            },
                            child: _widget('提醒家長網上支付'),
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          );
        });
  }

  Widget pageRoute(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('現金收款'),
      ),
      child: Center(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Text(
              "现金收款",
              style: TextStyle(fontSize: 23),
              textAlign: TextAlign.center,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    '应收',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                      '¥' + _listOrderinfo[widget.number].amount.toString(),
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, color: Colors.orangeAccent)),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    '实收',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _cash_receipts,
                      decoration: InputDecoration(
                        hintText: '实际收款',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, color: Colors.black54),
                      ),
                      onChanged: (value) {
                        setState(() {
                          zhao_yu = int.parse(value) -
                              _listOrderinfo[widget.number].amount;
                        });
                      },
                    ))
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    '找零',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Expanded(
                  flex: 2,
                  child: Text('¥' + zhao_yu.toString(),
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, color: Colors.orangeAccent)),
                )
              ],
            ),
            FlatButton(
              onPressed: () {
                _payment();
              },
              child: Text(
                "确认收款",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              color: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _widget(String title) {
    return Container(
      height: 45,
      padding: EdgeInsets.all(10),
      color: Colors.black12,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
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
