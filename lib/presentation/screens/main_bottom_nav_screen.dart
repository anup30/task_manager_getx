import 'package:flutter/material.dart';
import 'package:task_manager_getx/presentation/screens/new_task_screen.dart';
import 'package:task_manager_getx/presentation/screens/progress_task_screen.dart';
import 'package:task_manager_getx/presentation/utils/app_colors.dart';

import 'cancelled_task_screen.dart';
import 'completed_task_screen.dart';
//import 'package:get/get.dart' as getx;

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _currentIndex=0;
  final List<Widget> _screens =[
    const NewTaskScreen(),
    const CompletedTaskScreen(),
    const ProgressTaskScreen(),
    const CancelledTaskScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex : _currentIndex,
        selectedItemColor: AppColors.themeColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels:true,
        //backgroundColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (index){
          _currentIndex=index;
          if(mounted){ // -----> not needed?
            setState(() {});
            //getx.update(); --------------------------------------------------?
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_outlined),
              label: 'New Task',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.done),
              label: 'Completed',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time_outlined),
              label: 'Progress'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel_outlined),
              label: 'Cancelled'
          ),
        ],
      ),
    );
  }
}
