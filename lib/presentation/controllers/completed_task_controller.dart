// trying...
import 'package:get/get.dart';
import 'package:task_manager_getx/data/models/task_list_wrapper.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';

import '../../data/utility/urls.dart';

class CompletedTaskController extends GetxController{
  bool _inProgress=false;
  String? _errorMessage;
  TaskListWrapper _completedTaskListWrapper = TaskListWrapper();
  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage??'';
  TaskListWrapper get completedTaskListWrapper => _completedTaskListWrapper;

  Future<bool> getCompletedTaskList() async{
    bool isSuccess =false;
    _inProgress=true;
    update();
    final response= await NetworkCaller.getRequest(Urls.completedTaskList); //---
    if(response.isSuccess){
      _completedTaskListWrapper= TaskListWrapper.fromJson(response.responseBody);
    }else{
      _errorMessage = response.errorMessage;
    }
    _inProgress=false;
    update();
    return isSuccess;
  }
}