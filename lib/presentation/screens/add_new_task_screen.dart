import 'package:flutter/material.dart';
import 'package:task_manager_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_getx/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager_getx/presentation/widgets/snack_bar_message.dart';

import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  bool _wasNewIemAdded =false; //_shouldRefreshNewTaskList
  final _titleTEController = TextEditingController();
  final _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress= false;
  @override
  Widget build(BuildContext context) {
    return PopScope( // <- new version of WillPopScope
      canPop: false,
      onPopInvoked: (bool didPop){
        if(didPop){return;}
        Navigator.pop(context,_wasNewIemAdded);
      },
      child: Scaffold(
        appBar: profileAppBar, // to hide back button from appBar, use automaticallyImplyLeading: false,
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
                      child: Visibility(
                        visible: _addNewTaskInProgress==false,
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
                      ),
                    ),
                    const SizedBox(height: 16,),
                    /*Center( // try the way as class
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
    _addNewTaskInProgress=true;
    setState(() {});
    Map<String,dynamic> inputParams ={
      "title":_titleTEController.text.trim(),
      "description":_descriptionTEController.text.trim(),
      "status":"New"
    };
    final response =
      await NetworkCaller.postRequest(Urls.createTask, inputParams);
    _addNewTaskInProgress=false;
    setState(() {});
    if(response.isSuccess){
      _wasNewIemAdded =true;
      _titleTEController.clear();
      _descriptionTEController.clear();
      if(mounted){
        showSnackBarMessage(context,'new task has been added');
      }
    }else{
      if(mounted){
        showSnackBarMessage(
            context,
            response.errorMessage ?? 'failed to add new task!',true);
      }
    }
  }
  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose(); ///
  }
}
