import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/student.dart';

const String keyStudentOrder = "StudentSignIn";
const String keyObjectId = 'objectId';
const String keyCreatedAt = 'createdAt';
const String keyUpdatedAt = 'updatedAt';

const String keyCheckInAt = "checkInAt";
const String keyCheckOutAt = "checkOutAt";
const String keyDate = "date";
const String keyState = "state";
const String keyStudent = 'student';

class StudentSignIn extends ParseObject implements ParseCloneable {
  StudentSignIn() : super(keyStudentOrder);

  @override
  StudentSignIn fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);
    if (objectData.containsKey(keyStudent)) {
      student = Student.clone().fromJson(objectData[keyStudent]);
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

  DateTime get checkInAt => get<DateTime>(keyCheckInAt);
  set checkInAt(DateTime checkInAt) => set<DateTime>(keyCheckInAt, checkInAt);

  DateTime get checkOutAt => get<DateTime>(keyCheckOutAt);
  set checkOutAt(DateTime checkOutAt) => set<DateTime>(keyCheckOutAt, checkOutAt);

  DateTime get date => get<DateTime>(keyDate);
  set date(DateTime date) => set<DateTime>(keyStudent, date);

  String get state => get<String>(keyState);
  set state(String state) => set<String>(keyState, state);

}
