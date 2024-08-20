import 'package:i_forgot_eggs/models/list_item.dart';

class AppList {
  int id;
  String title;
  List<ListItem> listItems = [];
  int nextItemId = 0;

  AppList({
    required this.id,
    required this.title,
  });

  // this toggles the "completed" property for the given item id
  void toggleComplete(int itemId) {
    final found = listItems.indexWhere(
      (element) => element.id == itemId,
    );
    if (found != -1) {
      listItems[found].toggleComplete();
    }
  }

  void addNewItem({int? nextIndex}) {
    final i = nextIndex ?? listItems.length;
    listItems.insert(i, ListItem(id: nextItemId++));
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
