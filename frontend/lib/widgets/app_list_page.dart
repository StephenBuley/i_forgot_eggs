import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_forgot_eggs/models/app_list.dart';
import 'package:i_forgot_eggs/providers/lists_provider.dart';

class AppListPage extends StatefulWidget {
  final AppList list;
  final ListsProvider provider;

  const AppListPage({
    super.key,
    required this.list,
    required this.provider,
  });

  @override
  State<AppListPage> createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  late List<FocusNode> textFocusNodes;
  late List<FocusNode> keyFocusNodes;

  @override
  void initState() {
    super.initState();
    textFocusNodes = _generateFocusNodes(widget.list.listItems.length);
    keyFocusNodes = _generateFocusNodes(widget.list.listItems.length);
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
        (event.logicalKey == LogicalKeyboardKey.backspace ||
            event.logicalKey == LogicalKeyboardKey.delete) &&
        value.isEmpty;
  }

  void addItemFrom(int index, ListsProvider provider) async {
    await provider.addItem(nextIndex: index + 1);
    setState(() {
      final newTextNode = FocusNode();
      final newKeyNode = FocusNode();
      textFocusNodes.insert(index + 1, newTextNode);
      keyFocusNodes.insert(index + 1, newKeyNode);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(newTextNode);
      });
    });
  }

  void removeItemFrom(int index, ListsProvider provider) {
    setState(() {
      provider.removeItem(index: index);
      keyFocusNodes.removeAt(index);
      textFocusNodes.removeAt(index);
    });
    final prevNode = index == 0 ? null : textFocusNodes[index - 1];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(prevNode);
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
              initialValue: widget.list.title,
              enableSuggestions: false,
              onChanged: (value) {
                widget.provider.setTitle(value);
              },
              onFieldSubmitted: (_) => addItemFrom(-1, widget.provider),
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
          children: widget.list.listItems
              .asMap()
              .map(
                (index, item) {
                  return MapEntry(
                    index,
                    Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        removeItemFrom(index, widget.provider);
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
                        onChanged: (_) {
                          widget.provider.toggleComplete(index);
                        },
                        title: KeyboardListener(
                          focusNode: keyFocusNodes[index],
                          onKeyEvent: (event) {
                            if (!theTimeIsRight(item.text, event)) return;
                            removeItemFrom(index, widget.provider);
                          },
                          child: TextFormField(
                            focusNode: textFocusNodes[index],
                            enableSuggestions: false,
                            initialValue: item.text,
                            onChanged: (value) {
                              widget.provider.setItemText(index, value);
                            },
                            onFieldSubmitted: (_) =>
                                addItemFrom(index, widget.provider),
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
            widget.provider.moveItem(oldIndex: oldIndex, newIndex: newIndex);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.provider.currentList == widget.list
            ? () {
                addItemFrom(widget.list.listItems.length - 1, widget.provider);
              }
            : null,
        tooltip: 'Add Item',
        mini: true,
        child: const Icon(Icons.add),
      ),
    );
  }
}
