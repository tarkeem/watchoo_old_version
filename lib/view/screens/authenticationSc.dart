import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchoo/controller/authLogic.dart';
import 'package:watchoo/view/screens/mianMovieSc.dart';
import 'package:watchoo/view/widgets/customTextField.dart';
import 'package:elastic_drawer/elastic_drawer.dart';

enum auth { logIn, signUp }

class authenticationPage extends StatefulWidget {
  const authenticationPage({super.key});

  @override
  State<authenticationPage> createState() => _authenticationPageState();
}

class _authenticationPageState extends State<authenticationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String? password;
  String? name;

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
      body: Container(
         decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 225, 255, 0),Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                
                )
              ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Lottie.asset('126683-show-time-icon.json')),
            Expanded(
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customTextField(Label: 'Name',onSave:(val) {
                          name=val;
                        }, onValidate:(val) {
                          if(val==null||val=='')
                          {
                            return 'please enter your name';
                          }
                          return null;
                        }, ),
                        SizedBox(
                          height: 10,
                        ),
                        customTextField(Label: 'Password',onSave:(val) {
                          password=val;
                        }, onValidate:(val) {
                          if(val==null||val=='')
                          {
                            return 'please enter your password';
                          }
                          return null;
                        }, ),
                        SizedBox(
                          height: 10,
                        ),
                        if (authState == auth.signUp)
                          customTextField(Label: 'Confirm Password',onSave:(val) {
                            
                          }, onValidate:(val) {
                            if(val==null||val=='')
                          {
                            return 'please enter your password';
                          }
                          return 'dadasd';
                          }, ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              bool _formstate = _formKey.currentState!.validate();

                            
            
                              if (_formstate) {
                                /*if (authState == auth.logIn) {
                                  Provider.of<authLogic>(context,listen: false).logIn(name!, password!);
            
                                } else {
                                   Provider.of<authLogic>(context,listen: false).signup(name!, password!);
                                }*/


                                  Navigator.of(context).push(PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 1),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: mainPage(),
                                    );
                                  }));
                              }
                              return;
            
                            
                            },
                            child:
                                Text(authState == auth.logIn ? 'logIn' : 'signup')),
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
                  )),
            )
          ],
        ),
      ),
    );
  }
}
