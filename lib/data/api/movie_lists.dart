import 'package:movies_app/data/api/api.dart';
import 'package:movies_app/data/api/models/movie.dart';
import 'package:movies_app/data/notifier.dart';

final Map<String, List<Movie>> movieLists = {
  'Now Playing': [],
  'upcoming': [],
  'topRated': [],
  'popular': [],
};

// Initialize all movie lists
Future<void> initializeMovieLists() async {
  // Fetch and populate all lists
  await Future.wait([
    _fetchList('Now Playing', tmdb.v3.movies.getNowPlaying()),
    _fetchList('Upcoming', tmdb.v3.movies.getUpcoming()),
    _fetchList('Top Rated', tmdb.v3.movies.getTopRated()),
    _fetchList('Popular', tmdb.v3.movies.getPopular()),
  ]);
  loadingNotifier.value = await Future.delayed(
    Duration(seconds: 1),
    () => false,
  );
  ;
}

// Helper to fetch and parse a single list
Future<void> _fetchList(
  String key,
  Future<Map<dynamic, dynamic>> apiCall,
) async {
  final response = await apiCall;
  movieLists[key] =
      (response['results'] as List)
          .map((movie) => Movie.fromData(movie))
          .toList();
}
