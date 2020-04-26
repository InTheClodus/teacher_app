import 'package:teacher_app/base/api_response.dart';
import 'package:teacher_app/module/employee.dart';
import 'package:teacher_app/module/user.dart';

abstract class EmployeeProvideContract {
  Future<ApiResponse> add(Emloyee emloyee); //添加一條員工數據

  Future<ApiResponse> addAll(List<Emloyee> emps); //添加所有員工數據

  Future<ApiResponse> update(Emloyee emloyee); //修改一條數據

  Future<ApiResponse> updateAll(List<Emloyee> emps); //修改所有數據

  Future<ApiResponse> remove(Emloyee emloyee); //刪除一條數據

  Future<ApiResponse> getById(String Id); //通過Id查詢

  Future<ApiResponse> getAll(); //查詢全部

  Future<ApiResponse> getNewerThan(DateTime dateTime);

  Future<ApiResponse> getByUser(); //通過登錄用戶查詢當前的員工信息
}
