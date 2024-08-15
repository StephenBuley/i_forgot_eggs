import 'package:i_forgot_eggs/models/list_item.dart';

class AppList {
  int id;
  String title;
  List<ListItem> listItems = [];

  AppList({
    required this.id,
    required this.title,
  });

  // this toggles the "completed" property for the given item id
  toggleComplete(int itemId) {
    final found = listItems.indexWhere(
      (element) => element.id == itemId,
    );
    if (found != -1) {
      listItems[found].completed = !listItems[found].completed;
    }
  }

  @override
  String toString() {
    return '''
{
  id: $id,
  title: $title,
  listItems: $listItems,
}
''';
  }
}
