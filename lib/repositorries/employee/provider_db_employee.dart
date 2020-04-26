import 'dart:convert' as json;
import 'package:teacher_app/base/api_error.dart';
import 'package:teacher_app/base/api_response.dart';
import 'package:teacher_app/module/employee.dart';
import 'package:teacher_app/repositorries/employee/contract_provider_employee.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:sembast/sembast.dart';
class EmpLoyeeProviderDB implements EmployeeProvideContract{

  EmpLoyeeProviderDB(this._db, this._store);

  final StoreRef<String, Map<String, dynamic>> _store;
  final Database _db;//數據庫連接工具

  @override
  Future<ApiResponse> add(Emloyee emloyee) async{
    final Map<String,dynamic>values=convertItemToStorageMap(emloyee);
    await _store.record(emloyee.objectId).put(_db, values);
    final Map<String,dynamic>recordFromDB=await _store.record(emloyee.objectId).get(_db);
    return ApiResponse(true,200,<dynamic>[convertRecordToItem(values: recordFromDB)],null);
  }

  @override
  Future<ApiResponse> addAll(List<Emloyee> emps) async {
    final List<Emloyee> itemsInDb = List<Emloyee>();

    for (final Emloyee item in emps) {
      final ApiResponse response = await add(item);
      if (response.success) {
        final Emloyee itemInDB = response.result;
        itemsInDb.add(itemInDB);
      }
    }

    if (itemsInDb.isEmpty) {
      return errorResponse;
    } else {
      return ApiResponse(true, 200, itemsInDb, null);
    }
  }

  @override
  Future<ApiResponse> getAll() async{
    final List<Emloyee> employee = List<Emloyee>();

    final List<SortOrder> sortOrders = List<SortOrder>();
    sortOrders.add(SortOrder(keyDisplayName));
    final Finder finder = Finder(sortOrders: sortOrders);
    final List<RecordSnapshot<String, Map<String, dynamic>>> records =
    await _store.find(_db, finder: finder);

    if (records.isNotEmpty) {
      for (final RecordSnapshot<String, Map<String, dynamic>> record
      in records) {
        final Emloyee userFood = convertRecordToItem(record: record);
        employee.add(userFood);
      }
    } else {
      return errorResponse;
    }

    return ApiResponse(true, 200, employee, null);
  }

  @override
  Future<ApiResponse> getById(String Id) async{
    final Finder finder=Finder(filter: Filter.equals('objectId',Id));
    final RecordSnapshot<String,Map<String,dynamic>>record= await _store.findFirst(_db,finder: finder);
    if(record!=null){
      final Emloyee emloyee=convertRecordToItem(record: record);
      return ApiResponse(true,200,<dynamic>[emloyee],null);
    }else{
      return errorResponse;
    }
  }

  @override
  Future<ApiResponse> getByUser() async{

    final user =await ParseUser.currentUser();
    final RecordSnapshot<String,Map<String,dynamic>>record=await _store.findFirst(_db,finder: user);
    if(record!=null){
      final Emloyee emloyee=convertRecordToItem(record: record);
      return ApiResponse(true,200,<dynamic>[emloyee],null);
    }else{
      return errorResponse;
    }

  }

  @override
  Future<ApiResponse> getNewerThan(DateTime dateTime)async {
    final List<Emloyee> emloyee = List<Emloyee>();

    final Finder finder = Finder(
        filter: Filter.greaterThan(keyVarUpdatedAt, dateTime.millisecondsSinceEpoch));

    final List<RecordSnapshot<String, Map<String, dynamic>>> records =
    await _store.find(_db, finder: finder);

    for (final RecordSnapshot<String, Map<String, dynamic>> record in records) {
      final Emloyee convertedDietPlan = convertRecordToItem(record: record);
      emloyee.add(convertedDietPlan);
    }

    if (records == null) {
      return errorResponse;
    }

    return ApiResponse(true, 200, emloyee, null);
  }

  @override
  Future<ApiResponse> remove(Emloyee emloyee) async{
    final Finder finder =
    Finder(filter: Filter.equals('objectId', emloyee.objectId));
    _store.delete(_db, finder: finder);
    return ApiResponse(true, 200, null, null);
  }

  @override
  Future<ApiResponse> update(Emloyee emloyee) async{
    final Map<String, dynamic> values = convertItemToStorageMap(emloyee);
    final Finder finder =
    Finder(filter: Filter.equals('objectId', emloyee.objectId));
    final int returnedCount =
    await _store.update(_db, values, finder: finder);

    if (returnedCount == 0) {
      return add(emloyee);
    }

    return ApiResponse(true, 200, <dynamic>[emloyee], null);
  }

  Map<String, dynamic> convertItemToStorageMap(Emloyee item) {
    final Map<String, dynamic> values = Map<String, dynamic>();
    // ignore: invalid_use_of_protected_member
    values['value'] = json.jsonEncode(item.toJson(full: true));
    values[keyVarObjectId] = item.objectId;
    if (item.updatedAt != null) {
      values[keyVarUpdatedAt] = item.updatedAt.millisecondsSinceEpoch;
    }

    return values;
  }
  Emloyee convertRecordToItem(
      {RecordSnapshot<String, Map<String, dynamic>> record,
        Map<String, dynamic> values}) {
    try {
      values ??= record.value;
      final Emloyee item =
      Emloyee.clone().fromJson(json.jsonDecode(values['value']));
      return item;
    } catch (e) {
      return null;
    }
  }

  static ApiError error = ApiError(1, 'No records found', false, '');
  ApiResponse errorResponse = ApiResponse(false, 1, null, error);

  @override
  Future<ApiResponse> updateAll(List<Emloyee> emps) async{
    final List<Emloyee> updatedItems = List<Emloyee>();

    for (final Emloyee item in emps) {
      final ApiResponse response = await update(item);
      if (response.success) {
        final Emloyee responseItem = response.result;
        updatedItems.add(responseItem);
      }
    }

    if (updatedItems == null) {
      return errorResponse;
    }

    return ApiResponse(true, 200, updatedItems, null);
  }

}