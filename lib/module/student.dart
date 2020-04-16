import 'dart:io';

import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/food_daily_order.dart';
import 'package:teacher_app/module/school.dart';
import 'package:teacher_app/module/school_year.dart';

const String _keyTableName = 'Student';
const String keyObjectId = 'objectId';
const String keyCreatedAt = 'createdAt';
const String keyUpdatedAt = 'updatedAt';


const String keyNumber='number';
const String keyMember='member';
const String keySchool='school';
const String keySchoolYear='schoolYear';
const String keyJoinAt='joinAt';
const String keyRegistrationForm='registrationForm';
const String keyResultRecord='resultRecord';
const String keyCharacters='characters';
const String keyFavourites='favourites';
const String keyCourses='courses';
const String keyParentRequirements='parentRequirements';
const String keyAllergyFoods='allergyFoods';
const String keyallergyDrugs='allergyDrugs';
const String keyTuitionHistories='tuitionHistories';
const String keyLearningHistories='learningHistories';
const String keySpecialNeeds='specialNeeds';
const String keyAdChannels='adChannels';
const String keyOtherIntention='otherIntention';
const String keyOldMySQLID='oldMySQLID';
const String keyGuardians='guardians';
//const String keyAlbums='albums';


class Student extends ParseObject implements ParseCloneable {
  Student() : super(_keyTableName);

  Student.clone() : this();

  @override
  Student clone(Map<String, dynamic> map) => Student.clone()..fromJson(map);

  @override
  Student fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);

//    if(objectData.containsKey(keyBranch)){
//      branch=Branch.clone().fromJson(objectData[keyBranch]);
//    }
    if(objectData.containsKey(keySchool)){
      school=School.clone().fromJson(objectData[keyStudent]);
      schoolYear=SchoolYear.clone().fromJson(objectData[keySchoolYear]);
    }

    return this;
  }

  String get objectId => get<String>(keyObjectId);
  set objectId(String objectId) => set<String>(keyObjectId, objectId);

  DateTime get createdAt => get<DateTime>(keyCreatedAt);
  set createdAt(DateTime createdAt) => set<DateTime>(keyCreatedAt, createdAt);

  DateTime get updatedAt => get<DateTime>(keyUpdatedAt);
  set updatedAt(DateTime updatedAt) => set<DateTime>(keyUpdatedAt, updatedAt);


//  ------------------
  String get number => get<String>(keyNumber);
  set number(String number) => set<String>(keyNumber, number);

  String get member => get<String>(keyMember);
  set member(String member) => set<String>(keyMember, member);

  School get school => get<School>(keySchool);
  set school(School school) => set<School>(keySchool, school);

  SchoolYear get schoolYear => get<SchoolYear>(keySchoolYear);
  set schoolYear(SchoolYear schoolYear) => set<SchoolYear>(keySchoolYear, schoolYear);

  DateTime get joinAt => get<DateTime>(keyJoinAt);
  set joinAt(DateTime joinAt) => set<DateTime>(keyJoinAt, joinAt);

  File get registrationForm => get<File>(keyRegistrationForm);
  set registrationForm(File registrationForm) => set<File>(keyRegistrationForm, registrationForm);

  File get resultRecord => get<File>(keyResultRecord);
  set resultRecord(File resultRecord) => set<File>(keyResultRecord, resultRecord);

  List get characters => get<List>(keyCharacters);
  set characters(List characters) => set<List>(keyCharacters, characters);

  List get favourites => get<List>(keyFavourites);
  set favourites(List favourites) => set<List>(keyFavourites, favourites);

  List get courses => get<List>(keyCourses);
  set courses(List courses) => set<List>(keyCourses, courses);

  List get parentRequirements => get<List>(keyParentRequirements);
  set parentRequirements(List parentRequirements) => set<List>(keyParentRequirements, parentRequirements);

  List get allergyFoods => get<List>(keyAllergyFoods);
  set allergyFoods(List allergyFoods) => set<List>(keyAllergyFoods, allergyFoods);

  String get allergyDrugs => get<String>(keyallergyDrugs);
  set allergyDrugs(String allergyDrugs) => set<String>(keyallergyDrugs, allergyDrugs);

  List get tuitionHistories => get<List>(keyTuitionHistories);
  set tuitionHistories(List tuitionHistories) => set<List>(keyTuitionHistories, tuitionHistories);

  List get learningHistories => get<List>(keyLearningHistories);
  set learningHistories(List learningHistories) => set<List>(keyLearningHistories, learningHistories);

  List get specialNeeds => get<List>(keySpecialNeeds);
  set specialNeeds(List specialNeeds) => set<List>(keySpecialNeeds, specialNeeds);

  String get adChannels => get<String>(keyAdChannels);
  set adChannels(String adChannels) => set<String>(keyAdChannels, adChannels);

  List get otherIntention => get<List>(keyOtherIntention);
  set otherIntention(List otherIntention) => set<List>(keyOtherIntention, otherIntention);

  num get oldMySQLID => get<num>(keyOldMySQLID);
  set oldMySQLID(num oldMySQLID) => set<num>(keyOldMySQLID, oldMySQLID);

  List get guardians => get<List>(keyGuardians);
  set guardians(List guardians) => set<List>(keyGuardians, guardians);


//  static const String keyBranch='branch';

//
//  Branch get branch=>get<Branch>(keyBranch);
//  set branch(Branch branch)=>set<Branch>(keyBranch,branch);
}
