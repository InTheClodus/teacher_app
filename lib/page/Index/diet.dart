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
  List<String> _listStuName = [];
  List<String> _listId = [];
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
        for (var empdata in repuser.result) {
          QueryBuilder<ParseObject> queryEmp =
              QueryBuilder<ParseObject>(ParseObject('Employee'))
                ..whereEqualTo('objectId', empdata['employee']['objectId'])
                ..includeObject(['branch']);
          var repEmp = await queryEmp.query();
          if (repEmp.result != null) {
            var objectId;
            for (var data in repEmp.result) {
              setState(() {
                objectId = data['branch']['objectId'];
              });
            }
            QueryBuilder<ParseObject> queryBranch =
                QueryBuilder<ParseObject>(ParseObject('Student'))
                  ..whereRelatedTo('students', 'Branch', objectId)
                  ..includeObject(['member']);
            var repstulist = await queryBranch.query();
            if (repstulist.result != null) {
              for (var datastu in repstulist.result) {
                setState(() {
                  _listStuName.add(datastu['member']['displayName']);
                  _listId.add(datastu['objectId']);
                  print(datastu['objectId']);
                });
                stuObject.set('objectId', datastu['objectId']);

                QueryBuilder queryfood =
                    QueryBuilder(ParseObject("FoodDailyOrder"))
                      ..whereEqualTo('student', stuObject)
                      ..includeObject(['student']);
                var repfoodOrder = await queryfood.query();
                if (repfoodOrder.statusCode == 200) {
                  if (repfoodOrder.result != null) {
                    for (var datafood in repfoodOrder.result) {
                      setState(() {
                        _listFoodDailyOrder.add(FoodDailyOrder(
                            objectId: datafood['objectId'],
                            items: datafood['items'],
                            date: datafood['date'],
                            stuName: datastu['member']['displayName'],
                            packaged: datafood['packaged']));
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
      body: ListView(
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
                    DataCell(
                        Text(formatDate(post.date, [yyyy, '-', mm, '-', dd]))),
                    DataCell(Text(post.stuName)),
                    DataCell(Text(post.packaged.toString())),
                  ]);
                }).toList()),
          )
        ],
      ),
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
