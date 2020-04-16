

import 'dart:io';

import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/user.dart';

 const String _keyTableName = 'Branch';
 const String keyObjectId='objectId';
 const String keyCreateAt='createAt';
 const String keyUpdateAt='updatedAt';

 const String keyNumber='number';
 const String keydisplayName='displayName';
 const String keysubTitle='subTitle';
 const String keyenTitle='enTitle';
 const String keyAvatar='avatar';
 const String keyAddress='address';
 const String keyLocation='location';
 const String keyTimeTable='timeTable';
 const String keyContacts='contacts';
 const String keyRemark='remark';
 const String keyorder='order';
 const String keyoldMySQLID='oldMySQLID';

class Branch extends ParseObject implements ParseCloneable{
  Branch() : super(_keyTableName);

  Branch.clone() : this();

  @override
  Branch clone(Map<String, dynamic> map) => Branch.clone()..fromJson(map);

  @override
  Branch fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);
    return this;
  }
  String get  objectId=> get<String>(keyObjectId);
  set objectId(String objectId) => set<String>(keyObjectId, objectId);

  DateTime get createAt => get<DateTime>(keyCreateAt);
  set createAt(DateTime createAt) => set<DateTime>(keyCreateAt, createAt);

  DateTime get updateAt => get<DateTime>(keyUpdateAt);
  set updateAt(DateTime updateAt) => set<DateTime>(keyUpdateAt, updateAt);

//  --------
  String get number => get<String>(keyNumber);
  set number(String number) => set<String>(keyNumber, number);

  String get displayName => get<String>(keydisplayName);
  set displayName(String displayName) => set<String>(keydisplayName, displayName);

  String get subTitle => get<String>(keysubTitle);
  set subTitle(String subTitle) => set<String>(keysubTitle, subTitle);

  String get enTitle => get<String>(keyenTitle);
  set enTitle(String enTitle) => set<String>(keyenTitle, enTitle);

  File get avatar => get<File>(keyAvatar);
  set avatar(File avatar) => set<File>(keyAvatar, avatar);

  String get address => get<String>(keyAddress);
  set address(String address) => set<String>(keyAddress, address);

  ParseGeoPoint get location => get<ParseGeoPoint>(keyLocation);
  set location(ParseGeoPoint location) => set<ParseGeoPoint>(keyLocation, location);

  List get timeTable => get<List>(keyTimeTable);
  set timeTable(List timeTable) => set<List>(keyTimeTable, timeTable);

  List get contacts => get<List>(keyContacts);
  set contacts(List contacts) => set<List>(keyContacts, contacts);

  String get remark => get<String>(keyRemark);
  set remark(String remark) => set<String>(keyRemark, remark);

  num get order => get<num>(keyorder);
  set order(num order) => set<num>(keyorder, order);

  num get oldMySQLID => get<num>(keyoldMySQLID);
  set oldMySQLID(num oldMySQLID) => set<num>(keyoldMySQLID, oldMySQLID);
}