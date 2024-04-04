// when forgot password, comes to this page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/controllers/email_verification_controller.dart';
import 'package:task_manager_getx/presentation/screens/auth/pin_verification_screen.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';

class EmailVerificationScreen extends StatefulWidget { // comes here, from "Forgot password?"
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final EmailVerificationController _emailVerificationController = Get.find<EmailVerificationController>();
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
                    child: GetBuilder<EmailVerificationController>(
                      builder: (emailVerificationController){
                        return Visibility(
                          visible: emailVerificationController.inProgress ==false,
                          replacement: const Center(child: CircularProgressIndicator()),
                          child: ElevatedButton(
                            onPressed: () {
                              /// to do: go to PinVerificationScreen if ...
                              if(_formKey.currentState!.validate()){
                                _verifyEmail();
                              }
                            },
                            child: const Icon(Icons.arrow_forward_ios_rounded), // arrow_forward_ios_rounded, arrow_circle_right_outlined
                          ),
                        );
                      },
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

  Future<void> _verifyEmail() async{
    final bool response = await _emailVerificationController.verifyEmail(_emailTEController.text.trim());
    if(response){
      if(mounted){
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context)=> PinVerificationScreen(email:email)),
        // );
        Get.to(()=> PinVerificationScreen(email:_emailTEController.text.trim()));
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
