import 'package:get/get.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';
import '../../data/utility/urls.dart';


class DeleteTaskController extends GetxController{
  bool _isSuccess=false;
  bool _inProgress=false;
  String? _errorMessage;
  bool get inProgress => _inProgress; //getter
  String get errorMessage => _errorMessage??'Update Task failed, please try again';
  Future<bool> deleteTaskById(String id)async{
    _inProgress=true;
    update();
    final response = await NetworkCaller.getRequest(Urls.deleteTask(id));
    if(response.isSuccess){
      _isSuccess=true;
    }else{
      _errorMessage= response.errorMessage;
      Get.showSnackbar(
        GetSnackBar(
          message: _errorMessage ?? 'Delete task has been failed',
          duration: const Duration(seconds: 3),
        ),
      );
    }
    _inProgress=false;
    update();
    return _isSuccess;
  }
}