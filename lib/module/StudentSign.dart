import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/employee.dart';
import 'package:teacher_app/module/student.dart';

const String keyStudentOrder="StudentSign";

const String keyObjectId='objectId';
const String keyCreatedAt='createdAt';
const String keyUpdatedAt='updatedAt';

const String keyStudent='student';
const String keyType='type';
const String keyValue='value';
const String keyInput='input';

class StudentSign extends ParseObject implements ParseCloneable{
  StudentSign() : super(keyStudentOrder);

  @override
  StudentSign fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);

    if(objectData.containsKey(keyInput)){
      input=Emloyee.clone().fromJson(objectData[keyBranch]);
    }
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


  Student get student => get<Student>(keyStudent);
  set student(Student student) => set<Student>(keyStudent, student);

  String get types => get<String>(keyType);
  set types(String type) => set<String>(keyType, type);

  num get value => get<num>(keyValue);
  set value(num value) => set<num>(keyValue, value);

  Emloyee get input => get<Emloyee>(keyInput);
  set input(Emloyee input) => set<Emloyee>(keyInput, input);



}