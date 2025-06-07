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
      // Assuming you have a loadingNotifier in your notifier file
      // If not, you'll need to create one
      valueListenable: loadingNotifier,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Scaffold(body: Center(child: Text('Loading')));
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
