import 'package:flutter/material.dart';

class ratedStar extends StatelessWidget {
  int star;
   ratedStar({required this.star,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int darkStar=5-star;
    return 
      Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(star,(index) => Icon(Icons.star_rate,color: Colors.yellow,)),
            ...List.generate(darkStar,(index) => Icon(Icons.star_rate,color: Colors.white,))
            
          ],
        
    );
  }
}