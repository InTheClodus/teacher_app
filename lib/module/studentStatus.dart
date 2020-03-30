/*
* 学生信息实体类
* */
import 'package:parse_server_sdk/parse_server_sdk.dart';

class StudentStatus{
  final String objectId;
  final String stuName;
  final String stuStatus;
  final String curriculum;

  StudentStatus(this.objectId,this.stuName, this.stuStatus, this.curriculum);
}

class StudentStatusParse extends ParseObject implements ParseCloneable {

  StudentStatusParse() : super(_keyTableName);
  StudentStatusParse.clone(): this();


  @override clone(Map map) => StudentStatusParse.clone()..fromJson(map);

  static const String _keyTableName = 'StudentStatus';
  static const String keyName = 'stuName';
  static const String keyStatus='stuStatus';
  static const String keyCurriculum='curriculum';

  String get name => get<String>(keyName);
  set name(String name) => set<String>(keyName, name);

  String get status=>get<String>(keyStatus);
  set status(String status)=>set<String>(keyStatus,status);

  String get curriculum=>get<String>(keyCurriculum);
  set curriculum(String curriculum)=>set<String>(keyCurriculum,curriculum);
}
