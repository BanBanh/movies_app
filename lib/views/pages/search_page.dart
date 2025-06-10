import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/data/api/search.dart';
import 'package:movies_app/data/notifier.dart';
import 'package:movies_app/views/pages/detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // search bar
        Container(
          width: MediaQuery.of(context).size.width - 48,
          height: 42,
          padding: EdgeInsets.only(left: 25, right: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(0xFF3A3F47),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 27,
                child: TextField(
                  controller: searchTextController,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Color(0xFF67686D)),
                  ),
                  onSubmitted: _searchMovies,
                ),
              ),
              GestureDetector(
                child: Icon(Icons.search, color: Color(0xFF67686D)),
                onTap: _searchMoviess,
              ),
            ],
          ),
        ),
        // search results
        ValueListenableBuilder(
          valueListenable: searchResultsNotifier,
          builder: (BuildContext context, searchResults, Widget? child) {
            if (isLoading) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 3),
                    CircularProgressIndicator.adaptive(),
                  ],
                ),
              );
            } else {
              if (isSearched) {
                if (searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                        Image.asset(
                          width: 76,
                          height: 76,
                          fit: BoxFit.contain,
                          'assets/images/no-results.png',
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
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            searchResults.map((movie) {
                              if (movie.runtime == null || movie.runtime == 0) {
                                return SizedBox.shrink();
                              }
                              try {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DetailPage(movie.id),
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
                                              MediaQuery.of(
                                                context,
                                              ).size.width /
                                              375 *
                                              95,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.width /
                                              375 *
                                              120,
                                          margin: EdgeInsets.only(right: 12),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Image.network(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  375 *
                                                  95,
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  375 *
                                                  120,
                                              fit: BoxFit.fill,
                                              movie.posterPath,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  color: Colors.white,
                                                  child: Center(
                                                    child: Text('no image'),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                movie.title == ''
                                                    ? 'no tittle'
                                                    : movie.title,
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
                                                  '${movie.voteAverage == null ? 0.0 : movie.voteAverage?.toStringAsFixed(1)}',
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
                                                  Icons
                                                      .confirmation_num_outlined,
                                                  size: 16,
                                                  color: Color(0xFFEEEEEE),
                                                ),
                                                Text(
                                                  movie.firstGenreName ??
                                                      'no genre',
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
                                                  '${movie.releaseDate == null ? 'no release date' : movie.releaseDate?.substring(0, 4)}',
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
                              return Container();
                            }).toList(),
                      ),
                    ),
                  );
                }
              } else {
                return Container();
              }
            }
          },
        ),
      ],
    );
  }

  void _searchMoviess() async {
    if (searchTextController.text.isEmpty) {
      setState(() {
        isSearched = false;
      });
    } else {
      setState(() {
        isSearched = true;
        isLoading = true;
      });
      await searchMovies();
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        isLoading = false;
      });
    }
  }

  void _searchMovies(_) async {
    _searchMoviess();
  }
}

AppBar searchPageAppBar = AppBar(
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
    'Search',
    style: GoogleFonts.montserrat(
      color: Color(0xFFECECEC),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
  actions: [
    IconButton(
      onPressed: () {},
      icon: RotatedBox(
        child: Icon(Icons.info_outline, color: Colors.white, size: 20),
        quarterTurns: 2,
      ),
    ),
  ],
);
