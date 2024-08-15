import 'package:flutter/material.dart';
import 'package:i_forgot_eggs/models/app_list.dart';
import 'package:i_forgot_eggs/models/list_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'I Forgot Eggs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const PagesOfAppLists();
  }
}

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
    final list = lists[0];
    list.listItems.add(ListItem(id: 1, text: 'Eggs'));
    list.listItems.add(ListItem(id: 2, text: 'Milk'));
    list.listItems.add(ListItem(id: 3, text: 'Salsa'));

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

class AppListPage extends StatefulWidget {
  final AppList list;
  final Function(AppList) onListUpdated;

  const AppListPage(
      {super.key, required this.list, required this.onListUpdated});

  @override
  State<AppListPage> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<AppListPage> {
  late AppList list;

  @override
  void initState() {
    super.initState();
    list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ReorderableListView(
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              list.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          prototypeItem: CheckboxListTile(
            value: false,
            onChanged: (value) {},
            title: const Text("Sample Item"),
          ),
          children: list.listItems.map((item) {
            return CheckboxListTile(
              key: ValueKey(item.id),
              value: item.completed,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  item.completed = value ?? false;
                  widget.onListUpdated(list);
                });
              },
              title: TextFormField(
                enableSuggestions: false,
                initialValue: item.text,
                onChanged: (value) {
                  setState(() {
                    item.text = value;
                    widget.onListUpdated(list);
                  });
                },
              ),
            );
          }).toList(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final movedItem = list.listItems.removeAt(oldIndex);
              list.listItems.insert(newIndex, movedItem);
              widget.onListUpdated(list);
            });
          },
        ),
      ),
    );
  }
}
