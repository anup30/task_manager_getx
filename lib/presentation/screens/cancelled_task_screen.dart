import 'package:flutter/material.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import '../../data/models/task_list_wrapper.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';
import '../widgets/empty_list_widget.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getAllCancelledTaskListInProgress = false;
  TaskListWrapper _cancelledTaskListWrapper = TaskListWrapper();
  @override
  void initState() {
    super.initState();
    _getAllCancelledTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Visibility(
          visible: _getAllCancelledTaskListInProgress == false,
          replacement: const Center(child: CircularProgressIndicator()),
          child: RefreshIndicator(
            onRefresh: () async {
              _getAllCancelledTaskList();
            },
            child: Visibility(
              visible: _cancelledTaskListWrapper.taskList?.isNotEmpty ?? false,
              replacement: const Center(
                child: SingleChildScrollView( //solved: Refresh not working for 'No Items'?
                    physics: AlwaysScrollableScrollPhysics(),
                    child: EmptyListWidget()
                ),
              ),
              child: ListView.builder(
                itemCount: _cancelledTaskListWrapper.taskList?.length ?? 0,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskItem: _cancelledTaskListWrapper.taskList![index],
                    refreshList: () {
                      _getAllCancelledTaskList();
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
  Future<void> _getAllCancelledTaskList() async {
    _getAllCancelledTaskListInProgress = true;
    if(!mounted){return;}
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.cancelledTaskList);
    if (response.isSuccess) {
      _cancelledTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getAllCancelledTaskListInProgress = false;
      if(!mounted){return;}
      setState(() {});
    }else{
      _getAllCancelledTaskListInProgress = false;
      if(!mounted){return;}
      setState(() {});
      showSnackBarMessage(
          context,
          response.errorMessage ?? 'Get Cancelled task list has been failed'
      );
    }
  }
}