// for top row in new task screen
import 'package:get/get.dart';
import 'package:task_manager_getx/data/models/count_by_status_wrapper.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';

import '../../data/utility/urls.dart';

class CountTaskByStatusController extends GetxController{
  bool isSuccess=false;
  bool _inProgress=false;
  String? _errorMessage;
  CountByStatusWrapper _countByStatusWrapper =CountByStatusWrapper();
  bool get inProgress => _inProgress;
  String get errorMessage =>
      _errorMessage??'fetch count by task status failed';
  CountByStatusWrapper get countByStatusWrapper => _countByStatusWrapper;
  Future<bool> getCountByTaskStatus() async{
    _inProgress=true;
    update();
    final response= await NetworkCaller.getRequest(Urls.taskCountByStatus);
    if(response.isSuccess){
      _countByStatusWrapper=CountByStatusWrapper.fromJson(response.responseBody);
      isSuccess= true;
    }else{
      _errorMessage =response.errorMessage;
    }
    _inProgress=false;
    update();
    return isSuccess;
  }
}