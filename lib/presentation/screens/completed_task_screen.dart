import 'package:flutter/material.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_getx/presentation/widgets/empty_list_widget.dart';
import 'package:task_manager_getx/presentation/widgets/task_card.dart';
import '../../data/models/task_list_wrapper.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/snack_bar_message.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getAllCompletedTaskListInProgress = false;
  TaskListWrapper _completedTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
    super.initState();
    _getAllCompletedTaskList(); // > setState is inside
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Visibility(
          visible: _getAllCompletedTaskListInProgress == false,
          replacement: const Center(child: CircularProgressIndicator()),
          child: RefreshIndicator(
            onRefresh: ()async{
              _getAllCompletedTaskList();
            },
            child: Visibility(
              visible: _completedTaskListWrapper.taskList?.isNotEmpty ?? false,
              replacement: const Center(
                child: SingleChildScrollView( //solved: Refresh not working for 'No Items'?
                    physics: AlwaysScrollableScrollPhysics(), ///
                    child: EmptyListWidget()
                ),
              ),
              child: ListView.builder(
                itemCount: _completedTaskListWrapper.taskList?.length ?? 0,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskItem: _completedTaskListWrapper.taskList![index],
                    refreshList: () {
                      _getAllCompletedTaskList();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _getAllCompletedTaskList() async {
    _getAllCompletedTaskListInProgress = true;
    if(!mounted){return;}
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.completedTaskList);
    if (response.isSuccess) {
      _completedTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getAllCompletedTaskListInProgress = false;
      if(!mounted){return;}
      setState(() {});
    } else {
      _getAllCompletedTaskListInProgress = false;
      if(!mounted){return;}
      setState(() {});
      showSnackBarMessage(
          context,
          response.errorMessage ??
              'Get Completed task list has been failed'
      );
    }
  }
}