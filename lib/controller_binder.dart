import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/controllers/count_task_by_status_controller.dart';
import 'package:task_manager_getx/presentation/controllers/new_task_controller.dart';
import 'package:task_manager_getx/presentation/controllers/sign_in_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    //Get.put(()=>SignInController()); // error <----------------------------
    Get.lazyPut(() => SignInController()); // lazy, cos if already signed in
    Get.lazyPut(() => CountTaskByStatusController());
    Get.lazyPut(() => NewTaskController());
  }
}