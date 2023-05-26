class ReqresUrls {
  static const String base = 'https://reqres.in/api';

  static const String loginUrl = '$base/login';
  static const String loginUrl2 = '/login';
  static const String createUserUrl = '$base/users';
  static const String updateUserUrl = '$base/users/{id}';
  static const String listUsersUrl = '$base/users?page={n}';
  static const String singleUserUrl = '$base/users/{id}';

  static const String testUrl = '$base/users/2';
  static const String testPostUrl = '$base/users';
}
