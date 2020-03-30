import 'package:flutter/material.dart';
import 'package:teacher_app/module/user.dart';
import 'package:teacher_app/style/myColors.dart';
import 'package:teacher_app/tab/Tabs.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

enum FormMode { LOGIN, SIGNUP }

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //用于检查输入框是否为空

  String _email;
  String _password;

  FormMode _formMode = FormMode.LOGIN; //初始化為登錄表單
  bool _isLoading;

  //在执行登录或注册前检查表单是否有效
  bool _validateAndSave() {
    final FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  //执行登录或注册
  Future<void> _validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_validateAndSave()) {
      final User user = User(_email, _password, _email);
      ParseResponse response;
      try {
        if (_formMode == FormMode.LOGIN) {
          response = await user.login();
          print('登錄事件');
        } else {
          response = await user.signUp();
          print('注册用户:');
        }
        setState(() {
          _isLoading = false;
        });
        if (response.success) {
          if (_formMode == FormMode.LOGIN) {
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => new Tabs()),
                (route) => route == null);
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        print('錯誤: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formMode = FormMode.LOGIN;
    });
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
              gradient: LinearGradient(
                  colors: [Color(0xff00d7ee), Color(0xff00a7ff)]),
            ),
            child: SafeArea(
              child: Container(
                  width: width,
                  child: Center(
                    child: Text(
                      "登錄",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )),
            ),
          ),
          preferredSize: Size(double.infinity, 60),
        ),
        backgroundColor: Color(0xfff4f4f9),
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: const CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showBody() {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showSecondaryButton(),
            ],
          ),
        ));
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: '郵箱',
            icon: const Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (String value) => value.isEmpty ? '郵箱不能為空' : null,
        onSaved: (String value) => _email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: '密碼',
            icon: const Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (String value) => value.isEmpty ? '密碼不能為空' : null,
        onSaved: (String value) => _password = value,
      ),
    );
  }

  Widget _showSecondaryButton() {
    return FlatButton(
      child: _formMode == FormMode.LOGIN
          ? Text('創建一個用戶',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF279BC6),
                  fontWeight: FontWeight.w300))
          : Text('已有用戶？登錄',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF279BC6),
                  fontWeight: FontWeight.w300)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin, //使用三元表達式 判斷當前是登錄還是註冊表單，執行對應方法
    );
  }

  Widget _showPrimaryButton() {
    return Container(
      padding: EdgeInsets.only(top: 45),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: MyColors.color_main,
          child: _formMode == FormMode.LOGIN
              ? Text('登錄',
                  style: TextStyle(fontSize: 20.0, color: Colors.white))
              : Text('創建用戶',
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: _validateAndSubmit,
        ),
      ),
    );
  }
}
