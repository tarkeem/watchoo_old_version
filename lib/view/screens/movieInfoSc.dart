import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'package:watchoo/model/film.dart';
import 'package:watchoo/model/fontStyle.dart';
import 'package:watchoo/view/screens/filmPage.dart';
import 'package:watchoo/view/screens/mianMovieSc.dart';

class movieInfoSc extends StatefulWidget {
  Movie movie;
  movieInfoSc(this.movie);

  @override
  State<movieInfoSc> createState() => _movieInfoScState();
}

class _movieInfoScState extends State<movieInfoSc>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(child:Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black,Colors.brown])
          ),
        ) ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(0, 131, 42, 42),),
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _appbar(
                    deviceSize: deviceSize,
                    maxExtend: deviceSize.height * 0.35,
                    minExtend: kToolbarHeight,
                    movie: widget.movie),
              ),
              SliverToBoxAdapter(
                child: _body(widget.movie),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _appbar extends SliverPersistentHeaderDelegate {
  double minExtend, maxExtend;
  var deviceSize;
  Movie movie;
  _appbar(
      {required this.deviceSize,
      required this.maxExtend,
      required this.minExtend,
      required this.movie});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double perc = shrinkOffset / maxExtend;
    return Container(
      color: Colors.red,
      child: Stack(
        children: [
          Positioned.fill(
              /*bottom: 0,
              left: 0,
              right: 0,
              top: 0,*/
              child: Image.network(
            movie.img,
            fit: BoxFit.cover,
          )),
          if (25 / 100 >= perc) ...[
            _bottomBar(perc, movie),
            _cardPic(perc,movie)
          ] else ...[
            _cardPic(perc,movie),
            _bottomBar(perc, movie)
          ]
        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => maxExtend;

  @override
  // TODO: implement minExtent
  double get minExtent => minExtend;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}

class _body extends StatelessWidget {
  Movie movie;
  _body(this.movie);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          movie.article,
          style:BigFont(Colors.white, 15).copyWith(fontFamily:null),
        )
      ],
    );
  }
}

class _cardPic extends StatelessWidget {
  double perc;
  Movie movie;
  _cardPic(this.perc,this.movie);

  double maxPerc = 25 / 100;

  @override
  Widget build(BuildContext context) {
    print(perc);
    double valueBack = (1 - perc * 2).clamp(0, 2);
    var deviceSize = MediaQuery.of(context).size;
    return Positioned(
        top: deviceSize.height * 0.15,
        left: deviceSize.width / 24,
        child: Transform(
          alignment: Alignment.topRight,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateZ(
                vector.radians(0.25 < perc ? valueBack * 2 * 45 : perc * 90)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              movie.img,
              height: deviceSize.height * 0.20,
              width: deviceSize.width * 0.20,
            ),
          ),
        ));
  }
}

class _bottomBar extends StatelessWidget {
  double perc;
  Movie _movie;
  _bottomBar(this.perc, this._movie);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    /* double fixRotation = pow(perc, 1.5).toDouble();
    double fixRotation2 = pow(perc, -1.5).toDouble();*/
    return Positioned(
        bottom: 0,
        left: deviceSize.width *
            (0.25 < perc
                ? lerpDouble(0, 0.8, (0.65 - (perc).clamp(0, 0.65)))!
                    .toDouble()
                : lerpDouble(0, 0.8, perc)!.toDouble()),
        child: Container(
          //color: Colors.blue,
          height: deviceSize.height * 0.12,
          width: deviceSize.width,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _cuteRectangle(),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                      opacity: 1,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius:BorderRadius.circular(20))),
                            backgroundColor:
                                MaterialStateProperty.all(Color.fromARGB(255, 245, 255, 54))),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Watch now',
                                              
                            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    FadeTransition(
                              opacity: animation,
                              child: filmPage(_movie),
                            ),
                          ));
                        },
                      )))
            ],
          ),
        ));
  }
}

class _cuteRectangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255, 98, 0, 246)
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.22, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
