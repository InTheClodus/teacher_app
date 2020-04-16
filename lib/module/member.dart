import 'package:parse_server_sdk/parse_server_sdk.dart';

 const String _keyTableName = 'Member';
 const String keyObjectId='objectId';
 const String keyCreatedAt='createAt';
 const String keyUpdateAt='updateAt';
 const String keyDisplayName='displayName';
 const String keyEnName='enName';
 const String keyKeyAvatar='avatar';
 const String keyGender='gender';
 const String keyPhone='phone';
 const String keyAddressArea='addressArea';
 const String keyAddress='address';
 const String keyIdNo='idNo';
 const String keyContacts='contacts';
 const String keyOldMySQLID='oldMySQLID';
 const String keyLevel='level';
 const String keyStudent='student';
 const String keyScholar='scholar';

class Member extends ParseObject implements ParseCloneable{
  Member() : super(_keyTableName);

  Member.clone() : this();

  @override
  Member clone(Map<String, dynamic> map) => Member.clone()..fromJson(map);

  @override
  Member fromJson(Map<String, dynamic> objectData) {
    super.fromJson(objectData);
    return this;
  }
}