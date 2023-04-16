import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class authLogic extends ChangeNotifier {
  String? token;

  Future logIn(String name, String Password) async {
    try {
      var res = await http.post(
          Uri.parse(
            'http://localhost:3000/user/signin/',
          ),
          body: json.encode({'name': name, 'pass': Password}),
          headers: {'Content-Type': 'application/json'});
          print('1');
      if (res.statusCode >= 400) {
        print('2');
        throw 'r';
      }
      //var resbody = json.decode(res.body);
      print('3');
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future signup(String name, String Password) async {
    var res = await http.post(
        Uri.parse(
          'http://localhost:3000/user/signup/',
        ),
        body: json.encode({'name': name, 'pass': Password}),
        headers: {'Content-Type': 'application/json'});
    var resbody = json.decode(res.body);
    return res;
  }
}
