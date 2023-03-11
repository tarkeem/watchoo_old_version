import 'package:flutter/material.dart';
import 'package:watchoo/model/actor.dart';

class Movie
{
  String name;
  String duration;
  String article;
  List<Actor>cast;
  String img;
  Movie({required this.name,required this.img,required this.duration,required this.article,required this.cast});
  
}