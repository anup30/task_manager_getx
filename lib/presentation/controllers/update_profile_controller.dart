import 'package:get/get.dart';
import 'package:task_manager_getx/data/models/response_object.dart';
import 'package:task_manager_getx/data/services/network_caller.dart';

import '../../data/utility/urls.dart';

class UpdateProfileController extends GetxController{
  bool _inProgress=false;
  String? _errorMessage;
  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage??'';

  Future<ResponseObject> updateProfile(Map<String,dynamic> inputParams) async{
    _inProgress=true;
    update();
    final response= await NetworkCaller.postRequest(Urls.updateProfile, inputParams); // url
    if(!response.isSuccess){
      _errorMessage = response.errorMessage;
      Get.showSnackbar(
        GetSnackBar(
          message: _errorMessage ?? 'Update Profile has been failed',
          duration: const Duration(seconds: 3),
        ),
      );
    }
    _inProgress=false;
    update();
    return response;
  }
}