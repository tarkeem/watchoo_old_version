import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class customTextField extends StatelessWidget {
  String Label;
  Icon icon;
  Function(String? val) onValidate;
  Function(String?val) onSave;
  TextEditingController? textEditingController;
  bool? isSecure;
 customTextField({required this.Label,required this.icon,required this.onSave,required this.onValidate, this.textEditingController,this.isSecure});
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(width: 2.5, color: Colors.white));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: textEditingController,
        validator: (value) {
          return onValidate(value); //first method to pass function
        },
        onSaved: onSave,//second method to pass function
        style: const TextStyle(color: Color.fromARGB(255, 222, 200, 0)),
        obscureText:isSecure??false?true:false,
        decoration: InputDecoration(
          prefixIcon: icon,
          hintStyle: const TextStyle(color: Colors.white),
          hintText: Label,
          labelStyle: TextStyle(color: Colors.white),
          //floatingLabelBehavior:FloatingLabelBehavior.always ,//important to write a text on border
          enabledBorder: border,border: border, label:Text(Label),/*label: Text(Label)*/),
      ),
    );
  }
}
