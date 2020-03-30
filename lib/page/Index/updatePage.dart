import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/page/public_widget/input_widget.dart';
import 'package:teacher_app/util/Adapt.dart';
import 'package:toast/toast.dart';

class UpdateStuPage extends StatefulWidget {
  final String userName;
  final int stuhei;
  final int stubodyWidth;
  final String userObj;
  final String dataObj;

  const UpdateStuPage(
      {Key key,
      this.userName,
      this.stuhei,
      this.stubodyWidth,
      this.userObj,
      this.dataObj})
      : super(key: key);

  @override
  _UpdateStuPageState createState() => _UpdateStuPageState();
}

class _UpdateStuPageState extends State<UpdateStuPage> {
  final userheight = TextEditingController();
  final bodyWeight = TextEditingController();
  final userName = TextEditingController();

  Future<void> _updataUserInfo() async {
    if (userName.text == null ||
        bodyWeight.text == null ||
        userheight == null) {
      Toast.show('输入不能为空', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      try {
        var updataUser = ParseObject('StudentSign')
          ..set('objectId', widget.userObj)
          ..set('UserName', userName.text);

        var updataGrowup = ParseObject('GrowUp')
          ..set('objectId', widget.dataObj)
          ..set('height', userheight.text)
          ..set('bodyWeight', bodyWeight.text)
          ..set('TestDate', DateTime.now());

        var rep = await updataUser.save();
        var reps = await updataGrowup.save();

        if (rep.success && reps.success) {
          Toast.show('修改成功', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        } else {
          Toast.show('修改失敗', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      } catch (e) {
        Toast.show('异常错误$e', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName.text = widget.userName;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    TextField textField = TextField(
      style: TextStyle(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
      ),
    );
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
                Text("修改資料",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
        ),
        preferredSize: Size(double.infinity, 60),
      ),
      backgroundColor: Color(0xfff4f4f9),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: width,
                height: Adapt.px(279),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    InputWidget('姓名', widget.userName),
                    _inputWidget('身高', widget.stuhei.toString()),
                    _inputWidget('體重', widget.stubodyWidth.toString()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Container(
                width: width * 0.4,
                height: width * 0.1,
                child: FlatButton(
                  onPressed: () {
                    _updataUserInfo();
                  },
                  child: Text(
                    "去修改",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputWidget(String title, String hintxt) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(title),
        ),
        Expanded(
          flex: 4,
          child: TextField(
            style: TextStyle(color: Colors.black, fontSize: 14),
            controller: title == '姓名'
                ? userName
                : title == '身高' ? userheight : bodyWeight,
            onChanged: (v) {},
            decoration: InputDecoration(
              hintText: hintxt,
              border: InputBorder.none,
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.black54),
            ),
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
    );
  }
}
