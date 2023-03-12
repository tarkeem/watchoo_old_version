import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class customListTile extends StatelessWidget {
  Widget lead,trail;
  Function fun;
  
  
  customListTile({required this.lead,required this.trail,required this.fun});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading:lead ,
        trailing:trail ,
        onTap: () {
          fun();
          
        },
      ),
    );
  }
}