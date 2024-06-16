// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:stockapp/page/authenticated/user/adduserdetails_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});
  

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage>{
  
  bool _isPasswordVisible = false;
  bool _isConPasswordVisible = false;
  
  final _emailFormKey = GlobalKey<FormState>();
  final _pwFormKey = GlobalKey<FormState>();
  final _cpwFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _cpwController = TextEditingController();

  @override
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:
        WillPopScope(onWillPop: () async {return false;},
          child:
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child:
            Padding(
              padding: EdgeInsets.fromLTRB((sWidth * 0.1), 0, (sWidth * 0.1), (sHeight * 0.1)),
              child: Center(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
// section 1
                    Container(
                      height: (0.2*sHeight),
                      child:
                      Row(
                        children: <Widget>[
                        BackButton(
                          onPressed: ()=> navigateTo(context, widget, LandingPage(pageIndex: 4,), animationType : 'scrollLeft'),
                        )
                        ]
                      ),
                    ),
// section 2
                    Container(
                      child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      
        //sign up heading 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Add Account",
                                fontSize: h2s,
                                fontWeight: h2w,
                                textColor: Theme.of(context).colorScheme.onBackground,
                                ),
                            ],
                          ),
                      ),

        //Sign up subtitle 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.10)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Add an account to the system",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              Expanded(child: 
                                Form(
                                  key: _emailFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. Example@email.com",
                                    labelText: "Email",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _emailController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter email";
                                      }
                                      else if(!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)){
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),
                            ],
                          ),
                      ),
        ////////////////////////////////////////////////////////////////////////////////////////////////////////

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, (sWidth * 0.05)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              Expanded(child: 
                                Form(
                                  key: _pwFormKey,
                                  child:
                                  TextFormField(
                                    controller: _pwController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter password";
                                      }
                                      if(value.length < 8){
                                        return "Password must be at least 8 letters long";
                                      }
                                      if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$').hasMatch(value)) {
                                        return "Password must contain at least\n1 uppercase letter,\n1 number & 1 symbol";
                                      }
                                      return null;
                                    },
                                    obscureText: !_isPasswordVisible,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      hintText: "Enter Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(!_isPasswordVisible?Icons.visibility_off:Icons.visibility),
                                        onPressed: () {
                                          setState(() => _isPasswordVisible = !_isPasswordVisible);
                                        },
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: n2s,
                                      fontWeight: n2w,
                                      color: Theme.of(context).colorScheme.onBackground
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
        ////////////////////////////////////////////////////////////////////////////////////////////////////////


                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              Expanded(child: 
                                Form(
                                  key: _cpwFormKey,
                                  child:
                                  TextFormField(
                                    controller: _cpwController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please confirm password";
                                      }
                                      if(value != _pwController.text){
                                        return "Password does not match";
                                      }
                                      return null;
                                    },
                                    obscureText: !_isConPasswordVisible,
                                    decoration: InputDecoration(
                                      hintText: "Confirm Password",
                                      labelText: "Confirm Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(!_isConPasswordVisible?Icons.visibility_off:Icons.visibility),
                                        onPressed: () => {
                                          setState(() => _isConPasswordVisible = !_isConPasswordVisible
                                          )
                                        },
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: n2s,
                                      fontWeight: n2w,
                                      color: Theme.of(context).colorScheme.onBackground
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
        ////////////////////////////////////////////////////////////////////////////////////////////////////////

// sign up button
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.1), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child:
                                 createButton(
                                  text: "Next",
                                  fontSize: n2s, 
                                  fontWeight: n2w,
                                  bgColor: Theme.of(context).colorScheme.primary, 
                                  textColor: Theme.of(context).colorScheme.onPrimary, 
                                  letterSpacing: l2Space, 
                                  px: 30,
                                  py: 15, 
                                  bradius: 15,
                                  onPressed: () => {
                                    _pwFormKey.currentState!.validate(), 
                                    _emailFormKey.currentState!.validate(),
                                    _cpwFormKey.currentState!.validate(),
                                    if(_pwFormKey.currentState!.validate() && _emailFormKey.currentState!.validate() && _cpwFormKey.currentState!.validate()){
                                      navigateTo(context, widget, AddUserDetailsPage(
                                        userDetails: {
                                        'email': _emailController.text,
                                        'pw': _pwController.text
                                        }),
                                        animationType: 'scrollRight')
                                    },
                                    // navigateTo(context, widget, AddUserDetailsPage(
                                    //   userDetails: {
                                    //   'email': _emailController.text,
                                    //   'pw': _pwController.text
                                    //   }),
                                    //   animationType: 'scrollRight')
                                  },
                                  ),                               
                              ),

                            ],
                          ),
                      ),
                      
                      
                    ]
                  ),
                    ),
// section 3
                    // Container(
                    //   height: (0.2*sHeight),
                    // ),
                  ],
                ),
              )
            ),
          ),
        ),
    );
  }
}