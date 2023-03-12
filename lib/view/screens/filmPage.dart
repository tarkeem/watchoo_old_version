import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';
import 'package:watchoo/model/film.dart';

class filmPage extends StatefulWidget {
  
  Movie _movie;
  
  filmPage(this._movie);

  @override
  State<filmPage> createState() => _filmPageState();
}

class _filmPageState extends State<filmPage> {
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController=VideoPlayerController.network(widget._movie.movieUrl)..initialize().then((value) {
      setState(() {
        
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:Column(
        children: [
          Expanded(flex: 4, child:Container(
            color: Colors.black,
            child:VideoPlayer(_videoPlayerController) ,
          ) ),
          Expanded(flex: 2, child:Placeholder() )
        ],
      ) ,
    );
  }
}