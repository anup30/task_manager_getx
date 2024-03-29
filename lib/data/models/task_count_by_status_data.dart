class TaskCountByStatusData {
  String? sId; // _id
  int? sum;

  TaskCountByStatusData({this.sId, this.sum});

  TaskCountByStatusData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }
}