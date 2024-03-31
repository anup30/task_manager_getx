import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/controllers/count_task_by_status_controller.dart';
import 'package:task_manager_getx/presentation/controllers/new_task_controller.dart';
import 'package:task_manager_getx/presentation/screens/add_new_task_screen.dart';
import 'package:task_manager_getx/presentation/utils/app_colors.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_getx/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager_getx/presentation/widgets/task_card.dart';
import 'package:task_manager_getx/presentation/widgets/task_counter_card.dart';


import '../../data/models/task_count_by_status_data.dart';
import '../widgets/empty_list_widget.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  //final CounterController _counterController = Get.put(CounterController());
  //final _countTaskByStatusController = Get.put(CountTaskByStatusController()); ///---
  //final _newTaskController = Get.put(NewTaskController()); ///---

  @override
  void initState() {
    super.initState();
    _getDataFromApis();
    //Get.put(CountTaskByStatusController()); ///--- used fenix: true, in  controller_binder
    //Get.put(NewTaskController()); ///---
    //^ used if onDelete() called previously (for Get.off()/Get.offAll()), and we need to come here again latter.
  }
  void _getDataFromApis() async{
    Get.find<CountTaskByStatusController>().getCountByTaskStatus();
    Get.find<NewTaskController>().getNewTaskList();
  }
  // add edit task status controller
  // add delete task controller
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Column( // add GetBuilder wrapper for edit and delete
          children: [
            GetBuilder<CountTaskByStatusController>( // getx ----
              builder: (countTaskByStatusController){
                return Visibility(
                  visible: countTaskByStatusController.inProgress==false,
                  replacement: const Padding(
                    padding: EdgeInsets.all(8),
                    child: LinearProgressIndicator(),
                  ),
                  child: taskCounterSection(countTaskByStatusController
                      .countByStatusWrapper.listOfTaskByStatusData??[],),
                );
              }
            ),
            Expanded(
              child: GetBuilder<NewTaskController>( // getx ----
                builder: (newTaskController){
                  return Visibility(
                    visible: newTaskController.inProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async => _getDataFromApis(),
                      child: Visibility(
                        visible: newTaskController
                            .newTaskListWrapper.taskList?.isNotEmpty ?? false,
                        replacement: const Center(
                          child: SingleChildScrollView( //solved: Refresh not working for 'No Items'?
                            physics: AlwaysScrollableScrollPhysics(),
                            child: EmptyListWidget(),
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: newTaskController
                              .newTaskListWrapper.taskList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskCard( // vertical scrolling cards --------------------------------- <<
                              taskItem: newTaskController
                                  .newTaskListWrapper.taskList![index],
                              refreshList: () {
                                _getDataFromApis();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(()=> const AddNewTaskScreen());
          if(result !=null && result==true){
            _getDataFromApis();
          }
          //final result = await Navigator.push(context,MaterialPageRoute(builder: (context) => const AddNewTaskScreen(),),);
          /*.then((value) => { // by .then way, without receiving result above
            if(value){
              _getDataFromApis(),
              //setState(() {}),
            }
          });*/
        },
        backgroundColor: AppColors.themeColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  Widget taskCounterSection(List<TaskCountByStatusData> listOfTaskCountByStatus) {
    return SizedBox(
      height: 110,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: listOfTaskCountByStatus.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return TaskCounterCard(
              title: listOfTaskCountByStatus[index].sId ??
                  '',
              amount:
              listOfTaskCountByStatus[index].sum ?? 0,
            );
          },
          separatorBuilder: (c,i) {
            return const SizedBox(
              width: 8,
            );
          },
        ),
      ),
    );
  }
}