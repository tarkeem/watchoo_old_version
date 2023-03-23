import 'package:carousel_slider/carousel_slider.dart';
import 'package:elastic_drawer/elastic_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'package:watchoo/model/film.dart';
import 'package:watchoo/view/screens/categoriesSc.dart';
import 'package:watchoo/view/screens/filmPage.dart';
import 'package:watchoo/view/screens/movieInfoSc.dart';
import 'package:watchoo/view/widgets/listTileDrawer.dart';

class mainPage extends StatefulWidget {
  mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

List<Movie> _moviesList = List.generate(
    10,
    (index) => Movie(
        name: 'All Quite',
        img: 'movie.jpg',
        duration: '1:30:7',
        article: '''
All Quiet on the Western Front (German: Im Westen nichts Neues (lit. "In the West nothing new")) is a 2022 German-language epic anti-war film based on the 1929 novel of the same name by Erich Maria Remarque. It is the third film adaptation of the book, after the 1930 and 1979 versions. Directed by Edward Berger, it stars Felix Kammerer, Albrecht Schuch, Daniel Brühl, Sebastian Hülk, Aaron Hilmer, Edin Hasanovic, and Devid Striesow.

Set during World War I, it follows the life of an idealistic young German soldier named Paul Bäumer. After enlisting in the German Army with his friends, Bäumer finds himself exposed to the realities of war, shattering his early hopes of becoming a hero as he does his best to survive. The film adds a parallel storyline not found in the book, which follows the armistice negotiations to end the war.

All Quiet on the Western Front premiered at the Toronto International Film Festival on September 12, 2022, and was released to streaming on Netflix on October 28.[3] The film received positive reviews from critics, with praise directed towards its tone and faithfulness to the source material's anti-war message.[4] It received a leading 14 nominations at the 76th British Academy Film Awards (winning seven, including Best Film) and nine at the 95th Academy Awards, including Best Picture, and won four: Best International Feature, Best Cinematography, Best Original Score, and Best Production Design. The four wins tied All Quiet on the Western Front with Fanny and Alexander (1982), Crouching Tiger, Hidden Dragon (2000), and Parasite (2019) as the most-awarded foreign language film in the Oscars' history.[5]
''',
        movieUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        cast: []));

class _mainPageState extends State<mainPage> {
  Movie _selected = _moviesList[0];

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: ElasticDrawer(
          markWidth: 1,
          mainColor: Colors.black,
          drawerColor: Colors.transparent,
          drawerChild: categoriesc(),
          mainChild: Column(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                        height: deviceSize.height / 2,
                        left: 0,
                        right: 0,
                        child: AnimatedSwitcher(
                            duration: Duration(seconds: 1),
                            child: _topPart(
                                key: Key(_selected.article),
                                movie: _selected))),
                    Positioned(
                        height: 100,
                        top: deviceSize.height / 2 - (100 / 3),
                        left: 0,
                        right: 0,
                        child: _middlePart((int idx) {
                          setState(() {
                            _selected = _moviesList[idx];
                          });
                        }))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  flex: 2,
                  child: CarouselSlider(
                    items: _moviesList.map((e) {
                      return LayoutBuilder(
                        builder: (p0, p1) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: p1.maxHeight,
                          width: p1.maxWidth,
                          child: Image.asset(
                            e.img,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(),
                  ))
            ],
          ),
        ));
  }
}

class _topPart extends StatefulWidget {
  Movie movie;
  _topPart({super.key, required this.movie});

  @override
  State<_topPart> createState() => __topPartState();
}

class __topPartState extends State<_topPart>
    with SingleTickerProviderStateMixin {
  double _movement = -100;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10))
          ..repeat(reverse: true);
    //_controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.0,
      child: Container(
        /*decoration: BoxDecoration(
          border: Border.all(color: Colors.red)
        ),*/
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Stack(
            fit: StackFit.expand,
            //when clipbehavior=clip.none it  allow that the children of stack to  extend oout of it
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                  left: _movement * (1 - _controller.value),
                  right: _movement * _controller.value,
                  child: Image.asset(
                    widget.movie.img,
                    fit: BoxFit.fill,
                  )),
              Positioned.fill(
                  left: _movement * (1 - _controller.value),
                  right: _movement * _controller.value,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FadeTransition(
                          opacity: animation,
                          child: movieInfoSc(widget.movie),
                        ),
                      ));
                    },
                    child: Image.asset(
                      widget.movie.img,
                      fit: BoxFit.cover,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _middlePart extends StatefulWidget {
  Function ontab;
  _middlePart(this.ontab);

  @override
  State<_middlePart> createState() => _middlePartState();
}

class _middlePartState extends State<_middlePart> {
  late ScrollController _scrollController;
  final _key = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController()..addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _key,
      initialItemCount: 10,
      scrollDirection: Axis.horizontal,
      physics: ScrollPhysics(),
      controller: _scrollController,
      itemBuilder: (context, index, animation) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: () {
                /*movieies.insert(movieies.length, movieies[index]);
                _key.currentState!.insertItem(movieies.length - 1);*/

                widget.ontab(index);

                /* _key.currentState!.removeItem(
                    index,
                    (context, animation) => FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            axis: Axis.horizontal,
                            sizeFactor: animation,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                movieies[index].backGround,
                                fit: BoxFit.cover,
                                height: 100,
                                width: 70,
                              ),
                            ),
                          ),
                        ));
                           movieies.removeAt(index);*/
              },
              child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(vector.radians(45 * 0)),
                  child: Image.asset(
                    _moviesList[index].img,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 70,
                  ))),
        );
      },
    );
  }
}
