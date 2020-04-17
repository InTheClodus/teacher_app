import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/util/SizeConfig.dart';

/*
* 膳食
* Author L
* 主要功能：
* 顯示每一天的（默認顯示當天）午餐，
* 下午茶學生名單和數量；
* */
class Diet extends StatefulWidget {
  @override
  _DietState createState() => _DietState();
}

class _DietState extends State<Diet> {
//  初始化方法
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFoodOrder();
  }

  var stuObject = ParseObject("Student");
  List<FoodDailyOrder> _listFoodDailyOrder = [];

  Future<void> _getFoodOrder() async {
    final ParseUser user = await ParseUser.currentUser() as ParseUser;
    if (user != null) {

      QueryBuilder<ParseObject> querUser =
          QueryBuilder<ParseObject>(ParseObject('_User'))
            ..whereEqualTo('objectId', user.objectId)
            ..includeObject(['employee']);
      var repuser = await querUser.query();
      if (repuser.result != null) {
          //      查詢當前登錄用戶的員工身分信息
          QueryBuilder<ParseObject> queryEmp =
              QueryBuilder<ParseObject>(ParseObject('Employee'))
                ..whereEqualTo('objectId', repuser.results.first['employee']['objectId'])
                ..includeObject(['branch']);
          var repEmp = await queryEmp.query();
          if (repEmp.result != null) {
            QueryBuilder<ParseObject> queryBranch =
                QueryBuilder<ParseObject>(ParseObject('Student'))
                  ..whereRelatedTo('students', 'Branch', repEmp.results.first['branch']['objectId'])
                  ..includeObject(['member']);
            var repstulist = await queryBranch.query();
            if (repstulist.result != null) {
              for (var datastu in repstulist.result) {
                stuObject.set('objectId', datastu['objectId']);
                QueryBuilder queryfood =
                    QueryBuilder(ParseObject("FoodDailyOrder"))
                      ..whereEqualTo('student', stuObject)
                      ..includeObject(['student','items']);
                var repfoodOrder = await queryfood.query();
                if (repfoodOrder.statusCode == 200) {
                  if (repfoodOrder.result != null) {
                    for (var datafood in repfoodOrder.result) {
                      print("---------------------------------------------------------------------------------");
                      List<String>_list=[];
                      for (var food in datafood['items']) {
                        print(food['items']['objectId']);
                        QueryBuilder queryFoodInfo = QueryBuilder(
                            ParseObject("Food"))
                          ..whereEqualTo("objectId", food['items']['objectId']);
                        var foodInfo = await queryFoodInfo.query();
                        if (foodInfo.success && foodInfo.result != null) {

                          for (var dataFoodInfo in foodInfo.result) {
                            _list.add(dataFoodInfo['title']);
                            print(_list);
                          }
                        }
                      }
                      setState(() {
                        _listFoodDailyOrder.add(FoodDailyOrder(
                            objectId: datafood['objectId'],
                            items: datafood['items'],
                            lunch: _list[0]==null||_list[0]==''?"無":_list[0],
                            afTea: _list[1]==null||_list[1]==''?"無":_list[1],
                            meal:  _list[2]==null||_list[2]==''?"無":_list[2],
                            date:  datafood['date'],
                            stuName: datastu['member']['displayName'],
                            packaged: datafood['packaged']));
                      });
                      print("---------------------------------------------------------------------------------");
                    }
                  }
                }
              }
            }
          }
      }
    }
  }

  Future<Null> _refresh() async {
    _listFoodDailyOrder.clear();
    await _getFoodOrder();
    return;
  }

  @override
  Widget build(BuildContext context) {
    //獲得屏幕的寬度
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              width: double.infinity,
              height: 96,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffc7d6eb), Color(0xffc7d6eb)]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff2d7fc7), Color(0xff2d7fc7)]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: SafeArea(
                  child: Stack(
                children: <Widget>[
                  IconButton(
                    color: Color(0xffffffff),
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 30,
                  ),
                  Center(
                    child: Text(
                      "膳食",
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
      ),
      body: RefreshIndicator(
        child: ListView(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: [
                    DataColumn(label: Text("姓名")),
                    DataColumn(label: Text('午餐')),
                    DataColumn(label: Text('下午茶')),
                    DataColumn(label: Text('加餐')),
                  ],
                  rows: _listFoodDailyOrder.map((post) {
                    return DataRow(cells: [
                      DataCell(Text(post.stuName)),
                      DataCell(Text(post.lunch)),
                      DataCell(Text(post.afTea)),
                      DataCell(Text(post.meal)),
                    ]);
                  }).toList()),
            )
          ],
        ),
        onRefresh: _refresh,
      )
    );
  }
}

class FoodDailyOrder {
  final String objectId;
  final List items;
  final DateTime date;
  final String stuName;
  final bool packaged;
  final String lunch;
  final String afTea;
  final String meal;

  const FoodDailyOrder(
      {this.lunch,
      this.afTea,
      this.meal,
      this.objectId,
      this.items,
      this.date,
      this.stuName,
      this.packaged});
}
