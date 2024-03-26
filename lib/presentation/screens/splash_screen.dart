import 'package:flutter/material.dart';
import 'package:task_manager_getx/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager_getx/presentation/screens/main_bottom_nav_screen.dart';

import '../controllers/auth_controller.dart';
import '../widgets/app_logo.dart';
import '../widgets/background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async{
    await Future.delayed(const Duration(seconds: 2));
    bool isLoggedIn = await AuthController.isUserLoggedIn();
    if (mounted) { //context.mounted
      if(isLoggedIn){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainBottomNavScreen(),
          ),
        );
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BackgroundWidget(
          child: Center(
            child: AppLogo(),
          ),
      )
    );
  }
}


