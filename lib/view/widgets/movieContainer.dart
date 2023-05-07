import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:watchoo/model/film.dart';
import 'package:watchoo/model/fontStyle.dart';
import 'package:glass/glass.dart';
class movieContainer extends StatelessWidget {
  Movie _movie;
  movieContainer(this._movie);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: NetworkImage(_movie.img),fit: BoxFit.fill)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: kToolbarHeight*0.7,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                ),
                child: Row(
                  children: [
                    Expanded(child:Text(_movie.name,)),
                    ratedStars()
                  ],
                ),
              ).asGlass())
        ],
      ),
    );
  }
}

Widget ratedStars() {
  return Expanded(
    child: FittedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rate,color: Colors.yellow,),
          Icon(Icons.star_rate,color: Colors.yellow,),
          Icon(Icons.star_rate,color: Colors.yellow,),
          Icon(Icons.star_rate,color: Colors.yellow,),
          Icon(Icons.star_rate),
        ],
      ),
    ),
  );
}
