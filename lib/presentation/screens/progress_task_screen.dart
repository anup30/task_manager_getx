import 'package:flutter/material.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import '../../data/models/task_list_wrapper.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';
import '../widgets/empty_list_widget.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getAllProgressTaskListInProgress = false;
  TaskListWrapper _progressTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
    super.initState();
    _getAllProgressTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Visibility(
          visible: _getAllProgressTaskListInProgress==false,
          replacement: const Center(child: CircularProgressIndicator()),
          child: RefreshIndicator(
            onRefresh: () async {
              _getAllProgressTaskList();
            },
            child: Visibility(
              visible: _progressTaskListWrapper.taskList?.isNotEmpty ?? false,
              replacement: const Center(
                child: SingleChildScrollView( //solved: Refresh not working for 'No Items'?
                    physics: AlwaysScrollableScrollPhysics(),

                    ///
                    child: EmptyListWidget()
                ),
              ),
              child: ListView.builder(
                itemCount: _progressTaskListWrapper.taskList?.length ?? 0,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskItem: _progressTaskListWrapper.taskList![index],
                    refreshList: () {
                      _getAllProgressTaskList();
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
  Future<void> _getAllProgressTaskList() async{
    _getAllProgressTaskListInProgress = true;
    if(!mounted){return;}
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.progressTaskList);
    if (response.isSuccess) {
      _progressTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getAllProgressTaskListInProgress = false;
      if(!mounted){return;}
      setState(() {});
    }else{
      _getAllProgressTaskListInProgress = false;
      if(!mounted){return;}
      setState(() {});
      showSnackBarMessage(
          context,
          response.errorMessage ?? 'Get Cancelled task list has been failed'
      );
    }
  }
}