import 'package:get/get.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';

import '../../data/models/login_response.dart';
import '../../data/models/response_object.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class SignInController extends GetxController{
  bool _isSuccess=false;
  bool _inProgress=false;
  String? _errorMessage;
  bool get inProgress => _inProgress; //getter
  String get errorMessage => _errorMessage??'Login failed, try again';
  Future<bool> signIn(String email, String password)async{
    _inProgress=true;
    update();
    Map<String, dynamic> inputParams ={
      "email":email,
      "password":password,
    };
    final ResponseObject response = (await NetworkCaller.postRequest(Urls.login, inputParams, fromSignIn: true));
    if(response.isSuccess){
      LoginResponse loginResponse = LoginResponse.fromJson(response.responseBody);
      /// save the data to local cache
      await AuthController.saveUserData(loginResponse.userData!);
      await AuthController.saveUserToken(loginResponse.token!);
      _isSuccess=true;
    }else{
      _errorMessage= response.errorMessage;
    }
    _inProgress=false;
    update();
    return _isSuccess;
  }
}