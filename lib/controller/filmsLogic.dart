import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:watchoo/model/film.dart';
import 'package:http/http.dart' as http;

class MoviesLogic extends ChangeNotifier {
  List<Movie> mianMovies = [];
  List<Movie> searchedMovies = [];
  int reaminingPage = 0;
  List<Movie> recomondedMovies = [];

  Future fetchMovies() async {
    var resMainMovies =
        await http.get(Uri.parse('http://10.0.2.2:3000/movie/allmovies/'));
    var decode = json.decode(resMainMovies.body) ;
   var allMovies = decode['movies']!;
   print(allMovies);
    mianMovies.clear();

   allMovies.forEach((element) {
     mianMovies.add(Movie(
                rate:  element['rate']??"4", 
                description: element['moviedescription'],
                img:element['imageurl'],
                movieUrl: element['movieurl'],
                name: element['moviename']
         ));
   },);
   
   
//...............................................................................

   
    notifyListeners(); //if your provider includes this you have to use change notifier provider instead of provider
  }

  Future searchMovies(String name,int page) async {
    var resSearchMovie =
        await http.get(Uri.parse('http://localhost:3000/movie/search/?name=$name&page=$page'));
    var decode = json.decode(resSearchMovie.body) ;
   var allMovies = decode['movies']!;
   reaminingPage = decode['reminingPage']!;

   allMovies.forEach((element) {
     searchedMovies.add(Movie(
      rate:  element['rate']??"4",
                description: element['moviedescription'],
                img:element['imageurl'],
                movieUrl: element['movieurl'],
                name: element['moviename']
         ));
   },);
   
   
//...............................................................................

   
    notifyListeners(); //if your provider includes this you have to use change notifier provider instead of provider
  }
}
