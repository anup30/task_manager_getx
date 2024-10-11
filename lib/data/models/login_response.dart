
import 'package:task_manager_getx/data/models/user_data.dart';

class LoginResponse {
  String? status;
  String? token;
  UserData? userData;

  LoginResponse({this.status, this.token, this.userData});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    userData = json['data'] != null ?  UserData.fromJson(json['data'][0]) : null; //------------------ [0] added for new api
  }
}

/*
[log] response.body= {"status":"success","data":[{"_id":"67091437f2b7c2f8282b889e","email":"anup30coc@gmail.com","firstName":"Anup","lastName":"Barua","mobile":"01913378482","password":"ostad1234",
"createdDate":"2024-10-09T15:00:29.037Z"}],"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Mjg3Mzg2NjQsImRhdGEiOiJhbnVwMzBjb2NAZ21haWwuY29tIiwiaWF0IjoxNzI4NjUyMjY0fQ
.4s5tGiEnKVotKOAME6x2rpsTG-wKUS1H6z4Cct-ZBwQ"}
 */