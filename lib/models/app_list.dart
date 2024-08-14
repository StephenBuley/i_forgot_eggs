import 'package:i_forgot_eggs/models/list_item.dart';

class AppList {
  int id;
  String title;
  List listItems = <ListItem>[];

  AppList({
    required this.id,
    required this.title,
  });

  String toString() {
    return '''AppLists: {
      id: $id,
      title: $title,
      listItems: $listItems,
    }
''';
  }
}
