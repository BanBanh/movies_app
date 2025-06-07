import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/data/api/models/movie.dart';
import 'package:movies_app/data/api/models/watchlist.dart';
import 'package:movies_app/data/notifier.dart';
import 'package:movies_app/views/pages/detail_page.dart';

class WatchListPage extends StatefulWidget {
  const WatchListPage({super.key});

  @override
  State<WatchListPage> createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Movie>>(
      valueListenable: watchListMoviesNotifier,
      builder: (
        BuildContext context,
        List<Movie> watchListMovies,
        Widget? child,
      ) {
        if (watchListMovies.isEmpty) {
          return Center(
            child: Column(
              children: [
                Image.asset(
                  width: 76,
                  height: 76,
                  fit: BoxFit.contain,
                  'assets/images/magic-box.png',
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'There is no movie yet!',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFFEBEBEF),
                      letterSpacing: 0.12,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 375 * 252,
                  child: Text(
                    'Find your movie by Type title, categories, years, etc',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xFF92929D),
                      letterSpacing: 0.12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children:
                  watchListMovies.map((movie) {
                    // if (movie.firstGenreName == null) {
                    //   return Container(child: Text('error'));
                    // }
                    try {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(movie.id),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 32,
                            top: 24,
                            right: 36,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width /
                                    375 *
                                    95,
                                height:
                                    MediaQuery.of(context).size.width /
                                    375 *
                                    120,
                                margin: EdgeInsets.only(right: 12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    width:
                                        MediaQuery.of(context).size.width /
                                        375 *
                                        95,
                                    height:
                                        MediaQuery.of(context).size.width /
                                        375 *
                                        120,
                                    fit: BoxFit.fill,
                                    movie.posterPath,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      movie.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 14.5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_border_rounded,
                                        size: 16,
                                        color: Color(0xFFFF8700),
                                      ),
                                      Text(
                                        '${movie.voteAverage?.toStringAsFixed(1)}',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFFFF8700),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.confirmation_num_outlined,
                                        size: 16,
                                        color: Color(0xFFEEEEEE),
                                      ),
                                      Text(
                                        '${movie.firstGenreName}',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFFEEEEEE),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 16,
                                        color: Color(0xFFEEEEEE),
                                      ),
                                      Text(
                                        '${movie.releaseDate?.substring(0, 4)}',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFFEEEEEE),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule_rounded,
                                        size: 16,
                                        color: Color(0xFFEEEEEE),
                                      ),
                                      Text(
                                        '${movie.runtime}',
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFFEEEEEE),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } catch (e) {
                      print(e);
                    }
                    return Container(child: Text('error'));
                  }).toList(),
            ),
          );
        }
      },
    );
  }
}

AppBar watchListPageAppBar = AppBar(
  backgroundColor: Color(0xFF242A32),
  toolbarHeight: 66,
  centerTitle: true,
  leading: IconButton(
    onPressed: () {
      selectedPageNotifier.value = 0;
    },
    icon: Icon(
      Icons.arrow_back_ios_rounded,
      size: 20,
      color: Colors.white,
      weight: 300,
    ),
  ),
  title: Text(
    'watch list',
    style: GoogleFonts.montserrat(
      color: Color(0xFFECECEC),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
);
