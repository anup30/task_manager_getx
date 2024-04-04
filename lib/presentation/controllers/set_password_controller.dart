//set new password
import 'package:get/get.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';

import '../../data/models/response_object.dart';
import '../../data/utility/urls.dart';


class SetPasswordController extends GetxController{
  bool _isSuccess=false;
  bool _inProgress=false;
  String? _errorMessage;
  bool get inProgress => _inProgress; //getter
  String get errorMessage => _errorMessage??"Couldn't reset password, please try again";

  Future<bool> recoverResetPassword(Map<String,dynamic> inputParams) async{
    _inProgress=true;
    update();
    final ResponseObject response = await NetworkCaller.postRequest(Urls.recoverResetPassword,inputParams);
    if(response.isSuccess){
      if(response.responseBody["status"]=="success"){
        _isSuccess=true;
      }
    }else{
      _errorMessage= response.errorMessage;
      Get.showSnackbar(
        GetSnackBar(
          message: _errorMessage ?? "Couldn't reset password, please try again!",
          duration: const Duration(seconds: 3),
        ),
      );
    }
    _inProgress=false;
    update();
    return _isSuccess;
  }
}