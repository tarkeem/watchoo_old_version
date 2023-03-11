import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:watchoo/view/screens/mianMovieSc.dart';
import 'package:watchoo/view/widgets/customTextField.dart';

enum auth { logIn, signUp }

class authenticationPage extends StatefulWidget {
  const authenticationPage({super.key});

  @override
  State<authenticationPage> createState() => _authenticationPageState();
}

class _authenticationPageState extends State<authenticationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var _formKey = GlobalKey<FormState>();
  auth authState = auth.logIn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Lottie.asset('126683-show-time-icon.json')),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customTextField(Label: 'Name'),
                    SizedBox(
                      height: 10,
                    ),
                    customTextField(Label: 'Password'),
                    SizedBox(
                      height: 10,
                    ),
                    if (authState == auth.signUp)
                      customTextField(Label: 'Confirm Password'),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(onPressed: () {
                          PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(opacity: animation,child: mainPage(),);
      });
                    }, child: Text(authState==auth.logIn?'logIn':'signup')),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          authState == auth.logIn
                              ? 'You Don\'t Have one?'
                              : 'You Have Already One',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                if (authState == auth.logIn) {
                                  authState = auth.signUp;
                                } else {
                                  authState = auth.logIn;
                                }
                              });
                            },
                            child: Text(authState == auth.logIn
                                ? 'Create One Now'
                                : 'signIn'))
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
