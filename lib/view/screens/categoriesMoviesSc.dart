import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:watchoo/view/screens/loadingSc.dart';

class tester extends StatelessWidget {
  const tester({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
          onPressed: () async {
            var res= await http.post(
                Uri.parse(
                  'http://localhost:3000/user/test/',
                ),
                body: json.encode({'name':'sa' }),
                headers: {'Content-Type': 'application/json'});
          print(res.body);
          },
          child: loadingPage()),
    );
  }
}
