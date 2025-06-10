import 'package:flutter/material.dart';
import 'package:movies_app/data/notifier.dart';
import 'package:movies_app/views/pages/home_page.dart';
import 'package:movies_app/views/pages/search_page.dart';
import 'package:movies_app/views/pages/watch_list_page.dart';
import 'package:movies_app/widgets/bottom_navigation.dart';

List<Widget> pages = [HomePage(), SearchPage(), WatchListPage()];
List<AppBar?> appBars = [null, searchPageAppBar, watchListPageAppBar];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: loadingNotifier,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return Scaffold(
            body: Center(
              child: Image.asset(
                width: 189,
                height: 189,
                fit: BoxFit.contain,
                'assets/images/popcorn.png',
              ),
            ),
          );
        }

        return ValueListenableBuilder<int>(
          valueListenable: selectedPageNotifier,
          builder: (context, selectedPage, child) {
            return Scaffold(
              appBar: appBars[selectedPage],
              body: pages[selectedPage],
              bottomNavigationBar: const BottomNavigation(),
            );
          },
        );
      },
    );
  }
}
