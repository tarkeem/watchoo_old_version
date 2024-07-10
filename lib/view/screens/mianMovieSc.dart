import 'package:carousel_slider/carousel_slider.dart';
import 'package:elastic_drawer/elastic_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'package:watchoo/constanst.dart';
import 'package:watchoo/controller/filmsLogic.dart';
import 'package:watchoo/model/film.dart';
import 'package:watchoo/view/screens/SearchSc.dart';
import 'package:watchoo/view/screens/categoriesSc.dart';
import 'package:watchoo/view/screens/favoriteSc.dart';
import 'package:watchoo/view/screens/filmPage.dart';
import 'package:watchoo/view/screens/movieInfoSc.dart';
import 'package:watchoo/view/widgets/MySnackBar.dart';
import 'package:watchoo/view/widgets/listTileDrawer.dart';
import 'package:glass/glass.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:watchoo/view/widgets/ratedStars.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

List<Movie> _moviesList = [];

class _mainPageState extends State<mainPage> {
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<MoviesLogic>(context, listen: false)
        .fetchMovies()
        .then((value) {
      setState(() {
        _isLoading = false;
        _moviesList =
            Provider.of<MoviesLogic>(context, listen: false).mianMovies;
      });
    });
  }

  int tapIndex = 0;
  @override
  Widget build(BuildContext context) {
     
    var deviceSize = MediaQuery.of(context).size;
    List<Widget> navElement=[homeScreen(),favoriteScreen(),searchScreen()];
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 11, 24),
        body: ElasticDrawer(
          markPosition: 0.5,
          markWidth: 1,
          mainColor: Colors.transparent,
          drawerColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
          drawerChild: const categoriesc(),
          mainChild: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child:navElement[tapIndex]
                    ),
                    Positioned(
                        bottom: 0, left: 0, right: 0, child: bottomNavigation())
                  ],
                ),
        ));
  }



  
  Container bottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: GNav(
          onTabChange: (value) {
            setState(() {
              tapIndex = value;
            });
          },
          haptic: true, // haptic feedback
          tabBorderRadius: 15,
          tabActiveBorder:
              Border.all(color: Colors.black, width: 1), // tab button border
          tabBorder:
              Border.all(color: Colors.grey, width: 1), // tab button border
          tabShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
          ], // tab button shadow
          curve: Curves.easeOutExpo, // tab animation curves
          duration: const Duration(milliseconds: 900), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Colors.white, // unselected icon color
          activeColor: Colors.blue, // selected icon and text color
          iconSize: 24, // tab button icon size
          tabBackgroundColor:
              Colors.purple.withOpacity(0.1), // selected tab background color
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 5), // navigation bar padding
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.favorite,
              text: 'Likes',
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            )
          ]),
    );
  }
}


class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

 
  int currentMovieIdx = 0;
  @override
  Widget build(BuildContext context) {
    var deviceSize=MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topPart(deviceSize),
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                       Provider.of<MoviesLogic>(context, listen: false)
        .fetchMovies().then((value) {setState(() {
          
        });});
                    },
                    child: Text(
                      'Recently',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                ),
                middlePart(deviceSize),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Trending',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                ),
                bottomPart()
              ],
            ),
          ),
        ),
      ],
    );
  }

  SizedBox topPart(Size deviceSize) {
    return SizedBox(
      height: deviceSize.height * 0.5,
      width: deviceSize.width,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: SizedBox(
                key: Key(currentMovieIdx.toString()),
                height: deviceSize.height * 0.5,
                width: deviceSize.width,
                child: Image.network(
                  _moviesList[currentMovieIdx].img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.transparent,
              Colors.transparent,
              const Color.fromARGB(255, 15, 11, 24).withOpacity(0.4),
              const Color.fromARGB(255, 15, 11, 24).withOpacity(0.7),
              const Color.fromARGB(255, 15, 11, 24).withOpacity(0.9),
              const Color.fromARGB(255, 15, 11, 24),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      _moviesList[currentMovieIdx].name,
                      style:
                          GoogleFonts.akatab(color: Colors.white, fontSize: 30),
                    ),
                    const Spacer(),
                    IconButton(onPressed: () {
                    showSnackBar(Colors.green,"Add To Favorite", context);
                    }, icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 30,
                    ),),
                    const SizedBox(
                      width: 6,
                    ),
                    const Icon(
                      Icons.share,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ],
                ),
              )),
          Positioned(
            top: 25,
            child: ratedStar(star:int.parse(_moviesList[currentMovieIdx].rate)))
        ],
      ),
    );
  }

  CarouselSlider bottomPart() {
    return CarouselSlider(
      
      items: _moviesList.map((e) {
        return LayoutBuilder(
          builder: (p0, p1) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: p1.maxHeight,
            width: p1.maxWidth,
            child: Image.network(
              e.img,
              fit: BoxFit.fill,
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        initialPage: 3,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.zoom),
    );
  }

  SizedBox middlePart(Size deviceSize) {
    return SizedBox(
      height: deviceSize.height * 0.5,
      child: Swiper(
        onIndexChanged: (value) {
          setState(() {
            currentMovieIdx = value;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => movieInfoSc(_moviesList[index]),
                ));
              },
              child: Image.network(_moviesList[index].img));
        },
        itemCount: _moviesList.length,
        itemWidth: deviceSize.width * 0.35,
        layout: SwiperLayout.STACK,
      ),
    );
  }
}