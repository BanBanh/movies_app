class Movie {
  final int id;
  final String title;
  final String posterPath;
  final double? voteAverage;
  final String? firstGenreName; // Replaces genre_ids
  final String? releaseDate;
  final int? runtime;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.voteAverage,
    this.firstGenreName,
    this.releaseDate,
    this.runtime,
  });

  factory Movie.fromData(Map<dynamic, dynamic> data) {
    return Movie(
      id: data['id'],
      title: data['title'] ?? 'Untitled',
      posterPath: 'https://image.tmdb.org/t/p/w500${data['poster_path']}',
      voteAverage: data['vote_average']?.toDouble(),
      firstGenreName: null, // Will be set later via getDetails()
      releaseDate: data['release_date'],
      runtime: data['runtime'],
    );
  }
}
