
import 'package:teacher_app/base/api_response.dart';
import 'package:teacher_app/module/student.dart';

abstract class StudentProviderContract{
  Future<ApiResponse> add(Student student);

  Future<ApiResponse> addAll(List<Student> list);

  Future<ApiResponse> update(Student item);

  Future<ApiResponse> updateAll(List<Student> list);

  Future<ApiResponse> remove(Student student);

  Future<ApiResponse> getById(String id);
// 获取
  Future<ApiResponse> getAll();

  Future<ApiResponse>getByUser();

}