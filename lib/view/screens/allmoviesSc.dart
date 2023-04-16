import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:watchoo/controller/filmsLogic.dart';
import 'package:watchoo/model/film.dart';
import 'package:watchoo/view/widgets/movieContainer.dart';
import 'package:glass/glass.dart';

class allMoviesSc extends StatefulWidget {
  const allMoviesSc({super.key});

  @override
  State<allMoviesSc> createState() => _allMoviesScState();
}

class _allMoviesScState extends State<allMoviesSc> {
  Widget _searchbar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20)),
      height: kToolbarHeight,
      child: Row(
        children: [
          Expanded(
              child: TextField(
                
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
            decoration: InputDecoration(border:InputBorder.none ,hintText: 'Search............'),
          )),
          IconButton(
              onPressed: () {
                setState(() {
                  isSearch = false;
                });
              },
              icon: Icon(Icons.close))
        ],
      ),
    ).asGlass();
  }

  Widget _normalbar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20)),
      height: kToolbarHeight,
      child: Row(
        children: [
          BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Spacer(),
          IconButton(
              onPressed: () {
                setState(() {
                  isSearch = true;
                });
              },
              icon: Icon(Icons.search))
        ],
      ),
    ).asGlass();
  }

  bool isLoading = true;
  List<Movie> _movies = [];

  bool isSearch = false;
  List<Movie> filtredList = [];
  TextEditingController _ctr = TextEditingController();

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
    print(_movies.length);
    return Scaffold(
      body: Container(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.white])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                isSearch ? _searchbar() : _normalbar(),
                isLoading
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, crossAxisSpacing: 6),
                              itemCount: filtredList.length,
                              itemBuilder: (context, index) {
                                return movieContainer(filtredList[index]);
                              },
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
