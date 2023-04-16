import 'dart:io';
import 'dart:ui';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:watchoo/controller/filmsLogic.dart';
import 'package:watchoo/model/film.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:watchoo/model/fontStyle.dart';
import 'package:glass/glass.dart';

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

          _CustomVideoPlayerController=CustomVideoPlayerController(videoPlayerController: _videoPlayerController,context: context,customVideoPlayerSettings: CustomVideoPlayerSettings(showFullscreenButton: true));


  }

  TextStyle _textStyle = TextStyle(color: Colors.white, fontSize: 20);
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(child: Container(

          decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget._movie.img),fit: BoxFit.cover)),
        )),
        Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent,title: Text(widget._movie.name),centerTitle: true,),
          backgroundColor: Colors.transparent,
          body: Container(
            child: Column(
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
          ).asGlass(),
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
 late List<Movie>_moviesList=Provider.of<MoviesLogic>(context,listen: false).mianMovies;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_moviesList=Provider.of<MoviesLogic>(context).mianMovies;//error will happen because of using it before completing the fetching
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: _moviesList.length,
      itemBuilder: (context, index, realIndex) {
        var _movie = _moviesList[index];
        return LayoutBuilder(
          builder: (p0, p1) => Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: p1.maxHeight,
            width: p1.maxWidth,
            child: Image.network(
              _movie.img,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
      options: CarouselOptions(enlargeFactor: 4/2,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale),
    );
  }
}
