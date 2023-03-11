import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class customTextField extends StatelessWidget {
  String Label;
 customTextField({required this.Label});
  var border = OutlineInputBorder(
      borderSide: BorderSide(width: 2.5, color: Colors.white));
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        floatingLabelBehavior:FloatingLabelBehavior.always ,//important to write a text on border
        enabledBorder: border,border: border, /*labelText: Text(Label),*/label: Text(Label)),
    );
  }
}
