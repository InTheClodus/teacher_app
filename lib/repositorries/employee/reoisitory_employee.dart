
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/base/api_response.dart';
import 'package:teacher_app/domian/collection_utils.dart';
import 'package:teacher_app/module/employee.dart';
import 'package:teacher_app/module/user.dart';
import 'package:teacher_app/repositorries/employee/contract_provider_employee.dart';
import 'package:sembast/sembast.dart';

import 'provider_api_employee.dart';
import 'provider_db_employee.dart';
class EmployeeRepository implements EmployeeProvideContract{

  //  初始化
  static EmployeeRepository init(Database dbConnection,
      {EmployeeProvideContract mockDBProvider,
        EmployeeProvideContract mockAPIProvider}) {
    final EmployeeRepository repository = EmployeeRepository();

    if (mockDBProvider != null) {
      repository.db = mockDBProvider;
    } else {
      final StoreRef<String, Map<String, dynamic>> store =
      stringMapStoreFactory.store('repository_employee');
      repository.db = EmpLoyeeProviderDB(dbConnection, store);
    }

    if (mockAPIProvider != null) {
      repository.api = mockAPIProvider;
    } else {
      repository.api = EmployeeProviderApi();
    }

    return repository;
  }

  EmployeeProvideContract api;
  EmployeeProvideContract db;

  @override
  Future<ApiResponse> add(Emloyee emloyee,{bool apiOnly=false,bool dbOnly=false}) async{
    if(apiOnly){
      return await api.add(emloyee);
    }if(dbOnly){
      return db.add(emloyee);
    }
    final ApiResponse response=await api.add(emloyee);
    if(response.success){
      await db.add(emloyee);
    }
    return response;
  }

  @override
  Future<ApiResponse> addAll(List<Emloyee> emps,{bool apiOnly=false,bool dbOnly=false})async{
    if(apiOnly){
      return await api.addAll(emps);
    }if(dbOnly){
      return await db.addAll(emps);
    }
    final ApiResponse response=await api.addAll(emps);
    if(response.success&&isValidList(response.results)){
      await db.addAll(response.results);
    }
    return response;
  }

  @override
  Future<ApiResponse> getAll({bool fromApi=false}) {
    if(fromApi){
      return api.getAll();
    }
    return db.getAll();
  }

  @override
  Future<ApiResponse> getById(String Id,{bool fromAPi=false,bool fromDb=false})async {
  if(fromAPi){
    return api.getAll();
  }if(fromDb){
    return db.getAll();
  }
  ApiResponse response=await db.getById(Id);
  if(response.result==null){
    response=await api.getById(Id);
  }
    return response;
  }

  @override
  Future<ApiResponse> getByUser({bool fromAPi=false,bool fromDb=false}) async{
    if(fromAPi){
      return api.getByUser();
    }if(fromDb){
      return db.getByUser();
    }
    ApiResponse response=await db.getByUser();
    if(response.result==null){
      response=await api.getByUser();
    }
    return response;
  }

  @override
  Future<ApiResponse> getNewerThan(DateTime dateTime,{bool fromApi = false, bool fromDb = false}) async{
    if(fromApi){
      return await api.getNewerThan(dateTime);
    }if(fromDb){
      return await db.getNewerThan(dateTime);
    }
    final ApiResponse response =await api.getNewerThan(dateTime);
    if(response.success&&isValidList(response.results)){
      await db.updateAll(response.results);
    }
    return response;
  }

  @override
  Future<ApiResponse> remove(Emloyee emloyee,{bool apiOnly = false, bool dbOnly = false}) async {
    if(apiOnly){
      return await api.remove(emloyee);
    }
    if(dbOnly){
      return await db.remove(emloyee);
    }
    ApiResponse response =await api.remove(emloyee);
    response =await db.remove(emloyee);
    return response;
  }

  @override
  Future<ApiResponse> update(Emloyee emloyee,{bool apiOnly = false, bool dbOnly = false}) async {
    if(apiOnly){
      return await api.update(emloyee);
    }if(dbOnly){
      return await db.update(emloyee);
    }
    ApiResponse response=await api.update(emloyee);
    response =await db.update(emloyee);
    return response;
  }

  @override
  Future<ApiResponse> updateAll(List<Emloyee> emps,
      {bool apiOnly = false, bool dbOnly = false}) async {
    if(apiOnly){
      await api.updateAll(emps);
    }if(dbOnly){
      await db.updateAll(emps);
    }
    ApiResponse response=await api.updateAll(emps);
    if(response.success&&isValidList(response.results)){
      response =await db.updateAll(response.results);
    }
    return response;
  }

}