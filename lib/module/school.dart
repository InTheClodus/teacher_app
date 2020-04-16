import 'dart:core';

import 'package:parse_server_sdk/parse_server_sdk.dart';

const String keySchool = 'School';
const String keyObjectId='objectId';
const String keyCreateAt='createAt';
const String keyUpdateAt='updateAt';
const String keyACL="ACL";
const String keyNumber='number';
const String keyDisplayName='displayName';
const String keyOrder='order';


class School extends ParseObject implements ParseCloneable {
  School() : super(keySchool);
  School.clone() : this();

  @override
  School clone(Map<String, dynamic> map) => School.clone()..fromJson(map);

  String get objectId => get<String>(keyObjectId);
  set objectId(String objectId) => set<String>(keyObjectId, objectId);

  DateTime get createAt => get<DateTime>(keyCreateAt);
  set createAt(DateTime createAt) => set<DateTime>(keyCreateAt, createAt);

  DateTime get updatedAt => get<DateTime>(keyUpdateAt);
  set updatedAt(DateTime updatedAt) => super.set<DateTime>(keyUpdateAt, updatedAt);

  ParseACL get acl => get<ParseACL>(keyACL);
  set acl(ParseACL acl) => set<ParseACL>(keyACL, acl);

  num get order => get<num>(keyOrder);
  set order(num order) => set<num>(keyOrder, order);

  String get displayName => get<String>(keyDisplayName);
  set displayName(String displayName) => set<String>(keyDisplayName, displayName);
}
