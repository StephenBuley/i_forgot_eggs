import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:i_forgot_eggs/models/app_list.dart';

class ListsProvider extends ChangeNotifier {
  final List<AppList> _lists = [];

  UnmodifiableListView<AppList> get lists => UnmodifiableListView(_lists);

  int get numOfLists => _lists.length;

  AppList getListAt(int index) => _lists.elementAt(index);

  void createNewList() {
    _lists.add(
      AppList(
        id: 1,
        title: '',
      ),
    );

    notifyListeners();
  }
}
