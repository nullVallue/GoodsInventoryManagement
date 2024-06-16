
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';
import 'package:stockapp/page/annonymous/signup_pg.dart';
import 'package:stockapp/page/annonymous/signupaddr_pg.dart';

class SignUpDetailsPage extends StatefulWidget {
  final Map userDetails;

  const SignUpDetailsPage({super.key, required this.userDetails});

  @override
  State<SignUpDetailsPage> createState() => _SignUpDetailsPageState();
}

class _SignUpDetailsPageState extends State<SignUpDetailsPage>{


  @override
  Widget build(BuildContext build){
  
    
  final _firstNameFormKey = GlobalKey<FormState>();
  final _lastNameFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:
        WillPopScope(onWillPop: () async {return false;},
          child:
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child:
            Padding(
              padding: EdgeInsets.fromLTRB((sWidth * 0.1), 0, (sWidth * 0.1), 0),
              child: Center(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
// Section 1

                    Container(
                      height: (0.2*sHeight),
                      child:
                      Row(
                        children: <Widget>[
                        BackButton(
                          onPressed: ()=> navigateTo(context, widget, SignUpPage(), animationType : 'scrollLeft'),
                        )
                        ]
                      ),
                    ),
// Section 2

                    Container(
                      height: (0.6*sHeight),
                      child: 
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [

  // Title                          
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                            child: 
                              Row(
                                children: <Widget>[
                                  createText(
                                    "Personal Details",
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
                                    "Fill up details to complete \naccount creation",
                                    fontSize: sub3s,
                                    fontWeight: sub3w,
                                    textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                  ),
                                ],
                              ),
                          ),
                          

// first name input
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _firstNameFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. John",
                                    labelText: "First Name",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    mr: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _firstNameController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter \nfirst name";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),

// last name input
                              Expanded(child: 
                                Form(
                                  key: _lastNameFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. Doe",
                                    labelText: "Last Name",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    ml: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _lastNameController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter \nlast name";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),


                            ],
                          ),
                      ),
                      
// phone input                      
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _phoneFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. 0123456789",
                                    labelText: "Phone No",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    mr: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _phoneController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter phone no.";
                                      }
                                      else if(!RegExp(r'^\d{3}-?\d{6,11}$').hasMatch(value)){
                                        return "Please enter a valid phone no.\ne.g. 012-3456789";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),


                            ],
                          ),
                      ),


// continue button
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.1), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child:
                                 createButton(
                                  text: "Continue",
                                  fontSize: n2s, 
                                  fontWeight: n2w,
                                  bgColor: Theme.of(context).colorScheme.primary, 
                                  textColor: Theme.of(context).colorScheme.onPrimary, 
                                  letterSpacing: l2Space, 
                                  px: 30,
                                  py: 15, 
                                  bradius: 15,
                                  onPressed: () => {
                                    _firstNameFormKey.currentState!.validate(), 
                                    _lastNameFormKey.currentState!.validate(),
                                    _phoneFormKey.currentState!.validate(),
                                    if(_firstNameFormKey.currentState!.validate() && _lastNameFormKey.currentState!.validate() && _phoneFormKey.currentState!.validate()){
                                    navigateTo(context, widget, SignUpAddrPage(
                                      userDetails: {
                                      'email': widget.userDetails['email'],
                                      'pw': widget.userDetails['pw'], 'firstname': _firstNameController.text, 
                                      'lastname' : _lastNameController.text, 
                                      'phoneno' : _phoneController.text 
                                      }),
                                      animationType: 'scrollRight')
                                    }
                                    // navigateTo(context, widget, SignUpAddrPage(
                                    //   userDetails: {
                                    //   'email': widget.userDetails['email'],
                                    //   'pw': widget.userDetails['pw'], 'firstname': _firstNameController.text, 'lastname' : _lastNameController.text, 'phoneno' : _phoneController.text 
                                    //   }),
                                    //   animationType: 'scrollRight')
                                  },
                                  ),                               
                              ),

                            ],
                          ),
                      ),

                          
                        ],
                      ),
                      
                    ),
// Section 3
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