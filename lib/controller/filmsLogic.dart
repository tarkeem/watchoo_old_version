import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:watchoo/model/film.dart';
import 'package:http/http.dart' as http;

class MoviesLogic extends ChangeNotifier {
  List<Movie> mianMovies = [];
  List<Movie> recomondedMovies = [];

  void fetchMovies() async {
    var resMainMovies =
        await http.get(Uri.parse('http://localhost:3000/mianMovies'));
    var MainMoviesDecode = json.decode(resMainMovies.body) as Map<String, List>;
    mianMovies = MainMoviesDecode['data']!.map((ele) {
      return Movie(
          name: ele['name'],
          img: ele['img'],
          duration: ele['duration'],
          article: ele['article'],
          cast: []);
    }).toList();
//...............................................................................

    var resRecmondedMovies =
        await http.get(Uri.parse('http://localhost:3000/recomondedMovies'));
    var RecmondedMoviesDecode = json.decode(resMainMovies.body) as Map<String, List>;
    recomondedMovies = MainMoviesDecode['data']!.map((ele) {
      return Movie(
          name: ele['name'],
           img: ele['img'],
          duration: ele['duration'],
          article: ele['article'],
          cast: []);
    }).toList();
  }
}
