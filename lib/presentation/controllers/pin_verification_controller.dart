import 'package:get/get.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';

import '../../data/models/response_object.dart';
import '../../data/utility/urls.dart';


class PinVerificationController extends GetxController{
  bool _isSuccess=false;
  bool _inProgress=false;
  String? _errorMessage;
  bool get inProgress => _inProgress; //getter
  String get errorMessage => _errorMessage??'Pin Verification failed, try again';

  Future<bool> pinVerification(String email, String pin) async{
    _inProgress=true;
    update();
    final ResponseObject response = await NetworkCaller.getRequest(Urls.recoverVerifyOTP(email,pin));
    if(response.isSuccess){
      if(response.responseBody["status"]=="success"){
        _isSuccess=true;
      }
    }else{
      _errorMessage= response.errorMessage;
      Get.showSnackbar(
        GetSnackBar(
          message: _errorMessage ?? "Couldn't verify OTP, please try again!",
          duration: const Duration(seconds: 3),
        ),
      );
    }
    _inProgress=false;
    update();
    return _isSuccess;
  }
}