import 'package:flutter/material.dart';
import 'package:i_forgot_eggs/models/app_list.dart';
import 'package:i_forgot_eggs/widgets/app_list_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PagesOfAppLists extends StatefulWidget {
  const PagesOfAppLists({super.key});

  @override
  State<PagesOfAppLists> createState() => _PagesOfAppListsState();
}

class _PagesOfAppListsState extends State<PagesOfAppLists> {
  List<AppList> lists = [
    AppList(id: 1, title: 'Grocery List'),
  ];

  final PageController _pageController = PageController(viewportFraction: 0.9);

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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                lists.add(AppList(
                                  id: 1,
                                  title: '',
                                ));
                              });
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
                count: lists.length + 1,
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
