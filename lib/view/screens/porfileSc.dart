import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:watchoo/controller/authLogic.dart';
import 'package:watchoo/view/screens/authenticationSc.dart';
import 'package:watchoo/view/widgets/customTextField.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  String? newpass, oldpass, newname;
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 183, 172, 129),
      body: Column(
      
        children: [
          SizedBox(height: 100,),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                customTextField(
                  Label: 'name',
                  onSave: (val) {
                    newname = val;
                  },
                  onValidate: (val) {
                    if (val == null || val == "") {
                      return 'please fill the form';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                customTextField(
                  isSecure: true,
                  Label: 'new password',
                  onSave: (val) {
                    newpass = val;
                  },
                  onValidate: (val) {
                    if (val == null || val == "") {
                      return 'please fill the form';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                customTextField(
                  isSecure: true,
                  Label: 'old password',
                  onSave: (val) {
                    oldpass = val;
                  },
                  onValidate: (val) {
                    if (val == null || val == "") {
                      return 'please fill the form';
                    }
                    else if(val!=authLogic().pass)
                    {
                      return 'The old password not Correct Password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                heroTag: '2',
                onPressed: () {
                  var validate = _formKey.currentState!.validate();
                  if (validate) {
                    _formKey.currentState!.save();
                    Provider.of<authLogic>(context, listen: false)
                        .changeProfileInfo(
                            newname!, newpass!, oldpass!, context);
                  }
                },
                child: Icon(Icons.save),
              ),
              FloatingActionButton(
                heroTag: '1',
                backgroundColor: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (contexts) {
                      return AlertDialog(
                        content: Text('Are you sure'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Provider.of<authLogic>(context,listen: false).delete(context);
                              },
                              child: Text('Yes')),
                          TextButton(onPressed: () {
                            Navigator.of(context).pop();
                          }, child: Text('Cancel')),
                        ],
                      );
                    },
                  );
                },
                child: Icon(Icons.delete),
              ),
            ],
          )
        ],
      ),
    );
  }
}
