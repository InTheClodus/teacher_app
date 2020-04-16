
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/student.dart';
const String _keyTableName = 'Employee';
const String keyObjectId='objectId';
const String keyCreatedAt='createdAt';
const String keyUpdatedAt='updatedAt';
const String keyACL='ACL';

const String keyDate='date';
const String keyMenu='menu';
const String keyPackaged='packaged';
const String keyItems='items';
const String keyStudent='student';


class FoodDailyOrder extends ParseObject implements ParseCloneable{
  FoodDailyOrder() : super(_keyTableName);

  FoodDailyOrder.clone() : this();

  var menu=ParseObject('FoodMenu');
  @override
  FoodDailyOrder clone(Map<String, dynamic> map) => FoodDailyOrder.clone()..fromJson(map);

  @override
  FoodDailyOrder fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);

    if(objectData.containsKey(keyStudent)){
      student=Student.clone().fromJson(objectData[keyStudent]);
    }
    return this;
  }



  String get objectId => get<String>(keyObjectId);
  set objectId(String objectId) => set<String>(keyObjectId, objectId);

  DateTime get createdAt => get<DateTime>(keyCreatedAt);
  set createdAt(DateTime createdAt) => set<DateTime>(keyCreatedAt, createdAt);

  DateTime get updatedAt => get<DateTime>(keyUpdatedAt);
  set updatedAt(DateTime updatedAt) => set<DateTime>(keyUpdatedAt, updatedAt);

  String get ACL => get<String>(keyACL);
  set ACL(String ACL) => set<String>(keyACL, ACL);

  DateTime get date => get<DateTime>(keyDate);
  set number(DateTime number) => set<DateTime>(keyDate, number);

  ParseObject get displayName => get<ParseObject>(keyMenu);
  set displayName(ParseObject displayName) => set<ParseObject>(keyMenu, displayName);

  bool get packaged => get<bool>(keyPackaged);
  set packaged(bool packaged) => set<bool>(keyPackaged, packaged);

  String get items => get<String>(keyItems);
  set phone(String items) => set<String>(keyItems, items);

  Student get student=>get<Student>(keyStudent);
  set student(Student student)=>set<Student>(keyStudent,student);


}