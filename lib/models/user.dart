import 'package:i_forgot_eggs/models/app_list.dart';

class User {
  int id;
  String username;
  String email;
  String password;
  List lists = <AppList>[];

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  String toString() {
    return '''User: {
      id: $id, 
      username: $username, 
      lists: $lists
    }''';
  }
}
