import 'package:flutter/material.dart';
import 'package:i_forgot_eggs/providers/list_provider.dart';
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
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: lists.numOfLists + 1, // +1 for the "add new list" page
            itemBuilder: (context, index) {
              if (index < lists.numOfLists) {
                final list = lists.getListAt(index);
                return ChangeNotifierProvider(
                  create: (context) => ListProvider(list: list),
                  child: AppListPage(
                    listId: list.id,
                    listLength: list.listItems.length,
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              lists.createNewList();
                            },
                            child: const Text('Add New List'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
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
