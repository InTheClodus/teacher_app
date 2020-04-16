import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

const String keyStudentOrder="StudentOrder";
const String keyStuOrderObjectId="objectId";
const String keyItems="items";
const String keyRemark="remark";
const String keyStudentName="studentName";
const String keyDateTo="dateTo";
const String keyNumber="number";
const String keySchoolYear="schoolYear";
const String keySchool="school";
const String keyAmount="amount";
const String keyDateForm="dateFrom";
const String keyStudent="student";
const String keyStudentNo="studentNo";

class StudentOrder extends ParseObject implements ParseCloneable{
  StudentOrder() : super(keyStudentOrder);

  String get objectId => get<String>(keyStuOrderObjectId);
  set objectId(String objectId) => set<String>(keyStuOrderObjectId, objectId);

  get items => get<List>(keyItems);
  set items(List objectId) => set<List>(keyStuOrderObjectId, objectId);

}