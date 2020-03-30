import 'package:flutter/material.dart';
import 'package:radial_button/widget/circle_floating_button.dart';
import 'package:teacher_app/module/DietModel.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/diet.dart';
import 'package:teacher_app/util/SizeConfig.dart';
import 'package:teacher_app/util/type_help.dart';

import 'Item/dietCardItem.dart';

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
  //將後台數據加載到這裡
  List<DietModel> _listDiet = [];

  //添加數據到午餐選擇的列表
  List<DietModel> _listDietSelect = [];

  //添加数据到下午茶的列表中
  List<DietModel> _listDietAftSel = [];

//  菜單集合
  List<DietMM> _listFood = [];
  List<DietMM> _listFoods = [];

  int _isExpanded = -1; //闭合控制  默认全部关闭
  List<int> list = [0, 1, 2, 3, 4, 5];
  List<Item> _data = generateItems(8);

  List<Widget> itemsActionBar;
  GlobalKey<CircleFloatingButtonState> key01 =
  GlobalKey<CircleFloatingButtonState>();

  fechar() {
    key01.currentState.close();
  }

  //  查詢 RElation裏的內容
  Future _gxQuery() async {
    QueryBuilder queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('AlbumPhoto'))
          ..whereRelatedTo('cover', 'Alum', 'LGCgkBMpBB');
    var rep = await queryBuilder.query();
    if (rep.success) {
      for (var data in rep.result) {
        print('------------------_SUCCESS-----------------');
        print(data);
      }
    } else {
      print('--------------------_ERROR-------------------');
    }
  }

  Future<void> _getDiet() async {
    //    var group = new ParseObject('FoodGroup');
//    group.objectId = 'GxDrlmGFS2';
//
//    QueryBuilder<ParseObject> queryPost =
//    QueryBuilder<ParseObject>(ParseObject('FoodGroup'))
//      ..whereStartsWith('objectId', 'GxDrlmGFS2');
//
//    QueryBuilder<ParseObject> queryComment =
//    QueryBuilder<ParseObject>(ParseObject('Food'))
//      ..whereEqualTo('group', group)
//      ..includeObject(['group']);
//
//    var apiResponse = await queryComment.query();
//    print(apiResponse.results);

    /*QueryBuilder<ParseObject> queryPost =
    QueryBuilder<ParseObject>(ParseObject('AlbumPhoto'))
      ..whereRelatedTo('images', 'Alum', 'ZT7oUnQy1p');

    var apiResponse = await queryPost.query();
    if(apiResponse.success){
      var data = apiResponse.results;
      for (var value in data) {
        print(value['objectId']);
      }
    }*/

//
//    var food = await ParseObject('Food').getAll();
//    if (food.success) {
//      for (var data in food.result) {
//        print(data['group']['objectId']);
//        QueryBuilder<ParseObject> queryInfo =
//            QueryBuilder<ParseObject>(ParseObject('FoodGroup'))
//              ..whereStartsWith('objectId', data['group']['objectId']);
//        var foodInfo = await queryInfo.query();
//        if (foodInfo.success) {
//          setState(() {
//            print(foodInfo.result);
//            for (var foodData in foodInfo.result) {
//              _listFood
//                  .add(DietMM(foodData['title'], foodData['cover']['url']));
//              print(foodData['title'] + '     ' + foodData['cover']['url']);
//            }
//          });
//        }
//      }
//    }

    var week = TypeHelp.weekToString(DateTime.now().weekday);
    var response = await ParseObject('FoodCombo').getAll();
    if (response.result != null) {
      for (var data in response.result) {
        if (week != data['title']) {
        } else {
          for (var size in data['size']) {
            var group = size['group'].toString().substring(0, 2);
            if (size['group'] == '午膳主菜' ||
                size['group'] == '午膳副菜' ||
                group == '加餐') {
              for (var items in size['items']) {
                print(items['objectId']);
                QueryBuilder queryFood =
                    QueryBuilder<ParseObject>(ParseObject('Food'))
                      ..whereStartsWith('objectId', items['objectId']);
                var responseFood = await queryFood.query();
                if (responseFood.success) {
                  setState(() {
                    for (var food in responseFood.result) {
                      print(food['title']);
                      print(food['cover']['url']);
                      _listFood
                          .add(DietMM(food['title'], food['cover']['url']));
                    }
                  });
                }
              }
            } else if (size['group'] == '下午茶') {
              for (var items in size['items']) {
                print('------------------------>>>>>');
                print(items['objectId']);
                QueryBuilder queryFood =
                    QueryBuilder<ParseObject>(ParseObject('Food'))
                      ..whereStartsWith('objectId', items['objectId']);
                var responseFood = await queryFood.query();
                if (responseFood.success) {
                  setState(() {
                    for (var food in responseFood.result) {
                      print(food['title']);
                      print(food['cover']['url']);
                      _listFoods
                          .add(DietMM(food['title'], food['cover']['url']));
                    }
                  });
                }
              }
            }
          }
        }
      }
    }
    print('----------------');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemsActionBar = [
      FloatingActionButton(
        heroTag: UniqueKey(),
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          fechar();
          for (int i = 0; i <= _data.length; i++) {
            setState(() {
              _data[i].isExpanded = true;
            });
          }
        },
        child: Text(
          '展開\n全部',
        ),
      ),
      FloatingActionButton(
        heroTag: UniqueKey(),
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          fechar();
          for (int i = 0; i <= _data.length; i++) {
            setState(() {
              _data[i].isExpanded = false;
            });
          }
        },
        child: Text('折疊\n全部'),
      ),
    ];
    _getDiet();
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
      body: SingleChildScrollView(
        child: Container(
          child: _buildPanel(width),
        ),
      ),
      floatingActionButton: CircleFloatingButton.floatingActionButton(
        key: key01,
        items: itemsActionBar,
        color: Colors.greenAccent,
        icon: Icons.add,
        duration: Duration(milliseconds: 1000),
        curveAnim: Curves.ease,
      ),
    );
  }

  Widget divider1 = Divider(
    color: Colors.black12,
  );

  Widget fenge(width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: width,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildPanel(width) {
    final textTheme = Theme.of(context).textTheme;
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                        height: SizeConfig.blockSizeHorizontal*10,
                        width: SizeConfig.blockSizeHorizontal*10,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              'https://upload.jianshu.io/users/upload_avatars/2958544/02ddb7097fbe?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),
                        ),
                      )
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '姓名',
                          style: textTheme.title,
                        ),
                        Text("CT1003",style: textTheme.caption,)
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          body: Container(
            color: Color(0xfff5f5f5),
            width: width,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('午餐：魚片冬瓜',style: TextStyle(color: Color(0xffa3a3a3)),),
                Text('下午茶：中式奶黃包/火龍果',style: TextStyle(color: Color(0xffa3a3a3)),),
                Text('加餐：粟米炒蛋',style: TextStyle(color: Color(0xffa3a3a3)),),
              ],
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}
