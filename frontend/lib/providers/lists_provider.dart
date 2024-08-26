import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:i_forgot_eggs/models/app_list.dart';
import 'package:i_forgot_eggs/models/list_item.dart';

class ListsProvider extends ChangeNotifier {
  final List<AppList> _lists = [];
  AppList? _currentList;
  int? _currentListIndex;

  UnmodifiableListView<AppList> get lists => UnmodifiableListView(_lists);

  int get numOfLists => _lists.length;

  AppList? get currentList => _currentList;

  int? get currentListIndex => _currentListIndex;

  set currentListIndex(int? index) {
    if (index == null) return;
    if (index >= numOfLists) {
      // we are on the add new list page, currentList is null
      _currentList = null;
      _currentListIndex = null;
    } else {
      // we are on a list
      _currentList = getListAt(index);
      _currentListIndex = index;
    }
    notifyListeners();
  }

  AppList getListAt(int index) => _lists.elementAt(index);

  String getListTitle() {
    return _currentList?.title ?? '';
  }

  void setTitle(String newTitle) {
    _currentList!.title = newTitle.trim();
    notifyListeners();
  }

  UnmodifiableListView<ListItem> getItems() {
    return UnmodifiableListView(_currentList!.listItems);
  }

  void moveItem({required int oldIndex, required int newIndex}) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final movedItem = _currentList!.listItems.removeAt(oldIndex);
    _currentList!.listItems.insert(newIndex, movedItem);
    notifyListeners();
  }

  void addItem({required int nextIndex}) {
    _currentList!.addNewItem(nextIndex: nextIndex);
    notifyListeners();
  }

  void removeItem({required int index}) {
    _currentList!.listItems.removeAt(index);
    notifyListeners();
  }

  AppList createNewList() {
    final newList = AppList(id: 1, title: '');
    _lists.add(newList);
    currentListIndex = numOfLists - 1;
    notifyListeners();
    return newList;
  }

  void removeList() {
    _lists.removeAt(currentListIndex!);
    if (currentListIndex == numOfLists) {
      currentListIndex = null;
    } else {
      // we have to do this to reset currentList
      currentListIndex = currentListIndex;
    }
    notifyListeners();
  }

  void toggleComplete(int index) {
    _currentList!.listItems[index].toggleComplete();
    notifyListeners();
  }

  void setItemText(int index, String newText) {
    _currentList!.listItems[index].text = newText.trim();
    notifyListeners();
  }
}
