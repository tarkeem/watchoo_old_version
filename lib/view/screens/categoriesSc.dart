import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:watchoo/model/categories.dart';


class categoriesc extends StatefulWidget {
  const categoriesc({super.key});

  @override
  State<categoriesc> createState() => _categoriescState();
}

double initPage=2;
class _categoriescState extends State<categoriesc> {
  PageController _pageController = PageController(initialPage: initPage.toInt(),viewportFraction: 0.30);

  double currentPage = initPage;
  int currentPageAsInt = initPage.toInt();
  _coffeListener() {
    setState(() {
      currentPage = _pageController.page!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _pageController.addListener(_coffeListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.removeListener(_coffeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
           
            child: Container(
              //color: Colors.red,
              child: Transform.scale(
                scale: 1.6,
                alignment: Alignment.bottomCenter,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    currentPageAsInt = index;
                    if (index == 0) {
                      return Container(color: Colors.red,);
                    }
                     if (index == categories.length) {
                      _pageController.animateToPage(categories.length-3, duration: Duration(milliseconds: 500), curve: Curves.linear);
                      return SizedBox.shrink();
                     }
                  
                    category catItem = categories[index - 1];
                    var res = currentPage - index + 1;
                    var val = -0.4 * res + 1;
                    var opacityVal = (val).clamp(0.0, 1.0);
                    if(index==1)
                    {
                       print('$index $res  $val  $opacityVal ');
                    }
                   
                    return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..translate(
                              0.0,
                              (MediaQuery.of(context).size.height /
                                  2.6 *
                                  (1 - val).abs()),0.0)
                          ..scale(val,val,val),
                        child: Opacity(
                            opacity: opacityVal,
                            child: Hero(
                              tag: catItem.img_uri,
                              child: Image.asset(catItem.img_uri))));
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
