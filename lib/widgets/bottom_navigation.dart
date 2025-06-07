import 'package:flutter/material.dart';
import 'package:movies_app/data/api/models/watchlist.dart';

import '../data/notifier.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Container(
          height: 78,
          decoration: BoxDecoration(
            color: Color(0xFF242A32),
            border: BorderDirectional(
              top: BorderSide(color: Color(0xFF0296E5)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => selectedPageNotifier.value = 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      color:
                          selectedPage == 0
                              ? Color(0xFF0296E5)
                              : Color(0xFF67686D),
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        color:
                            selectedPage == 0
                                ? Color(0xFF0296E5)
                                : Color(0xFF67686D),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => selectedPageNotifier.value = 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search,
                      color:
                          selectedPage == 1
                              ? Color(0xFF0296E5)
                              : Color(0xFF67686D),
                    ),
                    Text(
                      'Search',
                      style: TextStyle(
                        color:
                            selectedPage == 1
                                ? Color(0xFF0296E5)
                                : Color(0xFF67686D),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  watchListMoviesNotifier.value = await getWatchList();
                  selectedPageNotifier.value = 2;
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      color:
                          selectedPage == 2
                              ? Color(0xFF0296E5)
                              : Color(0xFF67686D),
                    ),
                    Text(
                      'Watch list',
                      style: TextStyle(
                        color:
                            selectedPage == 2
                                ? Color(0xFF0296E5)
                                : Color(0xFF67686D),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
