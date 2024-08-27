import 'package:i_forgot_eggs/models/list_item.dart';

class AppList {
  int? id;
  String title;
  List<ListItem> listItems;

  AppList({
    this.id,
    required this.listItems,
    this.title = '',
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

  void addNewItem({int? nextIndex, required ListItem item}) {
    final i = nextIndex ?? listItems.length;
    listItems.insert(i, item);
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory AppList.fromMap(Map<String, dynamic> map, List<ListItem> items) {
    return AppList(
      id: map['id'],
      title: map['title'],
      listItems: items,
    );
  }
}
