import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager_getx/app.dart';
import 'package:task_manager_getx/presentation/controllers/auth_controller.dart';
import '../../presentation/screens/auth/sign_in_screen.dart';
import '../models/response_object.dart';

class NetworkCaller{ // wrapper class
  static Future<ResponseObject> getRequest(String url,/*{Map<String,dynamic>? queryParams}*/) async{
    try{
      log("url= $url"); /// import 'dart:developer'; for log()
      log("AuthController.accessToken= ${AuthController.accessToken}"); //accessToken.toString()
      final Response response = await get(
        Uri.parse(url),
          headers: {
            "token":AuthController.accessToken ?? ''
          }
      );
      log("response.statusCode= ${response.statusCode}");
      log("response.body= ${response.body}");
      if(response.statusCode==200){
        final decodedResponse = jsonDecode(response.body);
        return ResponseObject(
            isSuccess: true,
            statusCode: 200,
            responseBody: decodedResponse,
        );
      }
      else if(response.statusCode==401){ // to do: go to sign in page
        _moveToSignIn();
        return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: ''
        );
      }
      else{
        return ResponseObject(
          isSuccess: false,
          statusCode: response.statusCode,
          responseBody: '',
        );
      }
    }catch(e){
      log("error= ${e.toString()}");
      return ResponseObject(
        isSuccess: false,
        statusCode: -1,
        responseBody: '',
        errorMessage: e.toString(),
      );
    }
  }

  static Future<ResponseObject> postRequest(String url, Map<String,dynamic> body, {bool fromSignIn=false}) async{
    try{
      log("url= $url"); /// import 'dart:developer';
      log(body.toString()); //
      final Response response = await post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: {
            "Content-type":"application/json",
            "token":AuthController.accessToken ?? ''
          }
      );
      log("response.statusCode= ${response.statusCode}");
      log("response.body= ${response.body}");
      if(response.statusCode==200){
        final decodedResponse = jsonDecode(response.body);
        return ResponseObject(
          isSuccess: true,
          statusCode: 200,
          responseBody: decodedResponse,
        );
      }else if(response.statusCode==401){
        if(fromSignIn){
          return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '',
            errorMessage: 'wrong combination of Email/password, try again.',
          );
        }else{
          _moveToSignIn();
          return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '',
          );
        }
      }
      else{
        return ResponseObject(
          isSuccess: false,
          statusCode: response.statusCode,
          responseBody: '',
        );
      }
    }catch(e){
      log(e.toString());
      return ResponseObject(
        isSuccess: false,
        statusCode: -1,
        responseBody: '',
        errorMessage: e.toString(),
      );
    }
  }

  static Future<void> _moveToSignIn() async {
    await AuthController.clearUserData().then((value) => {
          Navigator.pushAndRemoveUntil(
              TaskManager.navigatorKey.currentState!.context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false
              ),
        });
  }
}