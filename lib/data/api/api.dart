import 'package:tmdb_api/tmdb_api.dart';

final tmdb = TMDB(
  ApiKeys(
    'd0b01ccf131b0fae8606a7cdfe4ebfa9',
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMGIwMWNjZjEzMWIwZmFlODYwNmE3Y2RmZTRlYmZhOSIsInN1YiI6IjY4MjY0NmEzYmE3NDg2YjQyZDMxNTlmOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Cwkz8Oun9idR0_QpYsYKAHuznGo7sX9Rv9VhXcbDcmI',
  ),
);

Future<void> validToken() async {
  // set up for my watch list
  dynamic requestToken = await tmdb.v3.auth.createRequestToken(asMap: true);
  if (requestToken['success']) {
    print('requestToken: ${requestToken['request_token']}');
    try {
      Map validationUrl = {
        'request_token':
            'https://www.themoviedb.org/authenticate/${requestToken['request_token']}',
      };

      print('validationUrl: ${validationUrl['request_token']}');
    } catch (e) {
      print(e);
    }
  }
}

Future<Map> watchList(TMDB tmdb, requestToken) async {
  Map customAccountWatchList = {'results': []};
  // dynamic sessionId = await tmdb.v3.auth.createSession(
  //   // requestToken['request_token'],
  //   '',
  //   asMap: true,
  // );
  // if (sessionId['success']) {
  if (true) {
    // print('sessionId: ${sessionId['session_id']}');
    Map accountWatchList = await tmdb.v3.account.getMovieWatchList(
      // sessionId['session_id'],
      'e4d8fec9cc32e31c1fa54c3fc873680539a3f780',
      22013035,
      language: 'en',
      page: 1,
    );
    if (accountWatchList.isNotEmpty) {
      for (var i = 0; i < accountWatchList['results'].length; i++) {
        Map movieDetail = await tmdb.v3.movies.getDetails(
          accountWatchList['results'][i]['id'],
        );
        {
          customAccountWatchList['results'].add(movieDetail);
        }
      }
    }
  }
  return customAccountWatchList;
}
