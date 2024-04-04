import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/presentation/controllers/add_new_task_controller.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_getx/presentation/widgets/profile_app_bar.dart';


class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  bool _wasNewIemAdded_0 =false; //_shouldRefreshNewTaskList
  bool _wasNewIemAdded_1 =false;
  final _titleTEController = TextEditingController();
  final _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _addNewTaskController = Get.find<AddNewTaskController>();
  @override
  Widget build(BuildContext context) {
    return PopScope( // <- new version of WillPopScope
      canPop: false,
      onPopInvoked: (bool didPop){
        if(didPop){return;}
        //Navigator.pop(context,_wasNewIemAdded);
        Get.back(result: _wasNewIemAdded_0);
      },
      child: Scaffold(
        appBar: profileAppBar, //to hide back button from appBar, used automaticallyImplyLeading: false,
        body: BackgroundWidget(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48,),
                    Text('Add New Task',style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                    ),),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: _titleTEController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                      validator: (String? val){
                        if(val?.trim().isEmpty ?? true){
                          return 'enter title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: _descriptionTEController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      validator: (String? val){
                        if(val?.trim().isEmpty ?? true){
                          return 'enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<AddNewTaskController>(
                        builder: (addNewTaskController){
                          return Visibility( // <-- wrapped with GetBuilder
                            visible: addNewTaskController.inProgress==false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  _addNewTask();
                                }
                              },
                              child: const Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          );
                        },
                      ),
                      //child:
                    ),
                    const SizedBox(height: 16,),
                    /*Center( // instead of back button, try the way as shown in class
                      child: ElevatedButton(
                        onPressed: (){Navigator.pop(context,_wasNewIemAdded);},
                        child: const Text('go back'),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _addNewTask()async{
    // _addNewTaskInProgress=true;
    // setState(() {});
    Map<String,dynamic> inputParams ={
      "title":_titleTEController.text.trim(),
      "description":_descriptionTEController.text.trim(),
      "status":"New"
    };
    _wasNewIemAdded_1 = await _addNewTaskController.addNewTask(inputParams);
    // last addition can fail, while previous addition can be success, _wasNewIemAdded_0 is ture at least 1 item added successfully
    if(_wasNewIemAdded_1){
      _wasNewIemAdded_0=true;
    }
  }
  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose(); ///
  }
}