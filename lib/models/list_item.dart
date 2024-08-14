class ListItem {
  int id;
  bool completed = false;
  String text = '';

  ListItem({required this.id});

  String toString() {
    return '''ListItem: {
      id: $id,
      completed: $completed,
      text: $text
    }''';
  }
}
