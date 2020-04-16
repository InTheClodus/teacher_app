import 'dart:io';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/branch.dart';
const String _keyTableName = 'Employee';
const String keyObjectId='objectId';
const String keyCreatedAt='createdAt';
const String keyUpdatedAt='updatedAt';
const String keyNumber='number';
const String keyDisplayName='displayName';
const String keyEmail='email';
const String keyPhone='phone';
const String keyTitle='title';
const String keyGender='gender';
const String keyAvatar='avatar';
const String keyIdNo='idNo';
const String keyIdCopy='idCopy';
const String keyJoinAt='joinAt';
const String keyBirthday='birthday';
const String keyAddress='address';
const String keyAccountExpires='accountExpires';
const String keyUserAccountControl='userAccountControl';
const String keyOldMySQLID='oldMySQLID';
const String keyBranch='branch';

class Emloyee extends ParseObject implements ParseCloneable{
  Emloyee() : super(_keyTableName);

  Emloyee.clone() : this();

  @override
  Emloyee clone(Map<String, dynamic> map) => Emloyee.clone()..fromJson(map);

  @override
  Emloyee fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);

    if(objectData.containsKey(keyBranch)){
      branch=Branch.clone().fromJson(objectData[keyBranch]);
    }
    return this;
  }



  String get objectId => get<String>(keyObjectId);
  set objectId(String objectId) => set<String>(keyObjectId, objectId);

  DateTime get createdAt => get<DateTime>(keyCreatedAt);
  set createdAt(DateTime createdAt) => set<DateTime>(keyCreatedAt, createdAt);

  DateTime get updatedAt => get<DateTime>(keyUpdatedAt);
  set updatedAt(DateTime updatedAt) => set<DateTime>(keyUpdatedAt, updatedAt);



  String get number => get<String>(keyNumber);
  set number(String number) => set<String>(keyNumber, number);

  String get displayName => get<String>(keyDisplayName);
  set displayName(String displayName) => set<String>(keyDisplayName, displayName);

  String get email => get<String>(keyEmail);
  set email(String email) => set<String>(keyEmail, email);

  String get phone => get<String>(keyPhone);
  set phone(String phone) => set<String>(keyPhone, phone);

  String get title => get<String>(keyTitle);
  set title(String title) => set<String>(keyTitle, title);

  String get gender => get<String>(keyGender);
  set gender(String gender) => set<String>(keyGender, gender);

  File get avatar => get<File>(keyAvatar);
  set avatar(File avatar) => set<File>(keyAvatar, avatar);

  String get idNo => get<String>(keyIdNo);
  set idNo(String idNo) => set<String>(keyIdNo, idNo);

  String get idCopy => get<String>(keyIdCopy);
  set idCopy(String idCopy) => set<String>(keyIdCopy, idCopy);

  String get joinAt => get<String>(keyJoinAt);
  set joinAt(String joinAt) => set<String>(keyJoinAt, joinAt);

  DateTime get birthday => get<DateTime>(keyBirthday);
  set birthday(DateTime birthday) => set<DateTime>(keyBirthday, birthday);

  String get address => get<String>(keyAddress);
  set address(String address) => set<String>(keyAddress, address);

  String get accountExpires => get<String>(keyAccountExpires);
  set accountExpires(String accountExpires) => set<String>(keyAccountExpires, accountExpires);

  num get userAccountControl => get<num>(keyUserAccountControl);
  set userAccountControl(num userAccountControl) => set<num>(keyUserAccountControl, userAccountControl);

  num get oldMySQLID => get<num>(keyOldMySQLID);
  set oldMySQLID(num oldMySQLID) => set<num>(keyOldMySQLID, oldMySQLID);

  Branch get branch=>get<Branch>(keyBranch);
  set branch(Branch branch)=>set<Branch>(keyBranch,branch);


}