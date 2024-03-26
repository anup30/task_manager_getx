import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_getx/presentation/controllers/auth_controller.dart';
import 'package:task_manager_getx/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_getx/presentation/widgets/snack_bar_message.dart';
import '../../data/models/user_data.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';
import '../widgets/background_widget.dart';
import '../widgets/profile_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  //static bool isThisPageOnNavigatorTop = false;
  // in this way, UpdateProfileScreen must not be below top of navigation stack. if isActive, must be isCurrent ***********************
  // so if you leave this page, leave by pop or by pushReplacement.
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> { // <----------- hashcode/key ? ==? route.settings.hashcode/key (?)
  final _emailTEController = TextEditingController();
  final _firstNameTEController = TextEditingController();
  final _lastNameTEController = TextEditingController();
  final _mobileTEController = TextEditingController();
  final _passwordTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool _updateProfileInProgress =false;
  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthController.userData?.email ??'';
    _firstNameTEController.text = AuthController.userData?.firstName ??'';
    _lastNameTEController.text = AuthController.userData?.lastName ??'';
    _mobileTEController.text = AuthController.userData?.mobile ??'';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48,),
                  Text('Update Profile',style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16,),
                  imagePickerButton(), // method extraction
                  const SizedBox(height: 8,),
                  TextFormField(
                    enabled: false,
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? val){
                      if(val?.trim().isEmpty ?? true){
                        return 'Enter First Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? val){
                      if(val?.trim().isEmpty ?? true){
                        return 'Enter Last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Mobile',
                    ),
                    maxLength: 11,
                    validator: (String? val){
                      if(val?.trim().isEmpty ?? true){
                        return 'Enter Mobile Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: const InputDecoration(
                      hintText: 'Password(optional)',
                    ),
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _updateProfileInProgress==false,
                      replacement: const Center(child: CircularProgressIndicator(),),
                      child: ElevatedButton(
                        onPressed: () {
                          _updateProfile();
                        },
                        child: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imagePickerButton() {
    return GestureDetector(
      onTap: (){
        pickImageFromGallery();
      },
      child: SizedBox(
        child: Row(
          children: [
            Container(
              //height: 50, width: 100,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ), // do left only
                //shape: RoundedRectangleBorder, -------------------------
              ),
              child: const Center(
                child: Text(
                  'Photo: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8,),
            Expanded(
                child: Text(
                  _pickedImage?.name ?? '',
                  maxLines: 1,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          ],
        ),
      ),
    );
  }
  Future <void> pickImageFromGallery()async{
    ImagePicker imagePicker = ImagePicker();
    _pickedImage= await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
  Future <void> _updateProfile()async{
    String? photo;
    _updateProfileInProgress =true;
    setState(() {});

    Map<String,dynamic> inputParams ={
      "email":_emailTEController.text,
      "firstName":_firstNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
      //"password":"1234",
      //"photo":""
    };
    if(_passwordTEController.text.isNotEmpty){
      inputParams["password"] = _passwordTEController.text;
    }
    if(_pickedImage != null){
      //convert image to base64 first, before sending (multipart format - for big files)
      List<int> bytes= File(_pickedImage!.path).readAsBytesSync(); // import 'dart:io';
      String photo = base64Encode(bytes);
      inputParams['photo']= photo;
    }
    final response = await NetworkCaller.postRequest(Urls.updateProfile, inputParams);
    _updateProfileInProgress=false;
    //setState(() {}); ///
    if(response.isSuccess){
      if(response.responseBody['status']=='success'){
        UserData userData= UserData(
            email: _emailTEController.text,
            firstName: _firstNameTEController.text.trim(),
            lastName: _lastNameTEController.text.trim(),
            mobile: _mobileTEController.text.trim(),
            photo: photo
        );
        await AuthController.saveUserData(userData);
      }
      //setState(() {}); ///
      if(mounted){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context)=>const MainBottomNavScreen()),
                (route) => false);
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, 'Update Profile failed, try again');
      }
    }
  }
  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    //UpdateProfileScreen.isThisPageOnNavigatorTop=false;
  }
}
