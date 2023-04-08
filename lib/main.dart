import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchoo/controller/authLogic.dart';
import 'package:watchoo/controller/filmsLogic.dart';
import 'package:watchoo/view/screens/allmoviesSc.dart';
import 'package:watchoo/view/screens/authenticationSc.dart';
import 'package:watchoo/view/screens/categoriesMoviesSc.dart';
import 'package:watchoo/view/screens/categoriesSc.dart';
import 'package:watchoo/view/screens/loadingSc.dart';
import 'package:watchoo/view/screens/mianMovieSc.dart';
import 'package:watchoo/view/screens/movieInfoSc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:loadingPage());
  }
}

