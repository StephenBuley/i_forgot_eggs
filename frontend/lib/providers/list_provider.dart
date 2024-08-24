import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:i_forgot_eggs/models/app_list.dart';
import 'package:i_forgot_eggs/models/list_item.dart';

class ListProvider extends ChangeNotifier {
  final AppList _list;

  ListProvider({required AppList list}) : _list = list;

  int get numOfItems => _list.listItems.length;

  String get title => _list.title;

  UnmodifiableListView<ListItem> get items =>
      UnmodifiableListView(_list.listItems);

  set title(String newTitle) {
    _list.title = newTitle.trim();
    notifyListeners();
  }

  void moveItem({required int oldIndex, required int newIndex}) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final movedItem = _list.listItems.removeAt(oldIndex);
    _list.listItems.insert(newIndex, movedItem);
    notifyListeners();
  }

  void addItem({required int nextIndex}) {
    _list.addNewItem(nextIndex: nextIndex);
    notifyListeners();
  }

  void removeItem({required int index}) {
    _list.listItems.removeAt(index);
    notifyListeners();
  }
}
