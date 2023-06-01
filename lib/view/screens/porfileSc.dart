import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:watchoo/controller/authLogic.dart';
import 'package:watchoo/view/screens/authenticationSc.dart';
import 'package:watchoo/view/widgets/customTextField.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? newpass, oldpass, newname;

  var _formKey = GlobalKey<FormState>();
  bool showChange=false;
  @override
  Widget build(BuildContext context) {
    var prov=Provider.of<authLogic>(context,listen: true);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar( backgroundColor: Colors.transparent,leading: BackButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),centerTitle: true,title: Text('User:${prov.tname}')),
      body: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 46, 65, 91),
          borderRadius: BorderRadius.circular(20)
        ),
        child:!showChange?
        
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.favorite_outlined,color: Colors.pink,),
                    Text('Favorite Films',style: GoogleFonts.abhayaLibre(fontSize: 20,color: Colors.white),)
                  ],
                ),
                 Column(
                  children: [
                    Icon(Icons.settings,color: Color.fromARGB(255, 255, 255, 255),),
                    Text('Change Password',style: GoogleFonts.abhayaLibre(fontSize: 20,color: Colors.white),)
                  ],
                ),
                 GestureDetector(
                  onTap: () {
                    setState(() {
                      showChange=true;
                    });
                  },
                   child: Column(
                    children: [
                      Icon(Icons.settings,color: Color.fromARGB(255, 255, 255, 255),),
                      Text('Change Name',style: GoogleFonts.abhayaLibre(fontSize: 20,color: Colors.white),)
                    ],
                                 ),
                 )
              ],
            ),

            FloatingActionButton(
                  heroTag: '1',
                  backgroundColor: Colors.red,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (contexts) {
                        return AlertDialog(
                          content: Text('Are you sure to delete this Account'),
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
        

        
         :Column(
        
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
                  /*customTextField(
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
                  ),*/
                  customTextField(
                    isSecure: true,
                    Label: 'Confirm password',
                    onSave: (val) {
                      oldpass = val;
                    },
                    onValidate: (val) {
                      if (val == null || val == "") {
                        return 'please fill the form';
                      }
                      else if(val!=prov.pass)
                      {
                        return 'Not Correct Password';
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
                              newname!,prov.pass!, oldpass!, context);
                    }
                  },
                  child: Icon(Icons.save),
                ),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
