import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:watchoo/model/film.dart';
import 'package:http/http.dart' as http;

class MoviesLogic extends ChangeNotifier {
  List<Movie> mianMovies = [];
  List<Movie> recomondedMovies = [];

  Future fetchMovies() async {
    var resMainMovies =
        await http.get(Uri.parse('http://localhost:3000/movie/allmovies/'));
    var MainMoviesDecode = json.decode(resMainMovies.body) ;
    print(MainMoviesDecode);
    mianMovies = MainMoviesDecode['movies']!.map<Movie>((ele) {
      return Movie(
          name: ele['moviename'],
          img:'http://localhost:3000/'+ele['imageurl'],
          duration: '1:20:25',
          article: ele['moviedescription'],
          movieUrl:'http://localhost:3000/'+ ele['movieurl'],
          cast: []);
    }).toList();
//...............................................................................

    /*var resRecmondedMovies =
        await http.get(Uri.parse('http://localhost:3000/recomondedMovies'));
    var RecmondedMoviesDecode = json.decode(resMainMovies.body) as Map<String, List>;
    recomondedMovies = MainMoviesDecode['data']!.map((ele) {
      return Movie(
          name: ele['name'],
           img: ele['img'],
          duration: ele['duration'],
          article: ele['article'],
           movieUrl: ele['movieUrl'],
          cast: []);
    }).toList();*/
    notifyListeners(); //if your provider includes this you have to use change notifier provider instead of provider
  }
}
