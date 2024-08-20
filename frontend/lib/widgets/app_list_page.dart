import 'package:flutter/material.dart';
import 'package:i_forgot_eggs/models/app_list.dart';

class AppListPage extends StatefulWidget {
  final AppList list;
  final Function(AppList) onListUpdated;

  const AppListPage(
      {super.key, required this.list, required this.onListUpdated});

  @override
  State<AppListPage> createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  late AppList list;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    list = widget.list;
    focusNodes =
        List.generate(widget.list.listItems.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void addItemFrom(int index) {
    setState(() {
      list.addNewItem(nextIndex: index + 1);
      final newNode = FocusNode();
      focusNodes.insert(index + 1, newNode);
      widget.onListUpdated(list);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(newNode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ReorderableListView(
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: list.title,
              enableSuggestions: false,
              onChanged: (value) {
                setState(() {
                  list.title = value;
                  widget.onListUpdated(list);
                });
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          prototypeItem: ExcludeFocus(
            child: CheckboxListTile(
              value: false,
              onChanged: (value) {},
              title: const Text("Sample Item"),
            ),
          ),
          children: list.listItems
              .asMap()
              .map(
                (index, item) {
                  return MapEntry(
                    index,
                    CheckboxListTile(
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
                        focusNode: focusNodes[index],
                        enableSuggestions: false,
                        initialValue: item.text,
                        onChanged: (value) {
                          setState(() {
                            item.text = value;
                            widget.onListUpdated(list);
                          });
                        },
                        onFieldSubmitted: (_) => addItemFrom(index),
                      ),
                    ),
                  );
                },
              )
              .values
              .toList(),
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
