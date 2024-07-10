import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:watchoo/constanst.dart';



class favoriteScreen extends StatefulWidget {
  const favoriteScreen({super.key});

  @override
  State<favoriteScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<favoriteScreen>
    with SingleTickerProviderStateMixin {
  final _listkey = GlobalKey<AnimatedListState>();
  List poster = [
    'http://10.0.2.2:3000/movie-pics/movie-b7d3f767-1bb7-46e1-ab2e-60565a2186a9-1718203108441venompic.jfif',
   'http://10.0.2.2:3000/movie-pics/movie-b7d3f767-1bb7-46e1-ab2e-60565a2186a9-1718203108441venompic.jfif',
   'http://10.0.2.2:3000/movie-pics/sherlock.jpg',
  
  
  ];

  

  TriggerAnimation(deviceSize, index) {
     _listkey.currentState!.removeItem(
          index,
          (context, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: deviceSize.height * 0.2,
                        width: deviceSize.width * 0.75,
                      ),
                    ),
                  ),
                ),
              ),
          duration: const Duration(milliseconds: 300));
      poster.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: 
      Container(
        clipBehavior: Clip.none,
       
        width: deviceSize.width,
        height: deviceSize.height,
        color: constants.mainColor,
        child: AnimatedList(
          clipBehavior: Clip.none,
            key: _listkey,
            initialItemCount: poster.length,
            itemBuilder: (context, index, animation) {
              if(index==0)
              {
                return Center(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   SizedBox(height: 10,),
                    Text("Favorite Movie",style:constants.bigFont.copyWith(fontSize: 40)),
                  ],
                ));
              }
              //if you wrape it by center it will be like bandage
              return Padding(
                 padding: EdgeInsets.only(left: deviceSize.width*0.13),
                child: DeletableSticker(TriggerList:() {
                  TriggerAnimation(deviceSize, index);
                },image: poster[index],),
              );
            }),
      ),
    );
  }
}

class t extends StatelessWidget {
  const t({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class DeletableSticker extends StatefulWidget {
  DeletableSticker({super.key,required this.TriggerList,required this.image});
  String image;
  void Function()? TriggerList;

  @override
  State<DeletableSticker> createState() => _DeletableStickerState();
}

class _DeletableStickerState extends State<DeletableSticker>
    with SingleTickerProviderStateMixin {
 late AnimationController _animationController;
  late Animation _animation1;
  late Animation<double> _animation2;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation1 = CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.decelerate));
    _animation2 = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1, curve: Curves.linear)));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var deviceSize=MediaQuery.of(context).size;
    return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: deviceSize.height * 0.01,
                      child: FadeTransition(
                        opacity: _animation2,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                          height: deviceSize.height * 0.18,
                          width: (deviceSize.width * 0.73),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {
                                 

                                 _animationController.forward().whenComplete(() {
                                  widget.TriggerList!();
                                 });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                        offset: Offset(_animation1.value * -300, 0),
                        child: Sticker(img: widget.image))
                  ],
                ),
              );
  }
}

class Sticker extends StatefulWidget {
  Sticker({super.key, required this.img});
  String img;
  @override
  State<Sticker> createState() => _StickerState();
}

class _StickerState extends State<Sticker> {
  double x = 0;
  double xpos = 0;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    double percect = (x.abs()) / 90;
    return Container(
      clipBehavior: Clip.none,
        width: (deviceSize.width * 0.9) + x,
        height: deviceSize.height * 0.22,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Positioned(
              height: deviceSize.height * 0.2,
              width: (deviceSize.width * 0.75),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ClipPath(
                  clipper: MyCustomClipper(x),
                  child: Image.network(
                    widget.img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              left: (deviceSize.width * 0.75) + x,
              child: Transform.translate(
                offset: Offset(x, 0),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  height: deviceSize.height * 0.2,
                  width: (deviceSize.width * 0.75),
                  child: ClipPath(
                    clipper: MyCustomClipper2(x),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Image.network(
                        widget.img,
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.lighten,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              height: deviceSize.height * 0.205,
              width: deviceSize.width * 0.02,
              left: (deviceSize.width * 0.73) + x,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: (90 + x * 3).clamp(6, 80))
                    ]),
              ),
            ),
            Positioned(
              height: deviceSize.height * 0.17,
              width: deviceSize.width * 0.025,
              left: (deviceSize.width * 0.77) + x,
              top: deviceSize.height * 0.02,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 0, 0, 0),
                          blurRadius: 25,
                          spreadRadius: 1)
                    ]),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                child: Container(
                  color: Colors.transparent,
                ),
                onHorizontalDragUpdate: (details) {
                  //print(details.delta.dx);
                  setState(() {
                    x += details.delta.dx;
                    if (x > 0) {
                      x = 0;
                    } else if (x < -200) {
                      x = -200;
                    }
                  });
                  //print(x);
                },
              ),
            )
          ],
        ));
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  MyCustomClipper(this.xd);
  double xd;
  @override
  Path getClip(Size size) {
    double delte = xd;
    Path path = Path()
      ..lineTo(0, size.height) // Add line p1p2
      ..lineTo(size.width + delte, size.height)
      ..lineTo(size.width + delte, 0) // Add line p2p3
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class MyCustomClipper2 extends CustomClipper<Path> {
  MyCustomClipper2(this.xd);
  double xd;
  @override
  Path getClip(Size size) {
    double delte = -xd;
    Path path = Path()
      ..lineTo(0, size.height) // Add line p1p2
      ..lineTo(delte, size.height)
      ..lineTo(delte, 0) // Add line p2p3
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
