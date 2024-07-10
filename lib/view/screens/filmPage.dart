import 'dart:io';
import 'dart:ui';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:watchoo/constanst.dart';
import 'package:watchoo/controller/filmsLogic.dart';
import 'package:watchoo/model/film.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:glass/glass.dart';

class filmPage extends StatefulWidget {
  final Movie _movie;

  const filmPage(this._movie, {super.key});

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
    _videoPlayerController =VideoPlayerController.networkUrl(Uri.parse(widget._movie.movieUrl))
          ..initialize().then((value) {
            setState(() {
              is_loading = false;
            });
          }).onError((error, stackTrace) {
            print('error');
          });

          _CustomVideoPlayerController=CustomVideoPlayerController(videoPlayerController: _videoPlayerController,context: context,customVideoPlayerSettings: const CustomVideoPlayerSettings(showFullscreenButton: true));


  }

  final TextStyle _textStyle = const TextStyle(color: Colors.white, fontSize: 20);
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(child: Container(

          decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget._movie.img),fit: BoxFit.cover)),
        )),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                is_loading?const Center(child: CircularProgressIndicator()): Expanded(flex: 4 ,child:CustomVideoPlayer(customVideoPlayerController: _CustomVideoPlayerController,) ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Movie:${widget._movie.name}',style:constants.bigFont.copyWith(color: Colors.red),),
                ),
                
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Duration:150 minute',style:constants.bigFont.copyWith(color: Colors.red),),
                ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Year:2018',style:constants.bigFont.copyWith(color: Colors.red),),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('PlayList',style:constants.bigFont,),
                  ),
                ),
                const Expanded(flex: 2, child:Center(child:_bottomPart() ,)
                 )
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
 late final List<Movie>_moviesList=Provider.of<MoviesLogic>(context,listen: false).mianMovies;

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
        var movie = _moviesList[index];
        return LayoutBuilder(
          builder: (p0, p1) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: p1.maxHeight,
            width: p1.maxWidth,
            child: Image.network(
              movie.img,
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
