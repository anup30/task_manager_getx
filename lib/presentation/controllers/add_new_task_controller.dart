import 'package:get/get.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';

import '../../data/utility/urls.dart';

class AddNewTaskController extends GetxController{
  bool _inProgress=false;
  String? _errorMessage;
  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage??'';

  Future<bool> addNewTask(Map<String,dynamic> inputParams) async{
    bool isSuccess =false;
    _inProgress=true;
    update();
    final response= await NetworkCaller.postRequest(Urls.createTask, inputParams); // url
    if(response.isSuccess){
      isSuccess =true;
    }else{
      _errorMessage = response.errorMessage;
      Get.showSnackbar(
        GetSnackBar(
          message: _errorMessage ?? 'Add task has been failed',
          duration: const Duration(seconds: 3),
        ),
      );
    }
    _inProgress=false;
    update();
    return isSuccess;
  }
}