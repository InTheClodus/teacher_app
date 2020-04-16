import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/repositorries/reoisitory_employee.dart';
import 'application/application.dart';
import 'routes/Routes.dart';
import 'util/db_util.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}
class _MyAppState extends State<MyApp> {
  EmployeeRepository employeeRepository;
  String text = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget child){
          return MediaQuery(child: child,data:MediaQuery.of(context).copyWith(textScaleFactor: 1.0),);
        },
      // home:Tabs(),
        initialRoute: '/',     //初始化的时候加载的路由
        onGenerateRoute: onGenerateRoute
    );
  }
  Future<void>initData()async{
    await Parse().initialize(keyParseApplicationId, keyParseServerURL,
    masterKey: keyParseMasterKey,
    debug: true,
    coreStore: await CoreStoreSharedPrefsImp.getInstance());
    await initRepository();
  }
  Future<void> initRepository() async {
    employeeRepository ??= EmployeeRepository.init(await getDB());
  }
}