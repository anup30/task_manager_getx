import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_getx/presentation/widgets/empty_list_widget.dart';
import 'package:task_manager_getx/presentation/widgets/task_card.dart';
import '../controllers/completed_task_controller.dart';
import '../widgets/profile_app_bar.dart';


class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  //bool _getAllCompletedTaskListInProgress = false;
  //TaskListWrapper _completedTaskListWrapper = TaskListWrapper();

  @override
  void initState() { // async ? ----------------------------------
    super.initState();
    _getDataFromApis();
    //_getAllCompletedTaskList(); // > setState is inside,// old way
  }
  void _getDataFromApis() async{
    Get.find<CompletedTaskController>().getCompletedTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: GetBuilder<CompletedTaskController>( // getx ----
            builder: (completedTaskController){
              return Visibility(
                visible: completedTaskController.inProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: () async => _getDataFromApis(),
                  child: Visibility(
                    visible: completedTaskController
                        .completedTaskListWrapper.taskList?.isNotEmpty ?? false,
                    replacement: const EmptyListWidget(),
                    child: ListView.builder(
                      itemCount: completedTaskController
                          .completedTaskListWrapper.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskItem: completedTaskController
                              .completedTaskListWrapper.taskList![index],
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
    );
  }
  // Future<void> _getAllCompletedTaskList() async {
  //   _getAllCompletedTaskListInProgress = true;
  //   if(!mounted){return;}
  //   setState(() {});
  //   final response = await NetworkCaller.getRequest(Urls.completedTaskList);
  //   if (response.isSuccess) {
  //     _completedTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
  //     _getAllCompletedTaskListInProgress = false;
  //     if(!mounted){return;}
  //     setState(() {});
  //   } else {
  //     _getAllCompletedTaskListInProgress = false;
  //     if(!mounted){return;}
  //     setState(() {});
  //     showSnackBarMessage(
  //         context,
  //         response.errorMessage ??
  //             'Get Completed task list has been failed'
  //     );
  //   }
  // }
}