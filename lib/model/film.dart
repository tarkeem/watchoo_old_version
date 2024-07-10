import 'package:flutter/material.dart';
import 'package:watchoo/model/actor.dart';

class Movie
{
  String name;
  String description;
  String img;
  String rate;
  String movieUrl;
  Movie({required this.name,required this.rate,required this.img,required this.movieUrl,required this.description});
  
}