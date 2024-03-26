import 'package:flutter/material.dart';
import 'package:task_manager_getx/presentation/screens/add_new_task_screen.dart';
import 'package:task_manager_getx/presentation/utils/app_colors.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_getx/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager_getx/presentation/widgets/snack_bar_message.dart';
import 'package:task_manager_getx/presentation/widgets/task_card.dart';
import 'package:task_manager_getx/presentation/widgets/task_counter_card.dart';

import '../../data/models/count_by_status_wrapper.dart';
import '../../data/models/task_list_wrapper.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';
import '../widgets/empty_list_widget.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getAllTaskCountByStatusInProgress = false;
  bool _getNewTaskListInProgress = false;
  //bool _deleteTaskInProgress = false;
  //bool _updateTaskStatusInProgress = false;
  CountByStatusWrapper _countByStatusWrapper = CountByStatusWrapper();
  TaskListWrapper _newTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
    super.initState();
    _getDataFromApis();
  }

  void _getDataFromApis() async{
    _getAllTaskCountByStatus();
    _getAllNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Column(
          children: [
            Visibility(
                visible: _getAllTaskCountByStatusInProgress == false,
                replacement: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                ),
                child: taskCounterSection // horizontal scrolling cards on top.------------------
            ),
            Expanded(
              child: Visibility(
                visible: _getNewTaskListInProgress == false, /*&& //---------------------------- <<
                    _deleteTaskInProgress == false &&
                    _updateTaskStatusInProgress == false,*/
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: () async => _getDataFromApis(),
                  child: Visibility(
                    visible: _newTaskListWrapper.taskList?.isNotEmpty ?? false,
                    replacement: const EmptyListWidget(),
                    child: ListView.builder(
                      itemCount: _newTaskListWrapper.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskCard( // vertical scrolling cards --------------------------------- <<
                          taskItem: _newTaskListWrapper.taskList![index],
                          refreshList: () {
                            _getDataFromApis();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton( //----------------------------------------------------------
        onPressed: () async {
          // to do: Recall the home apis after successfully add new task/tasks (done)
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );/*.then((value) => { // by .then way, without receiving result above
            if(value){
              _getDataFromApis(),
              //setState(() {}),
            }
          });*/
          if(result !=null && result==true){
            _getDataFromApis();
          }
        },
        backgroundColor: AppColors.themeColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  Widget get taskCounterSection {
    return SizedBox(
      height: 110,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: _countByStatusWrapper.listOfTaskByStatusData?.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return TaskCounterCard(
              title: _countByStatusWrapper.listOfTaskByStatusData![index].sId ??
                  '',
              amount:
              _countByStatusWrapper.listOfTaskByStatusData![index].sum ?? 0,
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

  Future<void> _getAllTaskCountByStatus() async {
    _getAllTaskCountByStatusInProgress = true;
    if(!mounted){return;}
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.taskCountByStatus);
    if (response.isSuccess) {
      _countByStatusWrapper =
          CountByStatusWrapper.fromJson(response.responseBody);
      _getAllTaskCountByStatusInProgress = false;
      if(!mounted){return;}
      setState(() {});
    } else {
      _getAllTaskCountByStatusInProgress = false;
      if(!mounted){return;}
      setState(() {});
        showSnackBarMessage(
            context,
            response.errorMessage ??
                'Get task count by status has been failed');
    }
  }
  Future<void> _getAllNewTaskList() async {
    _getNewTaskListInProgress = true;
    if(!mounted){return;}
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.newTaskList);
    if (response.isSuccess) {
      _newTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getNewTaskListInProgress = false;
      if(!mounted){return;}
      setState(() {});
    } else {
      _getNewTaskListInProgress = false;
      if(!mounted){return;}
      setState(() {});
        showSnackBarMessage(
            context,
            response.errorMessage ??
                'Get new task list has been failed');
    }
  }
}