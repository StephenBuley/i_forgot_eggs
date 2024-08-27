class ListItem {
  int? id;
  bool completed;
  String text;
  int appListId;

  ListItem({
    required this.appListId,
    this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'appListId': appListId,
      'text': text,
      'completed': completed ? 1 : 0,
    };
  }

  factory ListItem.fromMap(Map<String, dynamic> map) {
    return ListItem(
      id: map['id'],
      appListId: map['appListId'],
      text: map['text'],
      completed: map['completed'] == 1,
    );
  }
}
