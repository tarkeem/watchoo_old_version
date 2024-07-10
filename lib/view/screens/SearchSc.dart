import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:watchoo/constanst.dart';
import 'package:watchoo/controller/filmsLogic.dart';
import 'package:watchoo/model/film.dart';
import 'package:watchoo/view/widgets/movieContainer.dart';
import 'package:glass/glass.dart';

class searchScreen extends StatefulWidget {
  const searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  Widget _searchbar() {
    return Row(
      children: [
        const BackButton(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
             margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20)),
            height: kToolbarHeight,
            child: 
               Center(
                 child: TextFormField(
                        
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        filtredList = _movies
                            .where((element) =>
                                element.name.toLowerCase().startsWith(value))
                            .toList();
                      });
                    },
                    controller: _ctr,
                    decoration: const InputDecoration(border:InputBorder.none ,hintText: 'Search...',suffixIcon: Icon(Icons.close)),
                  ),
               )
          ),
        ),
      ],
    );
  }

  

  bool isLoading = true;
  List<Movie> _movies = [];

  bool isSearch = false;
  List<Movie> filtredList = [];
  final TextEditingController _ctr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<MoviesLogic>(context, listen: false)
        .fetchMovies()
        .then((value) {
      setState(() {
        filtredList =
            Provider.of<MoviesLogic>(context, listen: false).mianMovies;
        _movies = Provider.of<MoviesLogic>(context, listen: false).mianMovies;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize=MediaQuery.of(context).size;
    print(_movies.length);
    return Scaffold(
      body: Container(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black,constants.mainColor])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _searchbar(),
                isLoading
                    ? const CircularProgressIndicator()
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            child: AnimationLimiter(
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent:deviceSize.height*0.40,
                                        crossAxisCount: 2, crossAxisSpacing: 6),
                                itemCount: filtredList.length,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredGrid(
                                    columnCount: 3,
                                    position: index,
                                    duration: const Duration(seconds: 1),
                                    
                                    child: ScaleAnimation(child: FadeInAnimation(child: movieContainer(filtredList[index]))));
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
