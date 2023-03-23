import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class customTextField extends StatelessWidget {
  String Label;
  Function(String? val) onValidate;
  Function(String?val) onSave;
 customTextField({required this.Label,required this.onSave,required this.onValidate});
  var border = OutlineInputBorder(
      borderSide: BorderSide(width: 2.5, color: Colors.white));
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        return onValidate(value); //first method to pass function
      },
      onSaved: onSave,//second method to pass function
      style: TextStyle(color: Color.fromARGB(255, 222, 200, 0)),
      decoration: InputDecoration(
        hintText: Label,
        labelStyle: TextStyle(color: Colors.white),
        floatingLabelBehavior:FloatingLabelBehavior.always ,//important to write a text on border
        enabledBorder: border,border: border, labelText: Label,/*label: Text(Label)*/),
    );
  }
}
