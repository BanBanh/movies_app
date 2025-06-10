import 'package:movies_app/data/api/api.dart';
import 'package:movies_app/data/api/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _watchlistKey = 'user_watchlist';

Future<List<Movie>> getWatchList() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> watchlistIDs = prefs.getStringList(_watchlistKey) ?? [];
  List<Movie> watchListMovies = [];
  await Future.wait(
    watchlistIDs.map((movieId) async {
      final result = await tmdb.v3.movies.getDetails(int.parse(movieId));
      watchListMovies.add(Movie.fromData(result));
    }),
  );
  return watchListMovies;
}

Future<bool> addToWatchlist({required int movieId}) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> watchlistIDs = prefs.getStringList(_watchlistKey) ?? [];
  watchlistIDs.add(movieId.toString());
  prefs.setStringList(_watchlistKey, watchlistIDs);
  return true;
}

Future<bool> removeFromWatchList({required int movieId}) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> watchlistIDs = prefs.getStringList(_watchlistKey) ?? [];
  watchlistIDs.removeAt(watchlistIDs.indexOf(movieId.toString()));
  prefs.setStringList(_watchlistKey, watchlistIDs);
  return true;
}

Future<bool> isInWatchList({required int movieId}) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> watchlistIDs = prefs.getStringList(_watchlistKey) ?? [];
  return watchlistIDs.contains(movieId.toString());
}
