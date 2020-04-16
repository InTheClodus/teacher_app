import 'dart:core';

import 'package:parse_server_sdk/parse_server_sdk.dart';

const String keySchoolYear = 'SchoolYear';
const String keyObejctId='objectId';
const String keyCreateAt='createAt';
const String keyUpdateAt='updateAt';
const String keyNumber='number';
const String keyDisplayName='displayName';
const String keyOrder='order';
const String keyNext='next';

class SchoolYear extends ParseObject implements ParseCloneable {
  SchoolYear() : super(keySchoolYear);

  SchoolYear.clone() : this();

  @override
  SchoolYear clone(Map<String, dynamic> map) => SchoolYear.clone()..fromJson(map);

//  @override
//  SchoolYear fromJson(Map<String, dynamic> objectData) {
//    super.fromJson(objectData);
//
//    if(objectData.containsKey(keySchoolYear)){
//      next=SchoolYear().clone(0).fromJson(objectData[keySchoolYear]);
//    }
//
//    return this;
//  }

  String get objectId => get<String>(keyObejctId);
  set objectId(String objectId) => set<String>(keyObejctId, objectId);

  DateTime get createAt => get<DateTime>(keyCreateAt);
  set createAt(DateTime createAt) => set<DateTime>(keyCreateAt, createAt);

  DateTime get updateAt => get<DateTime>(keyUpdateAt);
  set protein(DateTime updateAt) => super.set<DateTime>(keyUpdateAt, updateAt);

  num get number => get<num>(keyNumber);
  set carbs(num number) => set<num>(keyNumber, number);

  String get displayName => get<String>(keyDisplayName);
  set fat(String displayName) => set<String>(keyDisplayName, displayName);

  num get order => get<num>(keyOrder);
  set status(num order) => set<num>(keyOrder, order);

  SchoolYear get next=>get<SchoolYear>(keyNext);
  set next(SchoolYear schoolyear) => set<SchoolYear>(keyOrder, schoolyear);
}
