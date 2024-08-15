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
  AppList list = AppList(id: 1, title: 'Grocery List');

  @override
  void initState() {
    list.listItems.add(ListItem(id: 1, text: 'Eggs'));
    list.listItems.add(ListItem(id: 2, text: 'Milk'));
    list.listItems.add(ListItem(id: 3, text: 'Salsa'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ReorderableListView(
          buildDefaultDragHandles: false,
          prototypeItem: CheckboxListTile(
            value: false,
            onChanged: (value) {},
          ),
          children: list.listItems.map(
            (item) {
              return CheckboxListTile(
                key: ValueKey(item.id),
                value: item.completed,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    item.completed = value!;
                  });
                },
                title: Text(item.text),
              );
            },
          ).toList(),
          onReorder: (oldIndex, newIndex) {},
        ),
      ),
    );
  }
}
