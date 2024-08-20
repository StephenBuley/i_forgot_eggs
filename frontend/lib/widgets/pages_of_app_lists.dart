import 'package:flutter/material.dart';
import 'package:i_forgot_eggs/models/app_list.dart';
import 'package:i_forgot_eggs/widgets/app_list_page.dart';

class PagesOfAppLists extends StatefulWidget {
  const PagesOfAppLists({super.key});

  @override
  State<PagesOfAppLists> createState() => _PagesOfAppListsState();
}

class _PagesOfAppListsState extends State<PagesOfAppLists> {
  List<AppList> lists = [
    AppList(id: 1, title: 'Grocery List'),
  ];

  @override
  void initState() {
    lists[0].addNewItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('I Forgot Eggs'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: lists.length + 1, // +1 for the "add new list" page
        itemBuilder: (context, index) {
          if (index < lists.length) {
            return AppListPage(
              list: lists[index],
              onListUpdated: (updatedlist) {
                setState(() {
                  lists[index] = updatedlist;
                });
              },
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    lists.add(AppList(
                      id: 1,
                      title: 'new list',
                    ));
                  });
                },
                child: const Text('Add New List'),
              ),
            );
          }
        },
      ),
    );
  }
}
