import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late List<FocusNode> textFocusNodes;
  late List<FocusNode> keyFocusNodes;

  @override
  void initState() {
    super.initState();
    list = widget.list;
    textFocusNodes =
        List.generate(widget.list.listItems.length, (_) => FocusNode());
    keyFocusNodes =
        List.generate(widget.list.listItems.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final node in textFocusNodes) {
      node.dispose();
    }
    for (final node in keyFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  bool theTimeIsRight(String value, KeyEvent event) {
    // if backspace is pressed when the item is empty
    return event.runtimeType == KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        value.isEmpty;
  }

  void addItemFrom(int index) {
    setState(() {
      list.addNewItem(nextIndex: index + 1);
      final newTextNode = FocusNode();
      final newKeyNode = FocusNode();
      textFocusNodes.insert(index + 1, newTextNode);
      keyFocusNodes.insert(index + 1, newKeyNode);
      widget.onListUpdated(list);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(newTextNode);
      });
    });
  }

  void removeItemFrom(int index) {
    setState(() {
      list.listItems.removeAt(index);
      keyFocusNodes.removeAt(index);
      textFocusNodes.removeAt(index);
      widget.onListUpdated(list);
      final prevNode = index == 0 ? null : textFocusNodes[index - 1];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(prevNode);
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
              autofocus: true,
              initialValue: list.title,
              enableSuggestions: false,
              onChanged: (value) {
                setState(() {
                  list.title = value;
                  widget.onListUpdated(list);
                });
              },
              onFieldSubmitted: (_) => addItemFrom(-1),
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
                      title: KeyboardListener(
                        focusNode: keyFocusNodes[index],
                        onKeyEvent: (event) {
                          if (!theTimeIsRight(item.text, event)) return;
                          removeItemFrom(index);
                        },
                        child: TextFormField(
                          focusNode: textFocusNodes[index],
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
