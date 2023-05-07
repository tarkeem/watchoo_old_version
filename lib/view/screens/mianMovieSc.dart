import 'package:carousel_slider/carousel_slider.dart';
import 'package:elastic_drawer/elastic_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'package:watchoo/controller/filmsLogic.dart';
import 'package:watchoo/model/film.dart';
import 'package:watchoo/model/fontStyle.dart';
import 'package:watchoo/view/screens/categoriesSc.dart';
import 'package:watchoo/view/screens/filmPage.dart';
import 'package:watchoo/view/screens/movieInfoSc.dart';
import 'package:watchoo/view/widgets/listTileDrawer.dart';
import 'package:glass/glass.dart';

class mainPage extends StatefulWidget {
  mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

List<Movie> _moviesList = [];

class _mainPageState extends State<mainPage> {
  late Movie _selected;
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
        _selected = _moviesList[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
          color: Colors.black,
        )),
        Positioned(
          top: 0,
          left: 0,
            child: Container(
              width: 300,
              height: 300,
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(

                blurRadius: 200,
                color: Colors.red,
                spreadRadius: 30,
                blurStyle: BlurStyle.normal)
          ]),
        )),
        Positioned(
          bottom: 0,
          right: 0,
            child: Container(
              width: 300,
              height: 300,
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(

                blurRadius: 200,
                color: Colors.pink,
                spreadRadius: 30,
                blurStyle: BlurStyle.normal)
          ]),
        )),
         Positioned(
          top: 0,
          right: 0,
            child: Container(
              width: 300,
              height: 300,
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(

                blurRadius: 200,
                color: Colors.blue,
                spreadRadius: 30,
                blurStyle: BlurStyle.normal)
          ]),
        )),
         Positioned(
          bottom: 0,
          left: 0,
            child: Container(
              width: 300,
              height: 300,
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(

                blurRadius: 200,
                color: Colors.yellow,
                spreadRadius: 30,
                blurStyle: BlurStyle.normal)
          ]),
        )),
        Positioned.fill(child: Container().asGlass()),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: ElasticDrawer(
              markWidth: 1,
              mainColor: Colors.transparent,
              drawerColor: Colors.brown.withOpacity(0.3),
              drawerChild: categoriesc(),
              mainChild: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            SlideTransition(
                                          position: animation.drive(Tween(
                                              begin: Offset(1, 0),
                                              end: Offset(0, 0))),
                                          child:
                                              movieInfoSc(_moviesList[index]),
                                        ),
                                      ));
                                    },
                                    child:
                                        Image.network(_moviesList[index].img));
                              },
                              itemCount: _moviesList.length,
                              itemWidth: deviceSize.width * 0.35,
                              layout: SwiperLayout.STACK,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Movies of this Week',
                          style: BigFont(Color.fromARGB(255, 0, 0, 0), 30),
                        ),
                        Expanded(
                            flex: 2,
                            child: CarouselSlider(
                              items: _moviesList.map((e) {
                                return LayoutBuilder(
                                  builder: (p0, p1) => Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
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
                                  enlargeCenterPage: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.zoom),
                            ))
                      ],
                    ),
            )),
      ],
    );
  }
}
