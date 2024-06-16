// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/user/adduserdetails_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';
import 'package:stockapp/database/database.dart';


class AddUserAddrPage extends StatefulWidget {
  final Map userDetails;

  const AddUserAddrPage({super.key, required this.userDetails});

  @override
  State<AddUserAddrPage> createState() => _AddUserAddrPageState();
}

class _AddUserAddrPageState extends State<AddUserAddrPage>{

  final _addr1FormKey = GlobalKey<FormState>();
  final _addr2FormKey = GlobalKey<FormState>();
  final _postcodeFormKey = GlobalKey<FormState>();
  final _cityFormKey = GlobalKey<FormState>();
  final _stateFormKey = GlobalKey<FormState>();

  final _addr1Controller= TextEditingController();
  final _addr2Controller = TextEditingController();
  final _postcodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  
  String alertMsg = 'Empty Alert';

  String? _dropdownValue;
  List<String> dropdownStates = [
    'Kedah', 
    'Kelantan', 
    'Sabah',
    'Pahang',
    'Sarawak',
    'Perak',
    'Selangor',
    'N. Sembilan',
    'Terrenganu',
    'Johor',
    'P. Pinang',
    'Perlis',
    'Melaka',
    'W.P.Kuala Lumpur',
    ];
  
  

  _registerprocess(Map<String, dynamic>usermap) async {
    showLoadingDialog(
      title: "Adding User",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );
  
    String status = 'System Error : Register Process Failed';

    usermap['phoneno'] = usermap['phoneno'].replaceAll('-', '');
    
    BuildContext originalContext = context;
  
    Map<String, dynamic> registerUserMap = {
      'AddressLine1' : usermap['addr1'],
      'AddressLine2' : usermap['addr2'],
      'City' : usermap['city'],
      'Email' : usermap['email'],
      'FirstName' : usermap['firstname'],
      'LastLoggedIn' : DateTime.now(),
      'LastName' : usermap['lastname'],
      'OutletID' : 1000,
      'Password' : usermap['pw'],
      'PhoneNo' : usermap['phoneno'],
      'Postcode' : usermap['postcode'],
      'Role' : 'Staff',
      'State' : usermap['state'],
      'Status' : 'Pending',
      'Keywords' : [],
      'ImageURL' : '',
      'UserID' : 0,
    };
    // save original user
    
    alertMsg = await DatabaseMethods.addUserDetails(registerUserMap);

    Navigator.pop(originalContext);
    
    if(alertMsg.isEmpty){
      // when register success, bring user to dashboard

      // ignore: use_build_context_synchronously
      registerSuccess(originalContext);
    }
    else{
      // else show dialog message
      // ignore: use_build_context_synchronously
      registerFail(originalContext);
    }
    
    
  }
  
  registerSuccess(BuildContext oriContext){
    
    showAlertDialog(
      title: "Account Created Successfully",
      message: "Your account has been created successfully.\n\nYou will be able to login after account is verified by an admin.",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      bradius: 15,

      // button params
      
      btnText : "OK",
      btnFontSize: n2s,
      btnFontWeight: n2w,
      btnPx: 30,
      btnPy: 15,
      btnMb: 5,
      btnMr: 5,
      btnMl: 5,
      btnMt: 5,
      btnBradius: 15,
      btnBgColor: Theme.of(context).colorScheme.errorContainer,
      btnTextColor: Theme.of(context).colorScheme.onError,
      btnOnPressed: () => {
        Navigator.of(context).pop(),
        navigateTo(oriContext, widget, LandingPage(pageIndex: 4,), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
      );

      
  }

  
  registerFail(BuildContext oriContext){
    
    showAlertDialog(
      title: "Failed to Create Account",
      message: alertMsg,
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      bradius: 15,

      // button params
      
      btnText : "Back",
      btnFontSize: n2s,
      btnFontWeight: n2w,
      btnPx: 30,
      btnPy: 15,
      btnMb: 5,
      btnMr: 5,
      btnBradius: 15,
      btnOnPressed: () => {
        Navigator.of(context).pop(),
        navigateTo(oriContext, widget, LandingPage(pageIndex: 4), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
      btnBgColor: Theme.of(context).colorScheme.error,
      btnTextColor: Theme.of(context).colorScheme.onError,
      );

      
  }

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
              padding: EdgeInsets.fromLTRB((sWidth * 0.1), 0, (sWidth * 0.1), 0),
              child: Center(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//section 1
                    Container(
                      height: (0.2*sHeight),
                      child:
                      Row(
                        children: <Widget>[
                        BackButton(
                          onPressed: ()=> navigateTo(context, widget, AddUserDetailsPage(userDetails: widget.userDetails), animationType : 'scrollLeft'),
                        )
                        ]
                      ),
                    ),
                    
// section 2
                    Container(
                      child:

  // main column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

// sign up title
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                            child: 
                              Row(
                                children: <Widget>[
                                  createText(
                                    "Address Details",
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
                                    "Fill up user address details",
                                    fontSize: sub3s,
                                    fontWeight: sub3w,
                                    textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                  ),
                                ],
                              ),
                          ),
                          
                          
                          
// Address Line 1 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.00), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _addr1FormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. No. 1",
                                    labelText: "Address Line 1",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    mr: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _addr1Controller,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter address line 1";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),


                            ],
                          ),
                      ),



// Address Line 2 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, (sWidth * 0.05)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _addr2FormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. Keycondo, Boardstreet",
                                    labelText: "Address Line 2",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    mr: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _addr2Controller,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter address line 2";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),


                            ],
                          ),
                      ),
                      


