import 'package:flutter/material.dart';
import 'package:task_manager_getx/presentation/controllers/auth_controller.dart';
import 'package:task_manager_getx/presentation/screens/auth/email_verification_screen.dart';
import 'package:task_manager_getx/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_getx/presentation/screens/auth/sign_up_screen.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_getx/presentation/widgets/snack_bar_message.dart';

import '../../../data/models/login_response.dart';
import '../../../data/models/response_object.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utility/urls.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSignInInProgress = false; //_isLogInInProgress
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView( // used because vertically overflows for onscreen keyboard
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100,),
                  Text("Get Started With",
                    style: Theme.of(context).textTheme.titleLarge, //Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16,), // --------------
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    //to do: can we reuse the validator?
                    validator: (String? val) { //-------------------------------------
                      if (val?.trim().isEmpty ?? true) {
                        return 'Enter your e-mail';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    //keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (String? val) { //---------------------------------
                      if (val?.trim().isEmpty ?? true) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                        child: Visibility(
                          visible: _isSignInInProgress==false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                _signIn();
                              }
                          },
                              child: const Icon(Icons.arrow_forward_ios_rounded), // arrow_forward_ios_rounded, arrow_circle_right_outlined
                          ),
                        ),
                      ),
                  const SizedBox(height: 60,),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmailVerificationScreen()));
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?",style: TextStyle(
                          fontSize: 16,
                        color: Colors.black54,
                      ),),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text('Sign Up'),
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

  Future<void> _signIn() async{
    _isSignInInProgress=true;
    setState(() {});
    Map<String, dynamic> inputParams ={
      "email":_emailTEController.text.trim(),
      "password":_passwordTEController.text
    };
    final ResponseObject response = (await NetworkCaller.postRequest(Urls.login, inputParams, fromSignIn: true));
    _isSignInInProgress=false;
    setState(() {});
    if(response.isSuccess){
      if(!mounted){
        return;
      }
      LoginResponse loginResponse = LoginResponse.fromJson(response.responseBody);
      //print(loginResponse.userData?.firstName); //-------------------------------------------- <
      /// save the data to local cache
      await AuthController.saveUserData(loginResponse.userData!);
      await AuthController.saveUserToken(loginResponse.token!);
      if(mounted){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainBottomNavScreen()),
              (route) => false,
        );
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Login failed, please try again!');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _formKey.currentState?.dispose();
    // also close streams if they were present ! -------------------------------
  }
}
