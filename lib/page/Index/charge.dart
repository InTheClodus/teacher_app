import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/domian/collection_utils.dart';
import 'package:teacher_app/module/orderRecord.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
    _getStudentOrder();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getOrder() async {
    var queryBuilder = QueryBuilder<OrderRecords>(OrderRecords())
      ..whereStartsWith(OrderRecords.keyName, "学费");

    var response = await queryBuilder.query();

    if (response.success) {
      print("====================getOrder====================");
      print(((response.results as List<dynamic>).first as OrderRecords)
          .toString());
    } else {
      print(response.error.message);
    }
  }

  /*
  * 查詢訂單
  * 查詢StudentOrderItem表
  * amount實交
  * price裡price是應交
  * */
  Future<void> _getStudentOrder() async {
    final user = await ParseUser.currentUser() as ParseUser;
    if (user != null) {
      QueryBuilder<ParseObject> querUser =
      QueryBuilder<ParseObject>(ParseObject('_User'))
        ..whereEqualTo('objectId', user.objectId)
        ..includeObject(['employee']);
      var repuser = await querUser.query();
      if (repuser.success && isValidList(repuser.results)) {
        QueryBuilder<ParseObject> queryEmp =
        QueryBuilder<ParseObject>(ParseObject('Employee'))
          ..whereEqualTo(
              'objectId', repuser.results.first['employee']['objectId'])
          ..includeObject(['branch']);
        var repEmp = await queryEmp.query();
        if (repEmp.success && isValidList(repEmp.results)) {
          print(repEmp.results.first['branch']['objectId']);
          QueryBuilder<ParseObject> queryBranch =
          QueryBuilder<ParseObject>(ParseObject('Student'))
            ..whereRelatedTo('students', 'Branch',
                repEmp.results.first['branch']['objectId'])
            ..includeObject(['member']);
          var repstulist = await queryBranch.query();
          if (repstulist.result != null) {
            for (var datastu in repstulist.result) {
              setState(() {
                student.set("objectId", datastu["objectId"]);
              });
              QueryBuilder<ParseObject>queryStuOrder = QueryBuilder<
                  ParseObject>(ParseObject("StudentOrder"))
              ..whereEqualTo("student", student);
              var repStuOrder=await queryStuOrder.query();
              if(repStuOrder.success&&isValidList(repStuOrder.results)){
                print("-------------CG");
                print(datastu['member']['displayName']);
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget divider1 = Divider(
      color: Colors.black12,
    );
    return new Scaffold(
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
          SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  HistoricalOrder(
                    state: '未完成',
                    title: '第一學期學費',
                    stuName: '張三',
                    dateTime: DateTime.now(),
                    amount: 5000,
                    onPressed: () => print('第一個'),
                  ),
                  HistoricalOrder(
                    state: '未完成',
                    title: '第一學期學費',
                    stuName: '張三',
                    dateTime: DateTime.now(),
                    amount: 5000,
                  ),
                  HistoricalOrder(
                    state: '未完成',
                    title: '第一學期學費',
                    stuName: '張三',
                    dateTime: DateTime.now(),
                    amount: 5000,
                  )
                ],
              )),
          SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  HistoricalOrder(
                    state: '完成',
                    title: '第一學期學費',
                    stuName: '張三',
                    dateTime: DateTime.now(),
                    amount: 5000,
                    onPressed: () => print('第一個'),
                  ),
                  HistoricalOrder(
                    state: '完成',
                    title: '第一學期學費',
                    stuName: '張三',
                    dateTime: DateTime.now(),
                    amount: 5000,
                  ),
                  HistoricalOrder(
                    state: '完成',
                    title: '第一學期學費',
                    stuName: '張三',
                    dateTime: DateTime.now(),
                    amount: 5000,
                  )
                ],
              )),
        ],
      ),
    );
  }
}


