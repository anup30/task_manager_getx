import 'package:get/get.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';
import '../../data/utility/urls.dart';


class UpdateTaskController extends GetxController{
  bool _isSuccess=false;
  bool _inProgress=false;
  String? _errorMessage;
  bool get inProgress => _inProgress; //getter
  String get errorMessage => _errorMessage??'Update Task failed, please try again';
  Future<bool> updateTaskById(String id, String status)async{
    _inProgress=true;
    update();
    final response = await NetworkCaller.getRequest(Urls.updateTaskStatus(id, status));
    if(response.isSuccess){
      _isSuccess=true;

    }else{
      _errorMessage= response.errorMessage;
      //showSnackBarMessage(context,_errorMessage ?? 'Update task status has been failed');}
      Get.showSnackbar(
         GetSnackBar(
          message: _errorMessage ?? 'Update task status has been failed',
          duration: const Duration(seconds: 3),
        ),
      );
    }
    _inProgress=false;
    update();
    return _isSuccess;
  }
}