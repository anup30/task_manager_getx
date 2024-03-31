import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import '../controllers/progress_task_controller.dart';
import '../widgets/empty_list_widget.dart';
import '../widgets/profile_app_bar.dart';

import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  @override
  void initState() {
    super.initState();
    _getDataFromApis();
  }
  void _getDataFromApis() async{
    Get.find<ProgressTaskController>().getProgressTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: GetBuilder<ProgressTaskController>( // getx ----
            builder: (progressTaskController){
              return Visibility(
                visible: progressTaskController.inProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: () async => _getDataFromApis(),
                  child: Visibility(
                    visible: progressTaskController
                        .progressTaskListWrapper.taskList?.isNotEmpty ?? false,
                    replacement: const Center(
                      child: SingleChildScrollView( //solved: Refresh not working for 'No Items'?
                        physics: AlwaysScrollableScrollPhysics(),
                        child: EmptyListWidget(),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: progressTaskController
                          .progressTaskListWrapper.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskItem: progressTaskController
                              .progressTaskListWrapper.taskList![index],
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