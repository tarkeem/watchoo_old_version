import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchoo/controller/authLogic.dart';
import 'package:watchoo/controller/filmsLogic.dart';
import 'package:watchoo/model/fontStyle.dart';
import 'package:watchoo/view/screens/mianMovieSc.dart';
import 'package:watchoo/view/widgets/customTextField.dart';
import 'package:elastic_drawer/elastic_drawer.dart';
import 'package:glass/glass.dart';

enum auth { logIn, signUp }

class authenticationPage extends StatefulWidget {
  const authenticationPage({super.key});

  @override
  State<authenticationPage> createState() => _authenticationPageState();
}

class _authenticationPageState extends State<authenticationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  String? password;
  String? name;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    Timer(
      Duration(seconds: 2),
      () {
        _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var _formKey = GlobalKey<FormState>();
  TextEditingController _textEditingController = TextEditingController();
  auth authState = auth.logIn;
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('poster.jpg'), fit: BoxFit.cover),
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 225, 255, 0), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
                    child: Lottie.asset('126683-show-time-icon.json'))),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Opacity(
                  opacity: _controller.value,
                  child: Transform.translate(
                    offset: Offset(
                        0, lerpDouble(200, 0, _animation.value)!.toDouble()),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withOpacity(0.6), Colors.white.withOpacity(0.6)])),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      customTextField(
                                        
                                        Label: 'Name',
                                        onSave: (val) {
                                          name = val;
                                        },
                                        onValidate: (val) {
                                          if (val == null || val == '') {
                                            return 'please enter your name';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      customTextField(
                                        isSecure: true,
                                        Label: 'Password',
                                        onSave: (val) {
                                          password = val;
                                        },
                                        onValidate: (val) {
                                          if (val == null || val == '') {
                                            return 'please enter your password';
                                          }
                                          return null;
                                        },
                                        textEditingController: _textEditingController,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if (authState == auth.signUp)
                                        customTextField(
                                          isSecure: true,
                                          Label: 'Confirm Password',
                                          onSave: (val) {},
                                          onValidate: (val) {
                                            if (val == null || val == '') {
                                              return 'please enter your password';
                                            } else if (val !=
                                                _textEditingController.text) {
                                              return 'the password does\'t match';
                                            }
                                            return null;
                                          },
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    isLoading?CircularProgressIndicator():
                                      ElevatedButton(
                                          onPressed: () async {
                          
                                            bool _formstate =
                                                _formKey.currentState!.validate();
                                            var authfun = Provider.of<authLogic>(
                                                context,
                                                listen: false);
                                            Response res;
                          
                                            if (_formstate) {
                                              _formKey.currentState!.save();
                                              /*if (authState == auth.logIn) {
                                                Provider.of<authLogic>(context,listen: false).logIn(name!, password!);
                                    
                                              } else {
                                                 Provider.of<authLogic>(context,listen: false).signup(name!, password!);
                                              }*/
                                    setState(() {
                                      isLoading=true;
                                    });
                          
                                              try {
                                                if (authState == auth.logIn) {
                                                  await authfun.logIn(
                                                      name!, password!);
                                                } else {
                                                  await authfun.signup(
                                                      name!, password!);
                                                }
                                              } catch (err) {
                          setState(() {
                            isLoading=false;
                          });
                                                
                                                String er=err.toString();
                                                 SnackBar snackBar = SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content:
                                                      Text(er),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                return;
                                              }
                           Navigator.of(context).push(
                                                PageRouteBuilder(
                                                    transitionDuration:
                                                        Duration(seconds: 1),
                                                    pageBuilder: (context, animation,
                                                        secondaryAnimation) {
                                                      return FadeTransition(
                                                        opacity: animation,
                                                        child: ChangeNotifierProvider<
                                                                MoviesLogic>(
                                                            create: (context) =>
                                                                MoviesLogic(),
                                                            child: mainPage()),
                                                      );
                                                    }));
                                            }
                                           
                                          },
                                          child: Text(authState == auth.logIn
                                              ? 'logIn'
                                              : 'signup')),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            authState == auth.logIn
                                                ? 'You Don\'t Have one?'
                                                : 'You Have Already One',
                                            style: BigFont(Colors.black, 20),
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
                                )),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                            Image.network('https://www.spadealaw.com/wp-content/uploads/2019/01/googleplus.png'),
                            Image.network('https://th.bing.com/th/id/R.ff5342ad67f403139a1fdf6c6e66c962?rik=odvtP69dxRXakQ&riu=http%3a%2f%2f1.bp.blogspot.com%2f-CnTGBZaanBY%2fUO9sKnXkBJI%2fAAAAAAAAEB8%2fZ5b9Ei0xris%2fs1600%2fFacebook%2blogo.png&ehk=GFzNdcj9lV4OuLVynIAWxGgQag7uXsSfrWOQsGSPYyk%3d&risl=&pid=ImgRaw&r=0')
                            ,Image.network('https://th.bing.com/th/id/R.b757f2bca8039d4a08882d38f4c1b8f0?rik=ghH7DAGg25Eeew&riu=http%3a%2f%2fpluspng.com%2fimg-png%2ftwitter-png-logo-logo-twitter-in-png-2500.png&ehk=8T3AUm4YM1VPbzANgHJr0FTLLw4och8GO%2bj%2fFN9SSrA%3d&risl=&pid=ImgRaw&r=0')
                            ],),
                          )
                        ],
                      ),
                    ).asGlass(
                        tintColor: Color.fromARGB(255, 0, 0, 0),
                        clipBorderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
