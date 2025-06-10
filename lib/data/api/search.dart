import 'package:flutter/material.dart';
import 'package:movies_app/data/api/api.dart';
import 'package:movies_app/data/api/models/movie.dart';

final searchTextController = TextEditingController();
ValueNotifier<List<Movie>> searchResultsNotifier = ValueNotifier([]);
Future<void> searchMovies() async {
  final String query = searchTextController.text;
  if (searchTextController.text.isEmpty) {
  } else {
    try {
      // Step 1: Search movies
      final searchResults = await tmdb.v3.search.queryMovies(query);
      final movies =
          (searchResults['results'] as List).map((movie) {
            print('successfully get movies and add to movies');
            return Movie.fromData(movie);
          }).toList();

      // Step 2: Fetch details for each movie to get genre names
      final detailedMovies = await Future.wait(
        movies.map((movie) => enrichMovieWithDetails(movie)),
      );
      searchResultsNotifier.value = detailedMovies;
    } catch (e) {
      print('Search failed: $e');
    }
  }
}

Future<Movie> enrichMovieWithDetails(Movie movie) async {
  print('trying to get details');
  try {
    final details = await tmdb.v3.movies.getDetails(movie.id);
    final genres = (details['genres'] as List?)?.cast<Map<String, dynamic>>();
    final firstGenre = genres?.isNotEmpty == true ? genres![0]['name'] : null;
    print('get details successful');
    return Movie(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      voteAverage: movie.voteAverage,
      firstGenreName: firstGenre,
      releaseDate: details['release_date'],
      runtime: details['runtime'],
    );
  } catch (e) {
    print(e);
  }
  return Movie(id: 0, title: '', posterPath: '');
}
