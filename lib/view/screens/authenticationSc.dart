import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:watchoo/constanst.dart';
import 'package:watchoo/controller/authLogic.dart';
import 'package:watchoo/view/screens/mianMovieSc.dart';
import 'package:watchoo/view/widgets/MySnackBar.dart';
import 'package:watchoo/view/widgets/customTextField.dart';
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
  String? email;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    Timer(
      const Duration(seconds: 2),
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

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  auth authState = auth.logIn;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/poster.jpg'), fit: BoxFit.cover),
        ),
      
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
                                colors: [
                              const Color.fromARGB(255, 9, 18, 37).withOpacity(0.6),
                              const Color.fromARGB(255, 9, 18, 37),
                              const Color.fromARGB(255, 9, 18, 37)
                            ])),
                        child: Center(
                          child: Form(
                              key: _formKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Watchoo",style: GoogleFonts.aclonica(fontSize:30,color:Colors.white),),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      customTextField(
                                        icon: Icon(Icons.abc,color: Colors.white,),
                                          isSecure: false,
                                          Label: 'Name',
                                          onSave: (val) {
                                            name = val;
                                          },
                                          onValidate: (val) {
                                            if (val == null || val == '') {
                                              return 'please enter your Email';
                                            }
                                            return null;
                                          },
                                        ),
                                      customTextField(
                                        icon: Icon(Icons.email,color: Colors.white,),
                                        Label: 'Email',
                                        onSave: (val) {
                                          email = val;
                                        },
                                        onValidate: (val) {
                                          if (val == null || val == '') {
                                            return 'please enter your name';
                                          }
                                          return null;
                                        },
                                      ),
                                     
                                      customTextField(
                                          icon: Icon(Icons.lock_outline,color: Colors.white,),
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
                                        textEditingController:
                                            _textEditingController,
                                      ),
                                    
                                      if (authState == auth.signUp) ...[
                                        
                                        customTextField(
                                            icon: Icon(Icons.lock_outline,color: Colors.white,),
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
                                        
                                      ],
                                     
                                      isLoading
                                          ? const CircularProgressIndicator()
                                          : ElevatedButton(
                                              onPressed: validateAuth,
                                              child: Text(authState == auth.logIn
                                                  ? 'Log In'
                                                  : 'Sign Up')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            authState == auth.logIn
                                                ? 'You Don\'t Have one?'
                                                : 'You Have Already One?',
                                            style: constants.bigFont,
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
                                              child: Text(
                                                authState == auth.logIn
                                                    ? 'Create One Now'
                                                    : 'signIn',
                                                style: constants.noticeFont,
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                  )),
        ),
      
    );
  }

  void validateAuth() async {
    bool formstate = _formKey.currentState!.validate();
    var authfun = Provider.of<authLogic>(context, listen: false);
    if (formstate) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      try {
        if (authState == auth.logIn) {
          await authfun.logIn(name!, password!);
        } else {
          await authfun.signup(email!, name!, password!);
        }
      } catch (err) {
        setState(() {
          isLoading = false;
        });

        String er = err.toString();
        showSnackBar(Colors.red, er, context);
        return;
      }
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(opacity: animation, child: const mainPage());
          }));
    }
  }
}
