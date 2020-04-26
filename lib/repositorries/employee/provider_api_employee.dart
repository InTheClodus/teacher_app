import 'package:teacher_app/base/api_response.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/module/employee.dart';
import 'package:teacher_app/module/user.dart';
import 'package:teacher_app/repositorries/employee/contract_provider_employee.dart';

class EmployeeProviderApi implements EmployeeProvideContract {
  EmployeeProviderApi();

  @override
  Future<ApiResponse> add(Emloyee emloyee) async {
    return getApiResponse<Emloyee>(await emloyee.save());
  }

  @override
  Future<ApiResponse> addAll(List<Emloyee> emps) async {
    final List<Emloyee> responses = List<Emloyee>();
    for (final Emloyee emloyee in emps) {
      final ApiResponse response = await add(emloyee);
      if (!response.success) {
        return response;
      }
      response?.results?.forEach(responses.add);
    }

    return ApiResponse(true, 200, responses, null);
  }

  @override
  Future<ApiResponse> getAll() async {
    return getApiResponse<Emloyee>(await Emloyee().getAll());
  }

  @override
  Future<ApiResponse> getById(String Id) async {
    return getApiResponse<Emloyee>(await Emloyee().getObject(Id));
  }

  @override
  Future<ApiResponse> getByUser() async {
    final ParseUser user = await ParseUser.currentUser();
    final QueryBuilder querye = QueryBuilder(ParseObject("_User"))
      ..whereEqualTo("objectId", user.objectId)
      ..includeObject(["employee"]);
    var rep = await querye.query();
    final QueryBuilder<Emloyee> query = QueryBuilder<Emloyee>(Emloyee())
      ..whereEqualTo("objectId", rep.results.first["employee"]["objectId"])
      ..includeObject(['branch']);

    return (getApiResponse<Emloyee>(await query.query()));
  }

  @override
  Future<ApiResponse> getNewerThan(DateTime dateTime) async {
    final QueryBuilder<Emloyee> query = QueryBuilder<Emloyee>(Emloyee())
      ..whereGreaterThan(keyVarCreatedAt, dateTime);
    return getApiResponse<Emloyee>(await query.query());
  }

  @override
  Future<ApiResponse> remove(Emloyee emloyee) async {
    return getApiResponse<Emloyee>(await emloyee.delete());
  }

  @override
  Future<ApiResponse> update(Emloyee emloyee) async {
    return getApiResponse<Emloyee>(await emloyee.save());
  }

  @override
  Future<ApiResponse> updateAll(List<Emloyee> emps) async {
    final List<Emloyee> responses = List<Emloyee>();
    for (final Emloyee item in emps) {
      final ApiResponse response = await update(item);
      if (!response.success) {
        return response;
      }
      response?.results?.forEach(responses.add);
    }
    return ApiResponse(true, 200, responses, null);
  }
}
