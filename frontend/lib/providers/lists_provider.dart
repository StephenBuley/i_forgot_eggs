import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:i_forgot_eggs/db/database_helper.dart';
import 'package:i_forgot_eggs/models/app_list.dart';
import 'package:i_forgot_eggs/models/list_item.dart';

class ListsProvider extends ChangeNotifier {
  List<AppList> _lists = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  AppList? _currentList;
  int? _currentListIndex;

  ListsProvider() {
    _loadAppLists();
  }

  Future<void> _loadAppLists() async {
    _lists = await _dbHelper.getAppLists();
    if (numOfLists > 0) {
      currentListIndex = 0;
    }
    notifyListeners();
  }

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

  Future<void> setTitle(String newTitle) async {
    _currentList!.title = newTitle.trim();
    await _dbHelper.updateAppList(_currentList!);
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

  Future<void> addItem({required int nextIndex}) async {
    final listId = _currentList!.id!;
    final newItem = ListItem(appListId: listId);
    final id = await _dbHelper.insertListItem(newItem);
    final item = ListItem(appListId: listId, id: id);
    _currentList!.addNewItem(nextIndex: nextIndex, item: item);
    notifyListeners();
  }

  void removeItem({required int index}) {
    final items = _currentList!.listItems;
    _dbHelper.deleteListItem(items[index].id!);
    items.removeAt(index);
    notifyListeners();
  }

  Future<void> createNewList() async {
    final newList = AppList(listItems: []);
    final id = await _dbHelper.insertAppList(newList);
    final newListWithId = AppList(id: id, listItems: []);
    _lists.add(newListWithId);
    currentListIndex = numOfLists - 1;
    notifyListeners();
  }

  Future<void> removeList() async {
    _lists.removeAt(currentListIndex!);
    await _dbHelper.deleteAppList(currentList!.id!);
    if (currentListIndex == numOfLists) {
      currentListIndex = null;
    } else {
      // we have to do this to reset currentList
      currentListIndex = currentListIndex;
    }
    notifyListeners();
  }

  Future<void> toggleComplete(int index) async {
    final item = _currentList!.listItems[index];
    item.toggleComplete();
    await _dbHelper.updateListItem(item);
    notifyListeners();
  }

  Future<void> setItemText(int index, String newText) async {
    final item = _currentList!.listItems[index];
    item.text = newText.trim();
    await _dbHelper.updateListItem(item);
    notifyListeners();
  }

  // Future<void> updateAppList(AppList appList) async {
  //   await _dbHelper.updateAppList(appList);
  //   int index = _lists.indexWhere((list) => list.id == appList.id);
  //   if (index != -1) {
  //     _lists[index] = appList;
  //     notifyListeners();
  //   }
  // }

  // Future<void> deleteAppList(int id) async {
  //   await _dbHelper.deleteAppList(id);
  //   _lists.removeWhere((list) => list.id == id);
  //   notifyListeners();
  // }

  // Future<void> addListItem(int appListId, ListItem listItem) async {
  //   int id = await _dbHelper.insertListItem(listItem);
  //   int index = _lists.indexWhere((list) => list.id == appListId);
  //   if (index != -1) {
  //     _lists[index].listItems.add(ListItem(
  //         id: id,
  //         appListId: appListId,
  //         text: listItem.text,
  //         completed: listItem.completed));
  //     notifyListeners();
  //   }
  // }

  // Future<void> updateListItem(ListItem listItem) async {
  //   await _dbHelper.updateListItem(listItem);
  //   int listIndex = _lists.indexWhere((list) => list.id == listItem.appListId);
  //   if (listIndex != -1) {
  //     int itemIndex = _lists[listIndex]
  //         .listItems
  //         .indexWhere((item) => item.id == listItem.id);
  //     if (itemIndex != -1) {
  //       _lists[listIndex].listItems[itemIndex] = listItem;
  //       notifyListeners();
  //     }
  //   }
  // }

  // Future<void> deleteListItem(int appListId, int listItemId) async {
  //   await _dbHelper.deleteListItem(listItemId);
  //   int listIndex = _lists.indexWhere((list) => list.id == appListId);
  //   if (listIndex != -1) {
  //     _lists[listIndex].listItems.removeWhere((item) => item.id == listItemId);
  //     notifyListeners();
  //   }
  // }
}
