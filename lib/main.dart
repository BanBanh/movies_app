import 'package:flutter/material.dart';
import 'package:movies_app/data/api/movie_lists.dart';
import 'package:movies_app/views/widget_tree.dart';

Future<void> main() async {
  initializeMovieLists();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
        scaffoldBackgroundColor: Color(0xFF242A32),
        navigationBarTheme: NavigationBarThemeData(),
        highlightColor: Color(0xFF0296E5),
      ),
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
    );
  }
}

// TODO: watchlist save on local
// image place holder for poster image
