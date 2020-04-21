
import 'package:teacher_app/base/api_response.dart';

import 'package:teacher_app/module/student.dart';

import '../reoisitory_employee.dart';
import 'contract_provider_student.dart';

class StudentProviderApi implements StudentProviderContract{
  StudentProviderApi();
  EmployeeRepository employeeRepository;
  @override
  Future<ApiResponse> add(Student student) {

    return null;
  }

  @override
  Future<ApiResponse> addAll(List<Student> list) {

    return null;
  }

  @override
  Future<ApiResponse> getAll() {

    return null;
  }

  @override
  Future<ApiResponse> getById(String id) {

    return null;
  }

  @override
  Future<ApiResponse> getByUser() async {
    final ApiResponse response=await employeeRepository.getByUser();

    return null;
  }

  @override
  Future<ApiResponse> remove(Student student) {

    return null;
  }

  @override
  Future<ApiResponse> update(Student item) {

    return null;
  }

  @override
  Future<ApiResponse> updateAll(List<Student> list) {

    return null;
  }

}