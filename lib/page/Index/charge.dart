import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/domian/collection_utils.dart';
import 'package:teacher_app/module/orderRecord.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/widget/CustomDialog.dart';
import 'package:teacher_app/widget/SegmentControl.dart';

import 'Item/historicalOrder.dart';

/*
* 收費
* @Author
* 主要功能：
* 1、學生拍卡考勤後，
* 如果有為完成支付的訂單，
* 應用會進行提醒，
* 確定後可以直接進入收費介面，
* 添加現金支付紀錄，
* 或者取消後，
* 自行提示家長在會員應用中網上支付；
*2、可以透過學生卡QRCode(二維碼)，
* 或者 NFC，家長QRCode，
* 快速打開學生未支付訂單，
* 然後新增現金支付或提醒家長網上支付；
* 3、默認顯示未收費的學生訂單；
* 4、可以收取所有未收費訂單，
* 其他分店的，或者課程訂單；
* 但是非本店訂單無法查看訂單詳情；
* */
class Charge extends StatefulWidget {
  @override
  _ChargeState createState() => _ChargeState();
}

class _ChargeState extends State<Charge> with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    new Tab(text: "未完成"),
    new Tab(text: "已完成"),
  ];
  TabController _tabController;

  var student = ParseObject("Student");
  var stuOrderItem = ParseObject("StudentOrderItem");
  final amount = TextEditingController();
  List<StudentOrderItem> _listStuOrder = [];
  List<StudentOrderItems> _listStuOrders = [];
  bool isOrder = false;
  var stuorderObjectId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
    _getStudentOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

