import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/controllers/completed_task_controller.dart';
import 'package:task_manager_getx/presentation/controllers/count_task_by_status_controller.dart';
import 'package:task_manager_getx/presentation/controllers/new_task_controller.dart';
import 'package:task_manager_getx/presentation/controllers/sign_in_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    //Get.put(()=>SignInController()); // error <------
    Get.lazyPut(() => SignInController(),fenix: true); // lazy, cos if already signed in, default, fenix: false
    Get.lazyPut(() => CountTaskByStatusController(),fenix: true); // try late instead of fenix in find? (30.3.24 support class)
    Get.lazyPut(() => NewTaskController(),fenix: true);
    Get.lazyPut(() => CompletedTaskController(),fenix: true);
  }
}