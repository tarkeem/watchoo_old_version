import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watchoo/view/screens/authenticationSc.dart';

class authLogic extends ChangeNotifier {
  String? token;
  String? tname;
  String? pass;

  Future logIn(String name, String Password) async {
    tname = name;
    pass=Password;
  
    print(tname);
    try {
      var res = await http.post(
          Uri.parse(
            'http://10.0.2.2:3000/user/signin/',
          ),
          body: json.encode({'email': name, 'password': Password}),
          headers: {'Content-Type': 'application/json'});
      if (res.statusCode == 400) {
        throw 'wrong password!';
      }
      else if (res.statusCode == 404) {
        throw 'not found!';
      }
      //var resbody = json.decode(res.body);
      var encodedRes = json.decode(res.body);
      print(encodedRes['token']);
      token = encodedRes['token'];
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future signup(String email,String name, String Password) async {
    pass=Password;
    
    var res = await http.post(
        Uri.parse(
          'http://10.0.2.2:3000/user/signup/',
        ),
        body: json.encode({'email': email,'username':name, 'password': Password}),
        headers: {'Content-Type': 'application/json'});
    var resbody = json.decode(res.body);
    token=resbody['token'];
    return res;
  }

  Future changeProfileInfo(
      String newname, String newPass, String oldPass, cxt) async {
    try {
      var res = await http
          .patch(Uri.parse('http://10.0.2.2:3000/user/update/$token'),
              body: json.encode(
                {'name': newname, 'oldpass': oldPass, 'newpass': newPass},
              ),
              headers: {'Content-Type': 'application/json'});
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(cxt).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Changed successfully'),
        ));
      } else if (res.statusCode == 410) {
        ScaffoldMessenger.of(cxt).showSnackBar(const SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
          content: Text('not Correct Password'),
        ));
      } else {
        ScaffoldMessenger.of(cxt).showSnackBar(const SnackBar(
          backgroundColor: Color.fromARGB(255, 254, 0, 0),
          content: Text('something wrong at server,try later'),
        ));
      }
      Navigator.of(cxt).pop();
    } catch (err) {
      ScaffoldMessenger.of(cxt).showSnackBar(const SnackBar(
        backgroundColor: Color.fromARGB(255, 254, 0, 0),
        content: Text('something wrong at server,try later'),
      ));
    }
  }

  Future delete(cxt) async {
    var res = await http
        .delete(Uri.parse('http://10.0.2.2:3000/user/delete/$token'));

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(cxt).showSnackBar(const SnackBar(
        backgroundColor: Color.fromARGB(255, 0, 207, 10),
        content: Text('deleted successfully'),
        
      ));
//dont use material page route
      Navigator.of(cxt).pushReplacement(PageRouteBuilder(pageBuilder:(context, animation, secondaryAnimation) =>const authenticationPage()),);


    }
    else
    {
       ScaffoldMessenger.of(cxt).showSnackBar(const SnackBar(
        backgroundColor: Color.fromARGB(255, 254, 0, 0),
        content: Text('something wrong at server,try later'),
      ));
    }
  }
}
