import 'package:flutter/material.dart';
import 'package:i_forgot_eggs/providers/lists_provider.dart';
import 'package:i_forgot_eggs/widgets/app_list_page.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PagesOfAppLists extends StatefulWidget {
  const PagesOfAppLists({super.key});

  @override
  State<PagesOfAppLists> createState() => _PagesOfAppListsState();
}

class _PagesOfAppListsState extends State<PagesOfAppLists> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<ListsProvider>();

    void showDeleteConfirmationDialog(BuildContext context, int? index) {
      if (index != null && lists.currentList != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete List'),
              content: const Text(
                  'Are you sure you want to delete the entire list?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    lists.removeList();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      }
    }

    List<AppListPage> generateAppListPages() {
      return lists.lists
          .asMap()
          .map(
            (index, list) => MapEntry(
              index,
              AppListPage(
                key: ObjectKey(list),
                list: list,
                provider: lists,
              ),
            ),
          )
          .values
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('I Forgot Eggs'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            onPressed: () {
              print(_pageController.page);
            },
            tooltip: 'Share',
            icon: const Icon(Icons.ios_share),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                showDeleteConfirmationDialog(
                    context, (_pageController.page?.round()));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete List'),
                ),
              ];
            },
            tooltip: 'Options',
            icon: const Icon(Icons.more_vert), // This is the breadcrumb icon
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              lists.currentListIndex = value;
            },
            controller: _pageController,
            children: [
              ...generateAppListPages(),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            lists.createNewList();
                            lists.currentListIndex =
                                _pageController.page!.round();
                          },
                          child: const Text('Add New List'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: lists.numOfLists + 1,
                effect: ScrollingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  maxVisibleDots: 7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
