import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/data/api/api.dart';
import 'package:movies_app/data/api/models/watchlist.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(this.id, {super.key});
  final int id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

int selectedContent = 0;
double rateValue = 5;
Map<dynamic, dynamic> details = {};
Map<dynamic, dynamic> reviews = {};
Map<dynamic, dynamic> credits = {};
dynamic personImg;

class _DetailPageState extends State<DetailPage> {
  late Future<bool> _loaded;

  @override
  void initState() {
    super.initState();
    int id = widget.id;
    _getInfo(id);
    // Make time for data to fletch
    _loaded = Future.delayed(Duration(milliseconds: 700), () => true);
  }

  Future<void> _getInfo(id) async {
    Map<dynamic, dynamic> getDetails = await tmdb.v3.movies.getDetails(id);
    Map<dynamic, dynamic> getReviews = await tmdb.v3.movies.getReviews(id);
    Map<dynamic, dynamic> getCredits = await tmdb.v3.movies.getCredits(id);
    setState(() {
      details = getDetails;
      reviews = getReviews;
      credits = getCredits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242A32),
      appBar: AppBar(
        backgroundColor: Color(0xFF242A32),
        toolbarHeight: 66,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20,
            color: Colors.white,
            weight: 300,
          ),
        ),
        title: Text(
          'Detail',
          style: GoogleFonts.montserrat(
            color: Color(0xFFECECEC),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              //TODO: add watch list
              addToWatchlist(movieId: widget.id);
            },
            icon: Icon(Icons.bookmark, color: Color(0xFFEEEEEE)),
          ),
        ],
      ),
      // body: mainBody(),
      body: FutureBuilder<bool>(
        future: _loaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == true) {
            return mainBody(); // Actual content
          }
          return Center(
            child: Text(
              'Loading',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ); // loading
        },
      ),
    );
  }

  SingleChildScrollView mainBody() {
    double screenWidth = MediaQuery.of(context).size.width;
    double sizedScreenWidth = MediaQuery.of(context).size.width / 375;
    double backdropWidth = screenWidth;
    double backdropHeight = sizedScreenWidth * 210.94;
    double posterWidth = sizedScreenWidth * 95;
    double posterHeight = sizedScreenWidth * 120;
    double posterPositionLeft = sizedScreenWidth * 29;
    double posterPositionTop =
        sizedScreenWidth * 210.94 - sizedScreenWidth * 59.94;
    double tittlePositionLeft = sizedScreenWidth * 136;
    double tittlePositionTop = sizedScreenWidth * 223;
    double tittleMarginRight = sizedScreenWidth * 29;

    String imagePath = 'https://image.tmdb.org/t/p/original';
    String backdropPath = imagePath + details['backdrop_path'];
    String posterPath = imagePath + details['poster_path'];
    return SingleChildScrollView(
      child: Column(
        children: [
          // backdrop, poster, vote average, tittle
          SizedBox(
            height: sizedScreenWidth * 271,
            child: Stack(
              children: [
                // Backdrop
                Positioned(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      backdropPath,
                      width: backdropWidth,
                      height: backdropHeight,
                    ),
                  ),
                ),
                // Poster
                Positioned(
                  left: posterPositionLeft,
                  top: posterPositionTop,
                  width: posterWidth,
                  height: posterHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(fit: BoxFit.fill, posterPath),
                  ),
                ),
                // tittle
                Positioned(
                  left: tittlePositionLeft,
                  top: tittlePositionTop,
                  child: Container(
                    width: sizedScreenWidth * 210,
                    padding: EdgeInsets.only(right: tittleMarginRight),
                    child: Text(
                      '${details['title']}',
                      softWrap: true,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                // rating
                Positioned(
                  right: 11,
                  top: sizedScreenWidth * 178,
                  child: Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          // TODO: add rating
                          //https://api.themoviedb.org/3/movie/{movie_id}/rating
                          // tmdb.v3.movies.rateMovie(movieId, ratingValue)
                          Scaffold.of(context).showBottomSheet((context) {
                            return StatefulBuilder(
                              builder: (
                                BuildContext context,
                                StateSetter setState,
                              ) {
                                return Stack(
                                  children: [
                                    Positioned(
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Color.fromRGBO(0, 0, 0, 0.45),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                          24,
                                          23,
                                          24,
                                          12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(24),
                                            topRight: Radius.circular(24),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                'Rate this movie',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  wordSpacing: 0.75,
                                                  color: Color(0xFF4E4B66),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 19),
                                            SizedBox(
                                              height: 34,
                                              child: Text(
                                                '${rateValue.toInt()}',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w400,
                                                  wordSpacing: 0.75,
                                                  color: Color(0xFF4E4B66),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 19),
                                            Slider(
                                              max: 10,
                                              min: 0,
                                              divisions: 10,
                                              thumbColor: Color(0xFFFF8700),
                                              activeColor: Color(0xFFFF8700),
                                              inactiveColor: Color(0xFFD9DBE9),
                                              label: '${rateValue.toInt()}',
                                              value: rateValue,
                                              onChanged:
                                                  (value) => setState(
                                                    () => rateValue = value,
                                                  ),
                                            ),
                                            SizedBox(height: 19),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Color(
                                                  0xFF0296E5,
                                                ),
                                                fixedSize: Size(220, 56),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                tmdb.v3.movies.rateMovie(
                                                  widget.id,
                                                  rateValue,
                                                );
                                              },
                                              child: Text(
                                                'OK',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  wordSpacing: 0.75,
                                                  color: Color(0xFFFCFCFC),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        },
                        child: Container(
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromRGBO(0, 0, 0, 0.7),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_border_rounded,
                                color: Color(0xFFFF8700),
                                size: 16,
                              ),
                              Text(
                                '${details['vote_average'].toStringAsFixed(1)}',
                                style: GoogleFonts.montserrat(
                                  color: Color(0xFFFF8700),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // release year, movie length, genre name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF92929D),
                size: 16,
              ),
              Text(
                ' ${details['release_date']?.substring(0, 4)}  |  ',
                style: GoogleFonts.montserrat(
                  color: Color(0xFF92929D),
                  fontSize: 12,
                ),
              ),
              Icon(Icons.schedule_rounded, color: Color(0xFF92929D), size: 16),
              Text(
                ' ${details['runtime']} Minutes  |  ',
                style: GoogleFonts.montserrat(
                  color: Color(0xFF92929D),
                  fontSize: 12,
                ),
              ),
              Icon(
                Icons.confirmation_num_outlined,
                color: Color(0xFF92929D),
                size: 16,
              ),
              Text(
                details['genres'] != null
                    ? details['genres'].length > 0
                        ? '${details['genres'][0]['name']}'
                        : ''
                    : '',
                style: GoogleFonts.montserrat(
                  color: Color(0xFF92929D),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          // About movie, review, cast
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // selections
              Padding(
                padding: const EdgeInsets.only(left: 27, bottom: 24),
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedContent = 0;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          constraints: BoxConstraints(minWidth: 77),
                          height: 41,
                          child: Column(
                            children: [
                              Text(
                                'About Movie',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              SizedBox(height: 12),
                              Container(
                                width: 77,
                                height: 4,
                                color:
                                    selectedContent == 0
                                        ? Color(0xFF3A3F47)
                                        : Color(0xFF242A32),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedContent = 1;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          constraints: BoxConstraints(minWidth: 77),
                          height: 41,
                          child: Column(
                            children: [
                              Text(
                                'Reviews',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              SizedBox(height: 12),
                              Container(
                                width: 77,
                                height: 4,
                                color:
                                    selectedContent == 1
                                        ? Color(0xFF3A3F47)
                                        : Color(0xFF242A32),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedContent = 2;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          constraints: BoxConstraints(minWidth: 77),
                          height: 41,
                          child: Column(
                            children: [
                              Text(
                                'Cast',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              SizedBox(height: 12),
                              Container(
                                width: 77,
                                height: 4,
                                color:
                                    selectedContent == 2
                                        ? Color(0xFF3A3F47)
                                        : Color(0xFF242A32),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // selected content
              switch (selectedContent) {
                0 => AboutMovie(details: details),
                1 => Review(details: details),
                2 => Cast(credits: credits),
                int() => throw UnimplementedError(),
              },
            ],
          ),
        ],
      ),
    );
  }
}

class AboutMovie extends StatelessWidget {
  const AboutMovie({super.key, required this.details});

  final dynamic details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Text(
        '${details?['overview']}',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class Review extends StatelessWidget {
  const Review({super.key, required this.details});

  final dynamic details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              reviews['results']?.length > 10 ? 10 : reviews['results']?.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(34, 0, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // profile pic, rate
                  Column(
                    children: [
                      // profile pic
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22.0),
                          child:
                              reviews['results']?[index]?['author_details']?['avatar_path'] ==
                                      null
                                  ? Center(child: Text('avatar'))
                                  : Image.network(
                                    fit: BoxFit.fill,
                                    'https://media.themoviedb.org/t/p/w45_and_h45_face${reviews['results']?[index]?['author_details']?['avatar_path']}',
                                  ),
                        ),
                      ),
                      SizedBox(height: 14),
                      // Rating
                      reviews['results']?[index]?['author_details']?['rating'] ==
                              null
                          ? Container()
                          : Text(
                            '${reviews['results']?[index]?['author_details']?['rating']}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Color(0xFF0296E5),
                            ),
                          ),
                    ],
                  ),
                  SizedBox(width: 12),
                  //profile name, review
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${reviews['results']?[index]?['author']}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${reviews['results']?[index]?['content']}',
                          maxLines: 4,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Cast extends StatelessWidget {
  const Cast({super.key, required this.credits});

  final dynamic credits;

  @override
  Widget build(BuildContext context) {
    double sizedScreenWidth = MediaQuery.of(context).size.width / 375;
    if (credits['cast'] == null) {
      return Container();
    } else {
      return Padding(
        padding: EdgeInsets.only(
          left: sizedScreenWidth * 29,
          right: sizedScreenWidth * 41,
        ),
        child: Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: sizedScreenWidth * 65,
              mainAxisSpacing: 0,
              childAspectRatio: 120 / 147,
            ),
            itemCount:
                credits['cast'] == null
                    ? 0
                    : credits?['cast']?.length > 4
                    ? 4
                    : credits?['cast']?.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        fit: BoxFit.fitWidth,
                        'https://image.tmdb.org/t/p/w138_and_h175_face${credits?['cast']?[index]['profile_path']}',
                      ),
                    ),
                  ),
                  Text(
                    '${credits?['cast']?[index]['name']}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }
  }
}
