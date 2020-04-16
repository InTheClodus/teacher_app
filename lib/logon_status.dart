import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/repositorries/provider_api_employee.dart';

import 'application/application.dart';
import 'login/login.dart';
import 'tab/Tabs.dart';

class DecisionPage extends StatefulWidget {
  @override
  _DecisionPageState createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  String _parseServerState = '正在检查解析服务器...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initParse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(_parseServerState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initParse() async {
    try {
      await Parse().initialize(keyParseApplicationId, keyParseServerURL,
          masterKey: keyParseMasterKey, debug: true);
      final ParseResponse response = await Parse().healthCheck();
      if (response.success) {
        final ParseUser user = await ParseUser.currentUser();
        if (user != null) {
          _redirectToPage(context, Tabs());
        } else {
          _redirectToPage(context, Login(EmployeeProviderApi()));
        }
      } else {
        _redirectToPage(context, Login(EmployeeProviderApi()));
        setState(() {
          _parseServerState =
          '解析服务器不可用\n 由于 ${response.error.toString()}';
        });
      }
    } catch (e) {
      setState(() {
        _parseServerState = e.toString();
      });
    }
  }

  Future<void> _redirectToPage(BuildContext context, Widget page) async {
    final MaterialPageRoute<bool> newRoute =
    MaterialPageRoute<bool>(builder: (BuildContext context) => page);

    final bool nav = await Navigator.of(context)
        .pushAndRemoveUntil<bool>(newRoute, ModalRoute.withName('/'));
    if (nav == true) {
      _initParse();
    }
  }
}