// Postcode input
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _postcodeFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. 12345",
                                    labelText: "Postcode",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    mr: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _postcodeController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter \npostcode";
                                      }
                                      else if(!RegExp(r'^\d{5}$').hasMatch(value)){
                                        return "Please enter \nvalid postcode";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),

// city input
                              Expanded(child: 
                                Form(
                                  key: _cityFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. New York",
                                    labelText: "City",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    ml: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _cityController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter \ncity";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),


                            ],
                          ),
                      ),


                      
// state 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _stateFormKey,
                                  child:
                                  createFormDropdownMenu(
                                  hintText: "Select state",
                                  labelText: "State",
                                  bradius: 15,
                                  fontSize: n2s,
                                  fontWeight: n2w,
                                  textColor: Theme.of(context).colorScheme.onBackground,
                                  dropdownValue: _dropdownValue,
                                  dropdownItems: dropdownStates,
                                  onChanged: (value){
                                    setState((){
                                      _dropdownValue = value;
                                    });
                                  },
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Please select a state";
                                    }
                                    return null;
                                  }
                                  ),
                                ),
                              ),





                            ],
                          ),
                      ),
                      


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
                                    _addr1FormKey.currentState!.validate(), 
                                    _addr2FormKey.currentState!.validate(),
                                    _postcodeFormKey.currentState!.validate(),
                                    _cityFormKey.currentState!.validate(),
                                    _stateFormKey.currentState!.validate(),
                                    if(_addr1FormKey.currentState!.validate() && _addr2FormKey.currentState!.validate() && _postcodeFormKey.currentState!.validate() && _cityFormKey.currentState!.validate() && _stateFormKey.currentState!.validate()){
                                      _registerprocess({
                                      'email': widget.userDetails['email'],
                                      'pw': widget.userDetails['pw'],
                                      'firstname': widget.userDetails['firstname'], 
                                      'lastname' : widget.userDetails['lastname'], 
                                      'phoneno' : widget.userDetails['phoneno'], 
                                      'addr1' : _addr1Controller.text,
                                      'addr2' : _addr2Controller.text, 
                                      'postcode' : _postcodeController.text, 
                                      'city' : _cityController.text, 
                                      'state' : _dropdownValue 
                                      }),
                                    }
                                    // navigateTo(context, widget, SignUpAddrPage(
                                    //   userDetails: {
                                    //   'email': widget.userDetails['email'],
                                    //   'pw': widget.userDetails['pw'], 'firstname': widget.userDetails['firstname'], 'lastname' : widget.userDetails['lastname'], 'phoneno' : widget.userDetails['phoneno'], 'addr1' : _addr1Controller, 'addr2' : _addr2Controller, 'postcode' : _postcodeController, 'city' : _cityController, 'state' : _dropdownValue 
                                    //   }),
                                    //   animationType: 'scrollRight')
                                  },
                                  ),                               
                              ),


                            ],
                          ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 50), // set top and bottom padding
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child:
                                createButton(
                                  text: "Cancel",
                                  fontSize: n2s, 
                                  fontWeight: FontWeight.w600,
                                  textColor: Theme.of(context).colorScheme.primary, 
                                  letterSpacing: l2Space, 
                                  px: 30,
                                  py: 15, 
                                  bradius: 15,
                                  bColor: Theme.of(context).colorScheme.primary,
                                  bWidth: 1.2,
                                  bStyle: BorderStyle.solid,
                                  onPressed: () => {
                                    navigateTo(context, widget, LandingPage(pageIndex: 4),
                                      animationType: 'scrollLeft')
                                  },
                                  ),                               
                              ),

                            ],
                          ),
                      ),

                        ]
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ),
    );
  }
}