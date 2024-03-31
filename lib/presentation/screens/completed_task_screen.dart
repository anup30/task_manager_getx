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

  @override
  void initState() { // async ? -----------
    super.initState();
    _getDataFromApis();
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
                    replacement: const Center(
                      child: SingleChildScrollView( //solved: Refresh not working for 'No Items'?
                        physics: AlwaysScrollableScrollPhysics(),
                        child: EmptyListWidget(),
                      ),
                    ),
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
}