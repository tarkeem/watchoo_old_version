import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:watchoo/controller/authLogic.dart';
import 'package:watchoo/controller/filmsLogic.dart';
import 'package:watchoo/model/categories.dart';
import 'package:watchoo/view/screens/allmoviesSc.dart';
import 'package:watchoo/view/screens/porfileSc.dart';

class categoriesc extends StatefulWidget {
  const categoriesc({super.key});

  @override
  State<categoriesc> createState() => _categoriescState();
}

double initPage = 2;

class _categoriescState extends State<categoriesc> {
  PageController _pageController =
      PageController(initialPage: initPage.toInt(), viewportFraction: 0.30);

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
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          )),
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
                      return _categoryAppBar();
                    }
                    if (index == categories.length) {
                      _pageController.animateToPage(categories.length - 3,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear);
                      return SizedBox.shrink();
                    }

                    category catItem = categories[index - 1];
                    var res = currentPage - index + 1;
                    var val = -0.4 * res + 1;
                    var opacityVal = (val).clamp(0.0, 1.0);
                    if (index == 1) {
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
                                  (1 - val).abs()),
                              0.0)
                          ..scale(val, val, val),
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

class _categoryAppBar extends StatelessWidget {
  const _categoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: deviceSize.height * 0.2,
          width: deviceSize.width * 0.5,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue),),
                    onPressed: () {
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeNotifierProvider<authLogic>(
                        create: (context) => authLogic(),
                        builder:(context, child) =>ProfileScreen()),));
                    },
                    icon: Icon(Icons.person),
                    label: Text('profile')),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton.icon(
                                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 246, 0, 164)),),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => allMoviesSc()),);
                    },
                    icon: Icon(Icons.movie),
                    label: Text('All movies')),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 0, 0, 0)),),
                    onPressed: () {},
                    icon: Icon(Icons.search),
                    label: Text('Search')),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton.icon(
                                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 255, 0, 0)),),
                    onPressed: () {},
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Exit')),
                  )
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}
