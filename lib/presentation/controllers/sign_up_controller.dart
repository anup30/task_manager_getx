import 'package:get/get.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';

import '../../data/models/response_object.dart';
import '../../data/utility/urls.dart';


class SignUpController extends GetxController{
  bool _isSuccess=false;
  bool _inProgress=false;
  String? _errorMessage;
  bool get inProgress => _inProgress; //getter
  String get errorMessage => _errorMessage??'SignUp failed, please try again';
  Future<bool> signUp(String email,String firstName, String lastName, String mobile ,String password)async{
    _inProgress=true;
    update();
    Map<String, dynamic> inputParams ={
      "email":email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password":password,
      //"photo":""
    };
    final ResponseObject response = (await NetworkCaller.postRequest(Urls.registration, inputParams,));
    if(response.isSuccess){
      _isSuccess=true;
    }else{
      _errorMessage= response.errorMessage;
    }
    _inProgress=false;
    update();
    return _isSuccess;
  }
}