//  c查询订单信息

  Future<void> _getStudentOrders() async {
    final ParseUser user = await ParseUser.currentUser();
//    先查询登录的用户属于哪个学校员工
    if (user != null) {
      QueryBuilder<ParseObject> querUser =
          QueryBuilder<ParseObject>(ParseObject('_User'))
            ..whereEqualTo('objectId', user.objectId)
            ..includeObject(['employee']);
      var repuser = await querUser.query();
      if (repuser.success && isValidList(repuser.results)) {
//        如果登錄的學生是員工身份，
        QueryBuilder<ParseObject> queryEmp =
            QueryBuilder<ParseObject>(ParseObject('Employee'))
              ..whereEqualTo(
                  'objectId', repuser.results.first['employee']['objectId'])
              ..includeObject(['branch']);
        var repEmp = await queryEmp.query();

        if (repEmp.success && isValidList(repEmp.results)) {
//          如果員工信息不為空，查詢所有的學生
          QueryBuilder<ParseObject> queryBranch =
              QueryBuilder<ParseObject>(ParseObject('Student'))
                ..whereRelatedTo('students', 'Branch',
                    repEmp.results.first['branch']['objectId'])
                ..includeObject(['member']);
          var repstulist = await queryBranch.query();
          if (repstulist.success && isValidList(repstulist.results)) {
//            拿到學生資料之後，查詢是否存在對應的訂單
            for (var dataStu in repstulist.result) {
              print(dataStu['member']['displayName']);
              student.set("objectId", dataStu["objectId"]);
              QueryBuilder<ParseObject> queryStuOrder =
                  QueryBuilder<ParseObject>(ParseObject("StudentOrder"))
                    ..whereEqualTo("student", student);
              var repStuOrder = await queryStuOrder.query();
              if (repStuOrder.success && isValidList(repStuOrder.results)) {
                for (var dataOrder in repStuOrder.result) {
                  print(dataOrder['objectId'] + "-----objectId----");
                  for (var orderItem in dataOrder['items'].toList()) {
                    stuorderObjectId = orderItem['items']['objectId'];
                    isOrder = true;
                  }
                  if (isOrder == true) {
                    setState(() {
                      isOrder = false;
                    });
                    QueryBuilder queryOrderItem = QueryBuilder<ParseObject>(
                        ParseObject("StudentOrderItem"))
                      ..whereEqualTo('objectId', stuorderObjectId)
                      ..includeObject(['price']);
                    var repOrderItem = await queryOrderItem.query();
                    print(repOrderItem.results.first['price']['objectId'].toString() + "PriceID");
                    if (repOrderItem.success && isValidList(repOrderItem.results)) {
                      if(repOrderItem.results.first['amount'] !=repOrderItem.results.first['price']['price']){
                        print("------------------True");
                      }else{
                        print('------------------False'+repOrderItem.results.first['amount'].toString()+"---"+repOrderItem.results.first['price']['price'].toString());
                      }
                      if (repOrderItem.results.first['amount'] < repOrderItem.results.first['price']['price']) {
                        print(repOrderItem.results.first['price']['objectId'].toString()+">>>>>>>>>>>");
                        setState(() {
                          _listStuOrder.add(StudentOrderItem(
                              objectId: repOrderItem.results.first['objectId'],
                              stuId: repOrderItem.results.first['student']['objectId'],
                              priceId: repOrderItem.results.first['price']['objectId'],
                              title: repOrderItem.results.first['price']['title'],
                              dateTo: formatDate(repStuOrder.results.first['dateTo'], [yyyy, '-', mm, '-', dd]),
                              dateFrom: formatDate(repStuOrder.results.first['dateFrom'], [yyyy, '-', mm, '-', dd]),
                              stuName: repStuOrder.results.first['studentName'],
                              nedReceive: repOrderItem.results.first['price']['price'],
                              price: repOrderItem.results.first['amount']));
                        });
                      } else {
                        setState(() {
                          _listStuOrders.add(StudentOrderItems(
                              objectId: repOrderItem.results.first['objectId'],
                              stuId: repOrderItem.results.first['student']['objectId'],
                              priceId: repOrderItem.results.first['price']['objectId'],
                              title: repOrderItem.results.first['price']['title'],
                              dateTo: formatDate(repStuOrder.results.first['dateTo'], [yyyy, '-', mm, '-', dd]),
                              dateFrom: formatDate(repStuOrder.results.first['dateFrom'], [yyyy, '-', mm, '-', dd]),
                              stuName: repStuOrder.results.first['studentName'],
                              nedReceive: repOrderItem.results.first['price']['price'],
                              price: repOrderItem.results.first['amount']));
                        });
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

//  添加現金收費
  Future<void> AddCashCharges(
      String objectId, num amount, String stuId, priceId) async {
    var student = ParseObject("Student");
    var price = ParseObject("TuitionServicePrice");
    student.set('objectId', stuId);
    price.set('objectId', priceId);
    print(priceId);
    final ParseUser user = await ParseUser.currentUser();
    QueryBuilder querEmp = QueryBuilder(ParseObject("_User"))
      ..whereEqualTo('objectId', user.objectId)
      ..includeObject(['employee']);
    var emp = await querEmp.query();

    var stuOrderitem = ParseObject("StudentOrderItem")
      ..set("objectId", objectId)
      ..set('student', student)
      ..set('price', price)
      ..set('amount', amount)
      ..set('remark', emp.results.first['employee']['displayName']);
    var rep = await stuOrderitem.save();
    if (rep.success) {
      setState(() {
        _listStuOrder.clear();
        _listStuOrders.clear();
        this.amount.clear();
      });
      _getStudentOrders();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text(
          '收費管理',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff2d7fc7),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        bottom: new TabBar(
          isScrollable: true,
          unselectedLabelColor: Color(0xfff5f5f5),
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor: Color(0xffffc82c),
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListView.builder(
            itemBuilder: (BuildContext context, index) {
              return HistoricalOrder(
                title: _listStuOrder[index].title,
                stuName: _listStuOrder[index].stuName,
                dateTime: DateTime.parse(_listStuOrder[index].dateFrom),
                amount: _listStuOrder[index].price,
                nedReceive: _listStuOrder[index].nedReceive,
                onPressed: () {
                  showPub(context, width, textTheme, _listStuOrder, index);
                },
              );
            },
            itemCount: _listStuOrder.length,
          ),
          ListView.builder(
            itemBuilder: (BuildContext context, index) {
              return HistoricalOrder(
                title: _listStuOrders[index].title,
                stuName: _listStuOrders[index].stuName,
                dateTime: DateTime.parse(_listStuOrders[index].dateFrom),
                amount: _listStuOrders[index].price,
                nedReceive: _listStuOrders[index].nedReceive,
                onPressed: () => print('第${index + 1}個'),
              );
            },
            itemCount: _listStuOrders.length,
          ),
        ],
      ),
    );
  }

  Widget divider1 = Divider(
    color: Colors.black12,
  );

  //region 底部彈窗
  void showPub(context, width, textTheme, _listStuOrder, index) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return _shareWidget(context, width, textTheme, _listStuOrder, index);
        });
  }

  Widget _shareWidget(context, width, textTheme, _listStuOrder, index) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
            color: Color(0xffc8daee),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
          ),
          width: width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '現金收費',
                  style: textTheme.title,
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                      controller: amount,
                      decoration: InputDecoration(
                          prefixText: "收款金額：",
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ))),
                ),
                Text(
                  '商品名稱：${_listStuOrder[index].title}',
                ),
                divider1,
                Text(
                  '學生姓名：${_listStuOrder[index].stuName}',
                ),
                divider1,
                Text(
                  '單品價格：${_listStuOrder[index].nedReceive}',
                ),
                divider1,
                Text(
                  '已收費用：${_listStuOrder[index].price}',
                ),
                divider1,
                Text(
                  '剩餘應收：${_listStuOrder[index].nedReceive - _listStuOrder[index].price}',
                ),
                divider1,
                Container(
                  width: width,
                  height: 60,
                  margin: EdgeInsets.fromLTRB(10, 15, 10, 10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xff82b518),
                        Color(0xff3e73b7)
                      ]), // 渐变色
                      borderRadius: BorderRadius.circular(50)),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Colors.transparent,
                    // 设为透明色
                    elevation: 0,
                    // 正常时阴影隐藏
                    highlightElevation: 0,
                    // 点击时阴影隐藏
                    onPressed: () {
                      if (num.parse(amount.text) > _listStuOrder[index].nedReceive - _listStuOrder[index].price) {
                        showDialog(
                            context: context,
                            builder: (_) => new CustomDialog(
                              title: "提示",
                              isCancel: false,
                              content: "輸入金額過大",
                            ));
                      } else {
                        AddCashCharges(
                            _listStuOrder[index].objectId,
                            _listStuOrder[index].price+num.parse(amount.text),
                            _listStuOrder[index].stuId,
                            _listStuOrder[index].priceId);
                      }
                    },
                    child: Text(
                      '確認收費',
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//endregion
}

class StudentOrderItem {
  final String objectId;
  final String stuId;
  final String priceId;
  final String title;
  final String stuName;
  final String dateTo;
  final String dateFrom;
  final num price;
  final num nedReceive;

  const StudentOrderItem(
      {this.objectId,
      this.stuId,
      this.priceId,
      this.title,
      this.stuName,
      this.dateTo,
      this.dateFrom,
      this.price,
      this.nedReceive});
}

class StudentOrderItems {
  final String objectId;
  final String stuId;
  final String priceId;
  final String title;
  final String stuName;
  final String dateTo;
  final String dateFrom;
  final num price;
  final num nedReceive;

  const StudentOrderItems(
      {this.objectId,
      this.stuId,
      this.priceId,
      this.title,
      this.stuName,
      this.dateTo,
      this.dateFrom,
      this.price,
      this.nedReceive});
}
