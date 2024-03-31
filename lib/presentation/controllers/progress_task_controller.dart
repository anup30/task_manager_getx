import 'package:get/get.dart';
import 'package:task_manager_getx/data/models/task_list_wrapper.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';

import '../../data/utility/urls.dart';

class ProgressTaskController extends GetxController{
  bool _inProgress=false;
  String? _errorMessage;
  TaskListWrapper _progressTaskListWrapper = TaskListWrapper();
  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage??'';
  TaskListWrapper get progressTaskListWrapper => _progressTaskListWrapper;

  Future<bool> getProgressTaskList() async{
    bool isSuccess =false;
    _inProgress=true;
    update();
    final response= await NetworkCaller.getRequest(Urls.progressTaskList); // url
    if(response.isSuccess){
      _progressTaskListWrapper= TaskListWrapper.fromJson(response.responseBody);
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress=false;
    update();
    return isSuccess;
  }
}