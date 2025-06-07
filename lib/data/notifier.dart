import 'package:flutter/material.dart';
import 'package:movies_app/data/api/models/movie.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<String> selectedCategory = ValueNotifier('Now Playing');
ValueNotifier<bool> loadingNotifier = ValueNotifier<bool>(true);
ValueNotifier<List<Movie>> watchListMoviesNotifier = ValueNotifier<List<Movie>>(
  [],
);
