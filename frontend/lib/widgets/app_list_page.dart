import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_forgot_eggs/models/app_list.dart';
import 'package:i_forgot_eggs/providers/list_provider.dart';
import 'package:provider/provider.dart';

class AppListPage extends StatefulWidget {
  final int listId;
  final int listLength;

  const AppListPage({
    super.key,
    required this.listId,
    required this.listLength,
  });

  @override
  State<AppListPage> createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  late AppList listId;
  late List<FocusNode> textFocusNodes;
  late List<FocusNode> keyFocusNodes;

  @override
  void initState() {
    super.initState();
    textFocusNodes = _generateFocusNodes(widget.listLength);
    keyFocusNodes = _generateFocusNodes(widget.listLength);
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

  List<FocusNode> _generateFocusNodes(int length) {
    return List.generate(length, (_) => FocusNode());
  }

  bool theTimeIsRight(String value, KeyEvent event) {
    // if backspace is pressed when the item is empty
    return event.runtimeType == KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        value.isEmpty;
  }

  void addItemFrom(int index, ListProvider list) {
    setState(() {
      list.addItem(nextIndex: index + 1);
      final newTextNode = FocusNode();
      final newKeyNode = FocusNode();
      textFocusNodes.insert(index + 1, newTextNode);
      keyFocusNodes.insert(index + 1, newKeyNode);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(newTextNode);
      });
    });
  }

  void removeItemFrom(int index, ListProvider list) {
    setState(() {
      list.removeItem(index: index);
      keyFocusNodes.removeAt(index);
      textFocusNodes.removeAt(index);
      final prevNode = index == 0 ? null : textFocusNodes[index - 1];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(prevNode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = context.watch<ListProvider>();

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
                list.title = value;
              },
              onFieldSubmitted: (_) => addItemFrom(-1, list),
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
          children: list.items
              .asMap()
              .map(
                (index, item) {
                  return MapEntry(
                    index,
                    Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        removeItemFrom(index, list);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${item.text} deleted"),
                            duration: Durations.extralong1,
                          ),
                        );
                      },
                      background: Container(
                        color: Theme.of(context).colorScheme.error,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: CheckboxListTile(
                        key: ValueKey(item.id),
                        value: item.completed,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {
                          setState(() {
                            item.completed = value ?? false;
                          });
                        },
                        title: KeyboardListener(
                          focusNode: keyFocusNodes[index],
                          onKeyEvent: (event) {
                            if (!theTimeIsRight(item.text, event)) return;
                            removeItemFrom(index, list);
                          },
                          child: TextFormField(
                            focusNode: textFocusNodes[index],
                            enableSuggestions: false,
                            initialValue: item.text,
                            onChanged: (value) {
                              setState(() {
                                item.text = value;
                              });
                            },
                            onFieldSubmitted: (_) => addItemFrom(index, list),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
              .values
              .toList(),
          onReorder: (oldIndex, newIndex) {
            list.moveItem(oldIndex: oldIndex, newIndex: newIndex);
          },
        ),
      ),
    );
  }
}
