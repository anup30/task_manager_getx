import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager_getx/presentation/screens/update_profile_screen.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart';

PreferredSizeWidget get profileAppBar{ // top level function, not a class //--- or as profileAppBar(context)
//PreferredSizeWidget profileAppBar(BuildContext context){ // no get, get can't receive arguments
  MemoryImage? imageForCircleAvatar(){
    try{
      // print("in try block, -----------------------------------------------------------------");
      // print("AuthController.userData?.photo= ${AuthController.userData?.photo}"); // null
      // print("\n\n\n");
      return MemoryImage(base64Decode(AuthController.userData!.photo!));
    }catch(e){
      // print("in catch block, -----------------------------------------------------------------");
      // print("$e");
      return null;
    }
  }
  return AppBar(
    automaticallyImplyLeading: false, //
    backgroundColor: AppColors.themeColor,
    title: GestureDetector(
      onTap: () {
        if(UpdateProfileScreen.isThisPageOnNavigatorTop==false){
          Get.to(()=> const UpdateProfileScreen());
        }
        /*//also worked!
        const newRouteName = '/updateProfileScreen';
        bool isNewRouteSameAsCurrent = false;
        Navigator.popUntil(TaskManager.navigatorKey.currentState!.context, (route) {
          if (route.settings.name == newRouteName) {
            isNewRouteSameAsCurrent = true;
          }
          return true; //pops none
        });
        if(!isNewRouteSameAsCurrent){
          //Navigator.pushNamed(TaskManager.navigatorKey.currentState!.context, newRouteName);
          Get.toNamed(newRouteName);
          */

        /*//also worked!
        const newRouteName = '/updateProfileScreen';
        if("${ModalRoute.of(context)?.settings.name}"!=newRouteName){
          print("${ModalRoute.of(context)?.settings.name}");
          print(newRouteName);
          Navigator.pushNamed(context, newRouteName);
        }else{
          print("Success");
        }
        */

        /*// didn't work
        const newRouteName = '/updateProfileScreen';
        if("${ModalRoute.of(TaskManager.navigatorKey.currentState!.context)?.settings.name}"!=newRouteName){
          print("${ModalRoute.of(TaskManager.navigatorKey.currentState!.context)?.settings.name}"); //: null
          print(newRouteName); //: /updateProfileScreen
          Navigator.pushNamed(TaskManager.navigatorKey.currentState!.context, newRouteName);
        }else{
          print('yahoo!');
        }
         */
      },
      child: Row(children: [
        CircleAvatar(
          backgroundImage: imageForCircleAvatar(), // set null if no image is set (initial login)
        ),
        const SizedBox(width: 12,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AuthController.userData?.fullName ??'',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                AuthController.userData?.email ?? '',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () async{
            /*
              await AuthController.clearUserData();
              if(TaskManager.navigatorKey.currentState!.context.mounted){ //if(mounted) --- problem
                Navigator.pushAndRemoveUntil(
                  //TaskManager.navigatorKey.currentContext!,
                    TaskManager.navigatorKey.currentState!.context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                        (route) => false);
              }
            */
            await AuthController.clearUserData().then((result){
              // Navigator.pushAndRemoveUntil(
              //   //TaskManager.navigatorKey.currentContext!,
              //     TaskManager.navigatorKey.currentState!.context,
              //     MaterialPageRoute(builder: (context) => const SignInScreen()),
              //         (route) => false,
              // );
              Get.offAll(()=> const SignInScreen());
            });

          },
          icon: const Icon(Icons.logout),),
      ],),
    ),
  );
}