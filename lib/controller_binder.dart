import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/controllers/add_new_task_controller.dart';
import 'package:task_manager_getx/presentation/controllers/cancelled_task_controller.dart';
import 'package:task_manager_getx/presentation/controllers/completed_task_controller.dart';
import 'package:task_manager_getx/presentation/controllers/count_task_by_status_controller.dart';
import 'package:task_manager_getx/presentation/controllers/delete_task_controller.dart';
import 'package:task_manager_getx/presentation/controllers/email_verification_controller.dart';
import 'package:task_manager_getx/presentation/controllers/new_task_controller.dart';
import 'package:task_manager_getx/presentation/controllers/pin_verification_controller.dart';
import 'package:task_manager_getx/presentation/controllers/progress_task_controller.dart';
import 'package:task_manager_getx/presentation/controllers/set_password_controller.dart';
import 'package:task_manager_getx/presentation/controllers/sign_in_controller.dart';
import 'package:task_manager_getx/presentation/controllers/sign_up_controller.dart';
import 'package:task_manager_getx/presentation/controllers/update_profile_controller.dart';
import 'package:task_manager_getx/presentation/controllers/update_task_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    //Get.put(()=>SignInController()); // error: after logout, re login  <---
    //Get.put(SignInController()); // ^ ok
    Get.lazyPut(() => SignInController(),fenix: true); // lazy, cos if already signed in, default, fenix: false
    Get.lazyPut(() => SignUpController(),fenix: true);
    Get.lazyPut(() => CountTaskByStatusController(),fenix: true); // try late instead of fenix in find? (30.3.24 support class)
    Get.lazyPut(() => NewTaskController(),fenix: true);
    Get.lazyPut(() => CompletedTaskController(),fenix: true);
    Get.lazyPut(() => ProgressTaskController(),fenix: true);
    Get.lazyPut(() => CancelledTaskController(),fenix: true);
    Get.lazyPut(() => UpdateTaskController(),fenix: true);
    Get.lazyPut(() => DeleteTaskController(),fenix: true);
    Get.lazyPut(() => AddNewTaskController(),fenix: true);
    Get.lazyPut(() => UpdateProfileController(),fenix: true);
    Get.lazyPut(() => EmailVerificationController(),fenix: true);
    Get.lazyPut(() => PinVerificationController(),fenix: true);
    Get.lazyPut(() => SetPasswordController(),fenix: true);
  }
}