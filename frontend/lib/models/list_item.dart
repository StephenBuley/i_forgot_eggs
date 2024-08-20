class ListItem {
  int id;
  bool completed;
  String text;

  ListItem({
    required this.id,
    this.text = '',
    this.completed = false,
  });

  void toggleComplete() {
    completed = !completed;
  }

  @override
  String toString() {
    return '''
{
  id: $id,
  completed: $completed,
  text: $text
}
''';
  }
}
