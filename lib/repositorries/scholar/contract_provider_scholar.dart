import 'package:teacher_app/base/api_response.dart';
import 'package:teacher_app/module/employee.dart';
import 'package:teacher_app/module/scholar.dart';

abstract class ScholarContractProvider {
  Future<ApiResponse> add(Scholar scholar);

  Future<ApiResponse> addAll(List<Scholar> list);

  Future<ApiResponse> update(Scholar scholar);

  Future<ApiResponse> updateAll(List<Scholar> list);

  Future<ApiResponse> remove(Scholar scholar);

  Future<ApiResponse> getById(String Id);

  Future<ApiResponse> getAll();

  Future<ApiResponse> getNewerThan(DateTime dateTime);

  Future<ApiResponse> getByEmp(Emloyee emloyee);
}
