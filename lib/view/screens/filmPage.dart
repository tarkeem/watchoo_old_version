import 'dart:io';
import 'dart:ui';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';
import 'package:watchoo/model/film.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:watchoo/model/fontStyle.dart';

class filmPage extends StatefulWidget {
  Movie _movie;

  filmPage(this._movie);

  @override
  State<filmPage> createState() => _filmPageState();
}

class _filmPageState extends State<filmPage> {
  bool is_shown = true;
  bool is_pause = true;
  bool is_loading = true;
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _CustomVideoPlayerController;

  ValueNotifier<String> currPos = ValueNotifier('0:0:0');

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(widget._movie.movieUrl)
          ..initialize().then((value) {
            setState(() {
              is_loading = false;
              /*_videoPlayerController.addListener(() {
                Duration posnow = _videoPlayerController.value.position;
                currPos.value =
                    "${posnow.inHours}:${posnow.inMinutes}:${posnow.inSeconds}:";

                    if(_videoPlayerController.value.position==_videoPlayerController.value.duration)
                    {
                      _videoPlayerController.pause();
                    }
              });
            */
            });
          }).onError((error, stackTrace) {
            print('error');
          });

          _CustomVideoPlayerController=CustomVideoPlayerController(videoPlayerController: _videoPlayerController,context: context);


  }

  TextStyle _textStyle = TextStyle(color: Colors.white, fontSize: 20);
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(child: Container(

          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [Colors.brown,Colors.black])),
        )),
        Scaffold(
          appBar: AppBar(title: Text(widget._movie.name),centerTitle: true,),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              /*Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Expanded(child: VideoPlayer(_videoPlayerController)),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (_videoPlayerController.value.isPlaying) {
                                  await _videoPlayerController.pause();
                                } else {
                                  await _videoPlayerController.play();
                                }

                                setState(() {});
                              },
                              icon: _videoPlayerController.value.isPlaying
                                  ? Icon(
                                      Icons.pause_circle,
                                      color: Colors.white,
                                    )
                                  : Icon(Icons.play_circle, color: Colors.white)),
                          ValueListenableBuilder(
                            valueListenable: currPos,
                            builder: (context, value, child) => Text(
                              value,
                              style: _textStyle,
                            ),
                          ),
                          Expanded(
                              child: VideoProgressIndicator(
                            _videoPlayerController,
                            allowScrubbing: true,
                          )),
                          Text(
                            '${_videoPlayerController.value.duration.inHours.toString()}:${_videoPlayerController.value.duration.inMinutes.toString()}:${_videoPlayerController.value.duration.inSeconds.toString()}',
                            style: _textStyle,
                          ),
                        ],
                      )
                    ],
                  )),*/
              is_loading?CircularProgressIndicator(): Expanded(flex: 4 ,child:CustomVideoPlayer(customVideoPlayerController: _CustomVideoPlayerController,) ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Related',style: BigFont(Colors.white, 20),),
              ),
              Expanded(flex: 2, child: _bottomPart())
            ],
          ),
        ),
      ],
    );
  }
}

class _bottomPart extends StatefulWidget {
  const _bottomPart({super.key});

  @override
  State<_bottomPart> createState() => __bottomPartState();
}

class __bottomPartState extends State<_bottomPart> {
  List<Movie> _moviesList = List.generate(
      10,
      (index) => Movie(
          name: 'All Quite',
          img: 'movie.jpg',
          duration: '1:30:7',
          article: '$index',
          movieUrl:
              'http://localhost:3000//Tutorial aplicación de banco desde CERO_ Flutter(360P).mp4',
          cast: []));

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: 8,
      itemBuilder: (context, index, realIndex) {
        var _movie = _moviesList[0];
        return LayoutBuilder(
          builder: (p0, p1) => Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: p1.maxHeight,
            width: p1.maxWidth,
            child: Image.asset(
              _movie.img,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
      options: CarouselOptions(
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale),
    );
  }
}
