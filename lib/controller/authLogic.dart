import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class authLogic extends ChangeNotifier {

String?token;

  void logIn(String name, String Password)async {
    var res =await http.post(
        Uri.parse(
          'https://locahost:3000/login',
        ),
        body: {
          'name':name,
          'password':Password
        });

        var resbody=json.decode(res.body);

        if(res.statusCode==200)
        {
          token=resbody['message'];
        }
        else if(res.statusCode==404)
        {
          print('print not found');

        }
        else
        {
          print('something wrong');
        }
  }

void signup(String name, String Password) async{
    var res =await http.post(
        Uri.parse(
          'https://locahost:3000/signup',
        ),
        body: {
          'name':name,
          'password':Password
        });
 var resbody=json.decode(res.body);
if(res.statusCode==200)
        {
          token=resbody['message'];
        }
        else if(res.statusCode==404)
        {
          print('print not found');

        }
        else
        {
          print('something wrong');
        }


  }


     


}
