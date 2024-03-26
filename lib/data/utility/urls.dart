class Urls{
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static String registration = '$_baseUrl/registration';
  static String login = '$_baseUrl/login';
  static String createTask= '$_baseUrl/createTask';
  static String taskCountByStatus = '$_baseUrl/taskStatusCount';
  static String newTaskList = '$_baseUrl/listTaskByStatus/New';
  static String completedTaskList = '$_baseUrl/listTaskByStatus/Completed';
  static String cancelledTaskList = '$_baseUrl/listTaskByStatus/Cancelled';
  static String progressTaskList = '$_baseUrl/listTaskByStatus/Progress';
  static String updateProfile = '$_baseUrl/profileUpdate';
  static String recoverVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email'; // //{{BaseURL}}/RecoverVerifyEmail/anup30coc@gmail.com
  static String recoverVerifyOTP(String email, String pin) => '$_baseUrl/RecoverVerifyOTP/$email/$pin'; //{{BaseURL}}/RecoverVerifyOTP/anup30coc@gmail.com/3344
  static String recoverResetPassword = '$_baseUrl/RecoverResetPass';
  //listTaskByStatus: see all status?
  //remaining: cancelledTaskList, progressTaskList,
  static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static String updateTaskStatus(String id, String status) =>
      '$_baseUrl/updateTaskStatus/$id/$status';
}