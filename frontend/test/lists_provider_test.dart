import 'package:flutter_test/flutter_test.dart';
import 'package:i_forgot_eggs/models/app_list.dart';
import 'package:i_forgot_eggs/providers/lists_provider.dart';

void main() {
  group('ListsProvider class', () {
    test('can create new lists', () {
      final provider = ListsProvider();
      final listsBefore = provider.lists;

      expect(listsBefore, []);
      provider.createNewList();
      final createdList = provider.lists[0];
      expect(createdList.id, 1);
      expect(createdList.title, '');
      expect(createdList.listItems, []);

      expect(provider.numOfLists, 1);
      AppList? foundList = provider.currentList;
      expect(foundList?.id, 1);
      expect(foundList?.title, '');
      expect(foundList?.listItems, []);
      expect(provider.currentListIndex, 0);
    });

    test('sets current list title', () {
      final provider = ListsProvider();
      provider.createNewList();
      provider.setTitle('my new title');
      expect(provider.currentListIndex, 0);
      expect(provider.currentList?.title, 'my new title');

      provider.createNewList();
      provider.setTitle('again');

      expect(provider.currentListIndex, 1);
      expect(provider.currentList?.title, 'again');
      expect(provider.getListAt(0).title, 'my new title');
    });

    test('correctly sets currentList on index change', () {
      final provider = ListsProvider();
      provider.createNewList();
      provider.setTitle('my new title');

      provider.createNewList();
      provider.setTitle('again');

      provider.currentListIndex = 0;
      expect(provider.currentListIndex, 0);
      expect(provider.currentList?.title, 'my new title');
    });

    test('can remove list', () {
      final provider = ListsProvider();
      provider.createNewList();
      provider.setTitle('list 1');
      provider.createNewList();
      provider.setTitle('list 2');
      expect(provider.currentList?.title, 'list 2');

      provider.currentListIndex = 0;
      expect(provider.currentList?.title, 'list 1');
      provider.removeList();
      expect(provider.numOfLists, 1);
      expect(provider.getListAt(0), provider.currentList);
      expect(provider.currentList?.title, 'list 2');
    });

    test('can add items', () {
      // set up provider and two lists
      final provider = ListsProvider();
      provider.createNewList();
      provider.setTitle('list 1');
      provider.createNewList();
      provider.setTitle('list 2');
      // go back to the first list and add an item
      provider.currentListIndex = 0;
      provider.addItem(nextIndex: 0);
      provider.getItems().first.text = 'my item text';
      final items = provider.getItems();
      expect(items.length, 1);
      expect(items.first.text, 'my item text');
      // go to second list and add an item
      provider.currentListIndex = 1;
      provider.addItem(nextIndex: 0);
      provider.getItems().first.text = 'my item text again';
      final secondItems = provider.getItems();
      expect(secondItems.length, 1);
      expect(secondItems.first.text, 'my item text again');
      // go back to first list and check that nothing changed
      provider.currentListIndex = 0;
      final firstItemsAgain = provider.getItems();
      expect(firstItemsAgain.length, 1);
      expect(firstItemsAgain.first.text, 'my item text');
    });

    test('can remove items', () {
      // set up provider and a list
      final provider = ListsProvider();
      provider.createNewList();
      provider.setTitle('list 1');
      provider.addItem(nextIndex: 0);
      provider.getItems().first.text = 'my item text';
      provider.addItem(nextIndex: 1);
      provider.getItems().last.text = 'my second item';
      // remove first item
      provider.removeItem(index: 0);
      final items = provider.getItems();
      expect(items.length, 1);
      expect(items.first.text, 'my second item');

      // do it again and check to make sure first stays ok
      provider.createNewList();
      provider.setTitle('newTitle');
      provider.addItem(nextIndex: 0);
      provider.getItems().first.text = 'second list item text';
      provider.addItem(nextIndex: 1);
      provider.getItems().last.text = 'second second';
      final items2 = provider.getItems();
      expect(items2.length, 2);
      provider.removeItem(index: 1);
      final items2Again = provider.getItems();
      expect(items2Again.length, 1);
      expect(items2Again.first.text, 'second list item text');

      provider.currentListIndex = 0;
      final itemsAgain = provider.getItems();
      expect(itemsAgain.length, 1);
      expect(itemsAgain.first.text, 'my second item');
    });

    test('can move items', () {
      // set up provider and a list
      final provider = ListsProvider();
      provider.createNewList();
      provider.setTitle('list 1');
      provider.addItem(nextIndex: 0);
      provider.getItems().first.text = 'my item text';
      provider.addItem(nextIndex: 1);
      provider.getItems().last.text = 'my second item';
      // swap first and second
      // this is because the onReorder function moves to one past the new index
      provider.moveItem(oldIndex: 0, newIndex: 2);
      final items = provider.getItems();
      expect(items.length, 2);
      expect(items.first.text, 'my second item');
      expect(items.last.text, 'my item text');

      provider.moveItem(oldIndex: 1, newIndex: 0);
      final itemsAgain = provider.getItems();
      expect(itemsAgain.length, 2);
      expect(itemsAgain.first.text, 'my item text');
      expect(itemsAgain.last.text, 'my second item');
    });
  });
}
