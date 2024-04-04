// reset password if forgotten
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/controllers/set_password_controller.dart';
import 'package:task_manager_getx/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import '../../widgets/snack_bar_message.dart';

class SetPasswordScreen extends StatefulWidget { // comes here, from pin verification screen
  final String email;
  final String otp;
  const SetPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SetPasswordController _setPasswordController = Get.find<SetPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100,),
                  Text("Set new password", // proceed to Reset password ?
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge, //Theme.of(context).textTheme.headlineLarge,
                  ),
                  const Text(
                    "minimum 8 characters with letter and number combination",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24,), // --------------
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (String? val) {
                      if (val?.isEmpty ?? true) {
                        return 'Enter min 8 characters for new password';
                      } else if (val!.length < 8) {
                        return 'Enter min 8 characters for new password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'confirm Password',
                    ),
                    validator: (String? val) {
                      if (val?.isEmpty ?? true) {
                        return 'Enter min 8 characters for new password';
                      } else if (val!.length < 8) {
                        return 'Enter min 8 characters for new password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<SetPasswordController>(
                        builder: (setPasswordController) {
                          return Visibility( //--------------------------------------------
                            visible: setPasswordController.inProgress == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_passwordTEController.text ==
                                      _confirmPasswordTEController.text) {
                                    _recoverResetPassword();
                                  } else {
                                    //if(mounted){
                                    //setState(() {});
                                    showSnackBarMessage(context,
                                        "Passwords didn't match, please try again!");
                                    //}
                                  }
                                }
                              },
                              child: const Text('Confirm'),
                            ),
                          );
                        }
                    ),
                    // child: Visibility( //--------------------------------------------
                    //   visible: _recoverResetPasswordInProgress==false,
                    //   replacement: const Center(child: CircularProgressIndicator(),),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       if(_formKey.currentState!.validate()){
                    //         if(_passwordTEController.text == _confirmPasswordTEController.text){
                    //           _recoverResetPassword();
                    //         }else{
                    //           if(mounted){
                    //             setState(() {});
                    //             showSnackBarMessage(context, "Passwords didn't match, please try again!");
                    //           }
                    //         }
                    //       }
                    //     },
                    //     child: const Text('Confirm'),
                    //   ),
                    // ),
                  ),
                  const SizedBox(height: 32,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("have an account?", style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),),
                      TextButton(
                        onPressed: () {
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(builder: (context)=>const SignInScreen()),
                          //     (route) => false
                          // );
                          Get.offAll(() => const SignInScreen());
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    _formKey.currentState?.dispose();
  }

  Future<void> _recoverResetPassword() async {
    //_recoverResetPasswordInProgress = true;
    setState(() {});
    Map<String, dynamic> inputParams = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _passwordTEController.text,
    };
    final bool response = await _setPasswordController.recoverResetPassword(
        inputParams);
    if (response) {
      if (mounted) {
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const SignInScreen(),
              //   ),
              //   (route) => false,
              // );
              Get.offAll(()=> const SignInScreen());
            }
      }
      // final ResponseObject response = await NetworkCaller.postRequest(Urls.recoverResetPassword,inputParams);
      // _recoverResetPasswordInProgress=false;
      // if(response.isSuccess){ // response.isSuccess==true, when response.statusCode==200
      //   if(response.responseBody["status"]=="success"){
      //     if (mounted) {
      //       // Navigator.pushAndRemoveUntil(
      //       //   context,
      //       //   MaterialPageRoute(
      //       //     builder: (context) => const SignInScreen(),
      //       //   ),
      //       //   (route) => false,
      //       // );
      //       Get.offAll(()=> const SignInScreen());
      //     }
      //   }else{
      //     if(mounted){
      //       setState(() {});
      //       showSnackBarMessage(context, response.errorMessage ?? "Couldn't Reset Password, please try again!");
      //     }
      //   }
      // }else{
      //   if(mounted){
      //     setState(() {});
      //     showSnackBarMessage(context, response.errorMessage ?? 'Password Reset failed, please try again!');
      //   }
      // }
    }
  }
//}