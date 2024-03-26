import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/controller_binder.dart';
import 'package:task_manager_getx/presentation/screens/splash_screen.dart';
import 'package:task_manager_getx/presentation/screens/update_profile_screen.dart';
import 'package:task_manager_getx/presentation/utils/app_colors.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); //------------------------------

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // was MaterialApp
      navigatorKey: TaskManager.navigatorKey, //----------------------------------
      //navigatorObservers: [],
      title: "Task Manager",
      //home: const SplashScreen(),
      initialRoute: '/',
      routes: {  // ---------------> hash routing
        '/':(context)=> const SplashScreen(),
        //'/signIn':(context)=> SignInScreen(),
        '/updateProfileScreen':(context)=> const UpdateProfileScreen(),
      },
      theme: _themeData,
      initialBinding: ControllerBinder(),
    );
  }
  final ThemeData _themeData = ThemeData(
    fontFamily: 'Roboto',
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.blue[50], //--- change to white
      filled: true,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //fixedSize:
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.themeColor,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      //titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,),
    ),
    chipTheme: ChipThemeData(
      //shape: CircleBorder(), //---------------------------------------------
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
      backgroundColor: Colors.cyan,
      side: BorderSide.none,
    ),
  );
}