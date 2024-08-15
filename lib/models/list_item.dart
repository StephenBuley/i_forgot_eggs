class ListItem {
  int id;
  bool completed;
  String text;

  ListItem({
    required this.id,
    this.text = '',
    this.completed = false,
  });

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
