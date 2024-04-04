import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/controllers/pin_verification_controller.dart';
import 'package:task_manager_getx/presentation/screens/auth/set_password_screen.dart';
import 'package:task_manager_getx/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class PinVerificationScreen extends StatefulWidget { // comes here, from "EmailVerificationScreen"
  final String email;
  const PinVerificationScreen({super.key, required this.email});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> { // otp pin verification
  final TextEditingController _pinTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final PinVerificationController _pinVerificationController = Get.find<PinVerificationController>();
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
                  Text("Pin Verification",
                    style: Theme.of(context).textTheme.titleLarge, //Theme.of(context).textTheme.headlineLarge,
                  ),
                  const Text(
                    "enter the 6 digit verification code which were sent to your email address",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  /*const SizedBox(height: 24,),
                  TextFormField(
                    controller: _pinTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: '6 digit pin',
                    ),
                  ),*/
                  const SizedBox(height: 16),
                  PinCodeTextField( // ---> pin_code_fields package
                    //autoDisposeControllers = true, //default. so won't have to dispose the controller manually.
                    controller: _pinTEController,
                    //autoDisposeControllers: false, //test it ------------------
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,//AppColors.themeColor,
                      //selectedFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    onCompleted: (v) {
                      //print("Completed");
                    },
                    onChanged: (value) {

                    },
                    appContext: context, // -----
                    validator: (String? val) { //----
                      if (val?.trim().isEmpty ?? true) {
                        return 'Enter 6 digit pin';
                      }else if(val?.trim().length != 6){
                        return 'enter all 6 digits of pin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                      child: GetBuilder<PinVerificationController>(
                          builder: (pinVerificationController){
                            return Visibility( //-----------------------------------------------------------------
                              visible: pinVerificationController.inProgress ==false,
                              replacement: const Center(child: CircularProgressIndicator(),),
                              child: ElevatedButton(
                                onPressed: (){
                                  //to do: go to SetPasswordScreen if 6 digit pin is correct.
                                  if(_formKey.currentState!.validate()){
                                    _pinVerification();
                                  }
                                },
                                child: const Text('Verify'), // go to set password page
                              ),
                            );
                          }),
                    // child: Visibility( //---------
                    //   visible: _pinVerificationInProgress ==false,
                    //   replacement: const Center(child: CircularProgressIndicator(),),
                    //   child: ElevatedButton(
                    //     onPressed: (){
                    //       //to do: go to SetPasswordScreen if 6 digit pin is correct.
                    //       if(_formKey.currentState!.validate()){
                    //         _pinVerification();
                    //       }
                    //     },
                    //     child: const Text('Verify'), // go to set password page
                    //   ),
                    // ),
                  ),
                  const SizedBox(height: 32,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("have an account?",style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),),
                      TextButton(
                        onPressed: () {
                          // Navigator.pushAndRemoveUntil( //--------------------------------------------------/// .pushReplacement ?
                          //     context,
                          //     MaterialPageRoute(builder: (context)=>const SignInScreen()),
                          //     (route) => false
                          // );
                          Get.offAll(()=> const SignInScreen());
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

  Future<void> _pinVerification() async{
    final bool response = await _pinVerificationController.pinVerification(widget.email, _pinTEController.text);
    if(response){
      if(mounted){
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context)=> SetPasswordScreen (email:widget.email, otp:_pinTEController.text), //SetPasswordScreen
        // ));
        Get.to(()=> SetPasswordScreen(email:widget.email, otp:_pinTEController.text));
      }
    }
    // _pinVerificationInProgress =true;
    // setState(() {});
    // final ResponseObject response = await NetworkCaller.getRequest(Urls.recoverVerifyOTP(widget.email,_pinTEController.text));
    // _pinVerificationInProgress =false;
    // setState(() {});
    // if(response.isSuccess){ // response.isSuccess==true, when response.statusCode==200
    //   if(response.responseBody["status"]=="success"){
    //     if(mounted){
    //       // Navigator.push(
    //       //   context,
    //       //   MaterialPageRoute(
    //       //       builder: (context)=> SetPasswordScreen (email:widget.email, otp:_pinTEController.text), //SetPasswordScreen
    //       // ));
    //       Get.to(()=> SetPasswordScreen(email:widget.email, otp:_pinTEController.text));
    //     }
    //   }
    //   else{
    //     if(mounted){
    //       setState(() {});
    //       showSnackBarMessage(context, response.errorMessage ?? "Couldn't verify OTP, please try again!");
    //     }
    //   }
    // }else{
    //   if(mounted){
    //     showSnackBarMessage(context, response.errorMessage ?? 'OTP verification failed, please try again!');
    //   }
    // }

  }

  @override
  void dispose() {
    //_pinTEController.dispose(); /// auto dispose for pin_code_fields package
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
