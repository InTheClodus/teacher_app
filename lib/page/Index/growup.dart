import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radial_button/widget/circle_floating_button.dart';
import 'package:teacher_app/module/StudentSign.dart';
import 'package:teacher_app/module/growup_model.dart';
import 'package:teacher_app/page/Index/updatePage.dart';
import 'package:teacher_app/page/public_widget/custom_chart_paint.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/util/SizeConfig.dart';

import 'widget/rowItem.dart';

/*
* 成長紀錄
* 主要功能
* 成長數據
* 輸入學生的身高，體重，默認學生最後一次測量時間
* 按照時間昇旭排列
* */

class GrowUp extends StatefulWidget {
  @override
  _GrowUpState createState() => _GrowUpState();
}

class _GrowUpState extends State<GrowUp> {
  List<StudentSign> _listStudentSign = [];
  int _selectedColorIndex = 0;
  String stuName = '未選擇';
  String stuHei = '170';
  String stuWid = '100';
  String userObj;
  final userName = TextEditingController();
  final userheight = TextEditingController();
  final bodyWeight = TextEditingController();

  List<String> _stuList = [];
  List<int> list = [0, 1, 2, 3, 4, 5];
  List<Item> _data = generateItems(8);

  List<Widget> itemsActionBar;
  GlobalKey<CircleFloatingButtonState> key01 =
      GlobalKey<CircleFloatingButtonState>();

  fechar() {
    key01.currentState.close();
  }

//  获取全部学生信息
  Future<void> _stuInfo() async {
    var rep = await ParseObject('Student').getAll();
    if (rep.success) {
      for (var data in rep.result) {
        QueryBuilder queryStu = QueryBuilder<ParseObject>(ParseObject('Member'))
          ..whereEqualTo('objectId', data['member']['objectId']);
        var repquery = await queryStu.query();
        if (repquery.success) {
          setState(() {
            for (var m_stu in repquery.result) {
              _stuList.add(m_stu['displayName']);
              _listStudentSign
                  .add(StudentSign(data['objectId'], m_stu['displayName']));
            }
            print(data['objectId']);
          });
        }
      }
    }
  }

//  获得学生对应的成长数据
  Future<void> _getStudentSign(String id) async {
    QueryBuilder stuQuery = QueryBuilder<ParseObject>(ParseObject('Student'))
      ..whereEqualTo('objectId', id);
    var response = await stuQuery.query();
    print(response.result);
    if (response.success) {
      for (var data in response.result) {
        QueryBuilder stuSign =
            QueryBuilder<ParseObject>(ParseObject('StudentSign'))
              ..whereEqualTo('student', data);
        var repsign = await stuSign.query();
        if (repsign.success) {
          setState(() {
            for (var datas in repsign.result) {
              if (datas['type'] == 'BH') {
                _listHei.add(double.parse(datas['value'].toString()));
                _listDate.add(formatDate(datas['createdAt'], [mm, '-', dd]));
              } else if (datas['type'] == 'BW') {
                _listBodyWig.add(double.parse(datas['value'].toString()));
              }
            }
          });
        }
      }
    }
  }

  List<double> _listHei = []; //身高数据
  List<String> _listDate = [];
  List<double> _listBodyWig = []; //体重数据

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
    _stuInfo();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                      "成長紀錄",
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
                          height: SizeConfig.blockSizeHorizontal * 10,
                          width: SizeConfig.blockSizeHorizontal * 10,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                'https://upload.jianshu.io/users/upload_avatars/2958544/02ddb7097fbe?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '姓名',
                          style: textTheme.title,
                        ),
                        Text(
                          "CT1003",
                          style: textTheme.caption,
                        )
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
                Text(
                  '身高：159.0 CM',
                  style: TextStyle(color: Color(0xffa3a3a3)),
                ),
                Text(
                  '體重：50.0 KG',
                  style: TextStyle(color: Color(0xffa3a3a3)),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '最後紀錄時間：2020-03-26',
                        style: TextStyle(color: Color(0xffa3a3a3)),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text(
                          "新增紀錄",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          print('新增紀錄');
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  //region 底部彈出框

  void showPub() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return _shareWidget();
        });
  }

  Widget _shareWidget() {
    final width = MediaQuery.of(context).size.width;
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: _selectedColorIndex);
    return new Container(
      height: 200.0,
      child: new Column(
        children: <Widget>[
          Container(
            width: width * 0.92,
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new Container(
              height: 190.0,
              child: new CupertinoPicker(
                magnification: 1.0,
                scrollController: scrollController,
                itemExtent: 35,
                backgroundColor: CupertinoColors.white,
                useMagnifier: true,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _listDate.clear();
                    _listBodyWig.clear();
                    _listHei.clear();
                    stuName = _listStudentSign[index].userName;
                    _getStudentSign(_listStudentSign[index].objectId);
                    print(stuName);
                    print(_listStudentSign[index].objectId);
                  });
                },
                children: List<Widget>.generate(_stuList.length, (int index) {
                  return Center(
                    child: Text(_stuList[index]),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
//endregion
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
