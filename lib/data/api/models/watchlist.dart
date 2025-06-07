import 'dart:io';

import 'package:movies_app/data/api/api.dart';
import 'package:movies_app/data/api/models/movie.dart';
import 'package:movies_app/data/api/search.dart';
import 'package:tmdb_api/tmdb_api.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// const String _sessionIdKey = 'tmdb_session_id';
// const String _accountIdKey = 'tmdb_account_id';

// Future<String?> getSessionId() async {
//   final pref = await SharedPreferences.getInstance();
//   return pref.getString(_sessionIdKey);
// }

// Future<void> setSessionId(String sessionId) async {
//   final pref = await SharedPreferences.getInstance();
//   await pref.setString(_sessionIdKey, sessionId);
// }

// Future<void> setAccountId(String accountId) async {
//   final pref = await SharedPreferences.getInstance();
//   await pref.setString(_accountIdKey, accountId);
// }

// Future<String?> getAccountId() async {
//   final pref = await SharedPreferences.getInstance();
//   return pref.getString(_accountIdKey);
// }

// Future<void> clearSessionData() async {
//   final pref = await SharedPreferences.getInstance();
//   await pref.remove(_sessionIdKey);
//   await pref.remove(_accountIdKey);
// }

Future<String> createNewSession() async {
  try {
    // Step 1: Get a new request token
    final tokenResponse = await tmdb.v3.auth.createRequestToken(asMap: true);
    final requestToken = tokenResponse['request_token'];

    // Step 2: You need to implement how to authenticate this token
    // This typically requires user login via TMDB's authentication page
    // For mobile apps, you might use a WebView or deep link
    print(tmdb.v3.auth.getValidationUrl(requestToken));
    print('sleeping');
    sleep(Duration(seconds: 15));
    print('awake');

    // Step 3: Create session with the authenticated token
    final sessionResponse = await tmdb.v3.auth.createSession(
      requestToken,
      asMap: true,
    );

    if (sessionResponse['success'] == false) {
      print('sessionResponse fall');
      return createNewSession();
    } else {
      return sessionResponse['session_id'];
    }
    // newSessionId = sessionResponse['session_id'];

    // Store the new session ID
    // await setSessionId(newSessionId);

    // Get and store account ID
    // final accountResponse = await tmdb.v3.account.getDetails(newSessionId);
    // final accountId = accountResponse['id'].toString();
    // await setAccountId(accountId);

    // return newSessionId;
  } catch (e) {
    // print('Error creating new session: $e');
    rethrow;
  }
}

Future<String> getValidSessionId() async {
  // Try to get existing session ID
  // final existingSessionId = await getSessionId();

  // If no session exists or it's invalid, create a new one
  // if (existingSessionId == null) {
  String newSession = await createNewSession();
  print('newSession $newSession');
  return newSession;
  // }

  // Optionally: You could add validation of the existing session here
  // For simplicity, we'll assume the session is valid if it exists

  // return existingSessionId;
}

Future<List<Movie>> getWatchList() async {
  try {
    // Get valid session ID
    // final sessionId = await getValidSessionId();
    final sessionId = '70541171c662eaeeca6c95fd4e0fdba877d354f4';
    // final accountId = await getAccountId();
    final accountId = '22013035';

    // if (accountId == null) {
    //   throw Exception('Account ID not found');
    // }

    // Fetch watchList
    final watchListResponse = await tmdb.v3.account.getMovieWatchList(
      sessionId,
      int.parse(accountId),
    );

    // If response is empty, session might be expired - clear and retry
    if (watchListResponse['results'] == null ||
        (watchListResponse['results'] as List).isEmpty) {
      // await clearSessionData();
      return getWatchList();
    }

    // Parse movies from watch list
    final movies =
        (watchListResponse['results'] as List)
            .map((movie) => Movie.fromData(movie))
            .toList();
    //Fetch details for each movie to get genre names
    final detailedMovies = await Future.wait(
      movies.map((movie) => enrichMovieWithDetails(movie)),
    );
    return detailedMovies;
  } catch (e) {
    // print('Error fetching watchList: $e');
    // If any error occurs, clear session and try again once
    // await clearSessionData();
    return getWatchList();
  }
}

Future<void> addToWatchlist({required int movieId}) async {
  try {
    // Get valid session ID (will prompt auth if needed)
    // Get valid session ID
    // final sessionId = await getValidSessionId();
    final sessionId = '70541171c662eaeeca6c95fd4e0fdba877d354f4';
    // final accountId = await getAccountId();
    final accountId = '22013035';

    // if (accountId == null) {
    //   throw Exception('Account ID not found');
    // }

    // Make the API call to update watchlist
    await tmdb.v3.account.addToWatchList(
      sessionId,
      int.parse(accountId),
      movieId,
      MediaType.movie,
    );
  } catch (e) {
    null;
  }
}
