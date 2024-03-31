// when forgot password, comes to this page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/screens/auth/pin_verification_screen.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';

import '../../../data/models/response_object.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utility/urls.dart';
import '../../widgets/snack_bar_message.dart';
// api: RecoverVerifyEmail
class EmailVerificationScreen extends StatefulWidget { // comes here, from "Forgot password?"
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _verifyEmailInProgress = false;
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
                  Text("Your Email Address",
                    style: Theme.of(context).textTheme.titleLarge, //see also Theme.of(context).textTheme.headlineLarge,
                  ),
                  const Text(
                      "Enter your email.\nA 6 digit verification code will be sent to your email address",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24,), // --------------
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? val) { //-------------------------------------
                      if (val?.trim().isEmpty ?? true) {
                        return 'Enter your e-mail';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _verifyEmailInProgress ==false,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          /// to do: go to PinVerificationScreen if ...
                          if(_formKey.currentState!.validate()){
                            _verifyEmail(_emailTEController.text.trim(),);
                          }
                        },
                        child: const Icon(Icons.arrow_forward_ios_rounded), // arrow_forward_ios_rounded, arrow_circle_right_outlined
                      ),
                    ),
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
                          Navigator.pop(context);
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

  Future<void> _verifyEmail(String email) async{
    _verifyEmailInProgress =true;
    setState(() {});
    final ResponseObject response = await NetworkCaller.getRequest(Urls.recoverVerifyEmail(email));
    _verifyEmailInProgress =false;
    setState(() {});
    if(response.isSuccess){ // response.isSuccess==true, when response.statusCode==200
      if(response.responseBody["status"]=="success"){
        if(mounted){
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context)=> PinVerificationScreen(email:email)),
          // );
          Get.to(()=> PinVerificationScreen(email:email));
        }
      }else{
        if(mounted){
          setState(() {});
          showSnackBarMessage(context, response.errorMessage ?? "Couldn't verify email, please try again!");
        }
      }
    }else{
      if(mounted){
        setState(() {});
        showSnackBarMessage(context, response.errorMessage ?? 'Email verification failed, please try again!');
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
