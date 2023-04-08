import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class authLogic extends ChangeNotifier {
  String? token;

  Future logIn(String name, String Password) async {
    var res = await http.post(
        Uri.parse(
          'http://localhost:3000/user/signin/',
        ),
        body: json.encode({'name': name, 'pass': Password}),
        headers: {'Content-Type': 'application/json'});

    var resbody = json.decode(res.body);

    if (res.statusCode == 200) {
      print(resbody);
      token = resbody['message'];
    } else if (res.statusCode == 404) {
      print('print not found');
    } else {
      print('something wrong');
    }
  }

  Future signup(String name, String Password) async {
    var res =await http.post(
        Uri.parse(
          'http://localhost:3000/user/signup/',
        ),
        body: json.encode({'name': name, 'pass': Password}),
        headers: {'Content-Type': 'application/json'});
    var resbody = json.decode(res.body);
    if (res.statusCode == 200) {
      token = resbody['message'];
    } else if (res.statusCode == 404) {
      print('print not found');
    } else {
      print('something wrong');
    }
  }
}
