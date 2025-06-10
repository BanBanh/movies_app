import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/data/api/movie_lists.dart';
import 'package:movies_app/data/api/search.dart';
import 'package:movies_app/data/notifier.dart';
import 'package:movies_app/views/pages/detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'What do you want to watch?',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 24),
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
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Color(0xFF67686D)),
                        ),
                        onSubmitted: (_) => searchMovies(),
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.search, color: Color(0xFF67686D)),
                      onTap: () {
                        selectedPageNotifier.value = 1;
                        searchMovies();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 21),
              // 5 popular movies
              SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                height: 250,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CarouselItem(0),
                      SizedBox(width: 24),
                      CarouselItem(1),
                      SizedBox(width: 24),
                      CarouselItem(2),
                      SizedBox(width: 24),
                      CarouselItem(3),
                      SizedBox(width: 24),
                      CarouselItem(4),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // select category
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategorySelection('Now Playing'),
                    SizedBox(width: 12),
                    CategorySelection('Upcoming'),
                    SizedBox(width: 12),
                    CategorySelection('Top Rated'),
                    SizedBox(width: 12),
                    CategorySelection('Popular'),
                  ],
                ),
              ),

              // 6 categorized movies
              SizedBox(height: 20),
              Row(
                children: [
                  CategorizedItem(0),
                  SizedBox(width: 13),
                  CategorizedItem(1),
                  SizedBox(width: 13),
                  CategorizedItem(2),
                ],
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  CategorizedItem(3),
                  SizedBox(width: 13),
                  CategorizedItem(4),
                  SizedBox(width: 13),
                  CategorizedItem(5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  const CarouselItem(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(movieLists['Popular']![index].id),
          ),
        );
      },
      child: SizedBox(
        height: 250,
        width: 155,
        child: Stack(
          children: [
            // movies img
            Positioned(
              left: 10.06,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  fit: BoxFit.fill,
                  width: 144.61,
                  height: 210,
                  movieLists['Popular']![index].posterPath,
                ),
              ),
            ),
            // numbers
            Positioned(
              top: 133.05,
              // outer border
              child: Text(
                '${index + 1}',
                style: GoogleFonts.montserrat(
                  fontSize: 96,
                  fontWeight: FontWeight.w600,
                  foreground:
                      Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.5
                        ..color = Color(0xFF0296E5),
                ),
              ),
            ),
            Positioned(
              top: 133.05,
              // inner fill
              child: Text(
                '${index + 1}',
                style: GoogleFonts.montserrat(
                  fontSize: 96,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorizedItem extends StatelessWidget {
  const CategorizedItem(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedCategory,
      builder: (context, value, child) {
        final width = (MediaQuery.of(context).size.width - 48 - 13 - 13) / 3;
        final height = width / 100 * 146;
        return SizedBox(
          width: width,
          height: height,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DetailPage(movieLists[value]![index].id),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                fit: BoxFit.fill,
                movieLists[value]![index].posterPath,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategorySelection extends StatelessWidget {
  const CategorySelection(this.string, {super.key});
  final String string;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectedCategory.value = string;
      },
      child: Container(
        constraints: BoxConstraints(minWidth: 77),
        child: Column(
          children: [
            Text(string, style: GoogleFonts.poppins(color: Colors.white)),
            SizedBox(height: 12),
            Container(
              width: 77,
              height: 4,
              color:
                  selectedCategory.value == string
                      ? Color(0xFF3A3F47)
                      : Color(0xFF242A32),
            ),
          ],
        ),
      ),
    );
  }
}
