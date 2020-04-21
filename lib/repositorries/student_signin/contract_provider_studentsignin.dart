import 'package:teacher_app/base/api_response.dart';
import 'package:teacher_app/module/student_signin.dart';

abstract class StudentSignInProvideContract {
  Future<ApiResponse> add(StudentSignIn signIn); //添加一條數據

  Future<ApiResponse> addAll(List<StudentSignIn> stuInList); //添加所有數據

  Future<ApiResponse> update(StudentSignIn signIn); //修改一條數據

  Future<ApiResponse> updateAll(List<StudentSignIn> list); //修改所有數據

  Future<ApiResponse> remove(StudentSignIn signIn); //刪除一條數據

  Future<ApiResponse> getById(String Id); //通過Id查詢

  Future<ApiResponse> getAll(); //查詢全部

  Future<ApiResponse> getByUser(); //通過登錄用戶查詢
}
