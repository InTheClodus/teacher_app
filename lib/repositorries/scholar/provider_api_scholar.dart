
import 'package:teacher_app/base/api_response.dart';
import 'package:teacher_app/module/employee.dart';
import 'package:teacher_app/module/scholar.dart';
import 'package:teacher_app/repositorries/scholar/contract_provider_scholar.dart';

class ScholarProviderApi implements ScholarContractProvider{
  @override
  Future<ApiResponse> add(Scholar scholar) {

    return null;
  }

  @override
  Future<ApiResponse> addAll(List<Scholar> list) {

    return null;
  }

  @override
  Future<ApiResponse> getAll() {

    return null;
  }

  @override
  Future<ApiResponse> getByEmp(Emloyee emloyee) {

    return null;
  }

  @override
  Future<ApiResponse> getById(String Id) {

    return null;
  }

  @override
  Future<ApiResponse> getNewerThan(DateTime dateTime) {

    return null;
  }

  @override
  Future<ApiResponse> remove(Scholar scholar) {

    return null;
  }

  @override
  Future<ApiResponse> update(Scholar scholar) {

    return null;
  }

  @override
  Future<ApiResponse> updateAll(List<Scholar> list) {

    return null;
  }

}