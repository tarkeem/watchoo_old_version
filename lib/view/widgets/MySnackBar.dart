import 'package:flutter/material.dart';

void showSnackBar(Color col, String message, context) {
  SnackBar snackBar = SnackBar(
    backgroundColor: col,
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
