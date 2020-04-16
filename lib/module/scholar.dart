import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/branch.dart';
import 'package:teacher_app/module/member.dart';

const String _keyTableName = 'Scholar';
const String keyObjectId='objectId';
const String keyCreatedAt='createAt';
const String keyUpdateAt='updateAt';

const String keyNumber='number';
const String keyBranch='branch';
const String keyEducation='education';
const String keyEducationSchool='educationSchool';
const String keyEducationSubject='educationSubject';
const String keyEducationMediumOfIns='educationMediumOfIns';
const String keyOccupation='occupation';
const String keyOccupationCmpy='occupationCmpy';
//const String keyOccupation_industry='occupation_industry';
const String keyOccupationPosition='occupationPosition';
const String keyOccupationService='occupationService';
const String keyOccupationStudyYear='occupationStudyYear';
const String keyEnquiry='enquiry';
const String keyMember='member';

class Scholar extends ParseObject implements ParseCloneable{
  Scholar() : super(_keyTableName);

  Scholar.clone() : this();

  @override
  Scholar clone(Map<String, dynamic> map) => Scholar.clone()..fromJson(map);

  @override
  Scholar fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);
    if(objectData.containsKey(keyBranch)){
      branch=Branch.clone().fromJson(objectData[keyBranch]);
    }
    if(objectData.containsKey(member)){
      member=Member.clone().fromJson(objectData[keyMember]);
    }
    return this;
  }

  String get objectId => get<String>(keyObjectId);
  set objectId(String objectId) => set<String>(keyObjectId, objectId);

  DateTime get createdAt => get<DateTime>(keyCreatedAt);
  set createdAt(DateTime createdAt) => set<DateTime>(keyCreatedAt, createdAt);

  DateTime get updatedAt => get<DateTime>(keyUpdateAt);
  set updatedAt(DateTime updatedAt) => set<DateTime>(keyUpdateAt, updatedAt);

//  ---------------------

  String get number => get<String>(keyUpdateAt);
  set number(String number) => set<String>(keyUpdateAt, number);

  Branch get branch => get<Branch>(keyBranch);
  set branch(Branch branch) => set<Branch>(keyBranch, branch);

  String get education => get<String>(keyEducation);
  set education(String education) => set<String>(keyEducation, education);

  String get educationSchool => get<String>(keyUpdateAt);
  set educationSchool(String educationSchool) => set<String>(keyUpdateAt, educationSchool);

  String get educationSubject => get<String>(keyEducationSubject);
  set educationSubject(String educationSubject) => set<String>(keyEducationSubject, educationSubject);

  String get educationMediumOfIns => get<String>(keyEducationMediumOfIns);
  set educationMediumOfIns(String educationMediumOfIns) => set<String>(keyEducationMediumOfIns, educationMediumOfIns);

  String get occupation => get<String>(keyOccupation);
  set occupation(String occupation) => set<String>(keyOccupation, occupation);

  String get occupationCmpy => get<String>(keyOccupationCmpy);
  set occupationCmpy(String occupationCmpy) => set<String>(keyOccupationCmpy, occupationCmpy);
//
//  DateTime get occupation_industry => get<DateTime>(keyOccupation_industry);
//  set occupation_industry(DateTime occupation_industry) => set<DateTime>(keyOccupation_industry, occupation_industry);

  String get occupationPosition => get<String>(keyOccupationPosition);
  set occupationPosition(String occupationPosition) => set<String>(keyOccupationPosition, occupationPosition);

  String get occupationService => get<String>(keyOccupationService);
  set occupationService(String occupationService) => set<String>(keyOccupationService, occupationService);

  String get occupationStudyYear => get<String>(keyOccupationStudyYear);
  set occupationStudyYear(String occupationStudyYear) => set<String>(keyOccupationStudyYear, occupationStudyYear);

  List get enquiry => get<List>(keyEnquiry);
  set enquiry(List enquiry) => set<List>(keyEnquiry, enquiry);

  Member get member => get<Member>(keyMember);
  set member(Member member) => set<Member>(keyMember, member);

}