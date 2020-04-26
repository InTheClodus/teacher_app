import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:teacher_app/base/api_response.dart';
import 'package:teacher_app/module/employee.dart';

import 'package:teacher_app/module/student_signin.dart';

import '../employee/reoisitory_employee.dart';
import 'contract_provider_studentsignin.dart';

class StudentSignInProviderApi implements StudentSignInProvideContract {
  StudentSignInProviderApi();

  EmployeeRepository employeeRepository;

  @override
  Future<ApiResponse> add(StudentSignIn signIn) async {
    return getApiResponse<StudentSignIn>(await signIn.save());
  }

  @override
  Future<ApiResponse> addAll(List<StudentSignIn> stuInList) async {
    final List<StudentSignIn> listStuIn = List<StudentSignIn>();
    for (final StudentSignIn stuIn in stuInList) {
      final ApiResponse response = await add(stuIn);
      if (!response.success) {
        return response;
      }
      response?.results?.forEach(listStuIn.add);
    }
    return ApiResponse(true, 200, listStuIn, null);
  }

  @override
  Future<ApiResponse> getAll() {
    return null;
  }

  @override
  Future<ApiResponse> getById(String Id) {
    return null;
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

    return null;
  }

  @override
  Future<ApiResponse> remove(StudentSignIn signIn) {
    return null;
  }

  @override
  Future<ApiResponse> update(StudentSignIn signIn) {
    return null;
  }

  @override
  Future<ApiResponse> updateAll(List<StudentSignIn> list) {
    return null;
  }
}
