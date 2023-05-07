import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchoo/controller/authLogic.dart';
import 'package:watchoo/controller/filmsLogic.dart';
import 'package:watchoo/view/screens/authenticationSc.dart';
import 'package:watchoo/view/screens/mianMovieSc.dart';

class loadingPage extends StatefulWidget {
  const loadingPage({super.key});

  @override
  State<loadingPage> createState() => _loadingPageState();
}

class _loadingPageState extends State<loadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _scaleAnimation;
  late Animation _moveAnimation;
  late Animation _opacityAnimation;
  late Animation _opacityAnimation2;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _scaleAnimation = Tween<double>(begin: 7, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.1, 0.2)));
    _moveAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.3, 0.5)));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.6, 0.7)));
    _opacityAnimation2 = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.8, 0.9)));

    _controller.forward().then((value) {
      Navigator.of(context).push(
        
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(opacity: animation,child:authenticationPage(),
    );
      },));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
          
            Positioned(
                top: deviceSize.height * 0.45,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..scale(_scaleAnimation.value, _scaleAnimation.value)
                    ..translate(90* _moveAnimation.value),
                  child: Container(
                    height: 100,
                    width: 100,
                  
                    child: Lottie.asset('128725-cast-tv.json'),
                  ),
                )),
            Positioned(
                top: deviceSize.height * 0.5,
                left: deviceSize.width*0.1,
                child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Text('With Tvoo You Own The World',style: TextStyle(fontSize: 20),))),
            Positioned(
                top: deviceSize.height * 0.8,
                child: Opacity(
                    opacity: _opacityAnimation2.value, child: Text('By:Tarek')))
          ],
        ),
      ),
    );
  }
}
