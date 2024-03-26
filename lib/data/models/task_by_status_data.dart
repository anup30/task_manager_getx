class TaskByStatusData {
  String? sId; // _id
  int? sum;

  TaskByStatusData({this.sId, this.sum});

  TaskByStatusData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }
}