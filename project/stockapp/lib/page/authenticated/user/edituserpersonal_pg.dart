// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/user/editusermenu_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class EditUserPersonalPage extends StatefulWidget {
  final Map<String, dynamic> editUserMap;
  const EditUserPersonalPage({super.key, required this.editUserMap});
  

  @override
  State<EditUserPersonalPage> createState() => _EditUserPersonalPageState();
}

class _EditUserPersonalPageState extends State<EditUserPersonalPage>{
  
  
  final _firstNameFormKey = GlobalKey<FormState>();
  final _lastNameFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();


  final FocusNode firstNameFocusNode = FocusNode();

  bool editBtnVisible = true;

  @override
  void initState(){
    super.initState();
    _firstNameController.text = widget.editUserMap['FirstName'];
    _lastNameController.text = widget.editUserMap['LastName'];
    _phoneController.text = widget.editUserMap['PhoneNo'];
  }

  void update(String firstName, String lastName, String phoneno) async {
    showLoadingDialog(
      title: "Updating",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );



    Map<String, dynamic> updateMap = widget.editUserMap;

    BuildContext oriContext= context;

    String alertMsg = '';

    if(updateMap['Email'] != null){
      updateMap['FirstName'] = firstName;
      updateMap['LastName'] = lastName;
      updateMap['PhoneNo'] = phoneno;
    }
    else{
      Navigator.pop(oriContext);
      updateFail(oriContext, "Account Update Failed");
      return;
    }

    Navigator.pop(oriContext);
    alertMsg = await DatabaseMethods.updateUserDetails(updateMap);


    if(alertMsg.isEmpty){
      // when register success, bring user to dashboard

      // ignore: use_build_context_synchronously
      updateSuccess(oriContext);
    }
    else{
      // else show dialog message
      // ignore: use_build_context_synchronously
      updateFail(oriContext, alertMsg);
    }

  }


  updateSuccess(BuildContext oriContext){

    showAlertDialog(
      title: "Update Success",
      message: "Details have neen updated successfully",
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
        // navigateTo(oriContext, widget, LandingPage(pageIndex: 4,), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
    );
  }

  updateFail(BuildContext oriContext, String errMsg){

    showAlertDialog(
      title: "Update Failed",
      message: "Error: $errMsg",
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
      btnBgColor: Theme.of(context).colorScheme.error,
      btnTextColor: Theme.of(context).colorScheme.onError,
      btnOnPressed: () => {
        Navigator.of(context).pop(),
        // navigateTo(oriContext, widget, LandingPage(pageIndex: 4,), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
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
                          onPressed: ()=> navigateTo(context, widget, EditUserMenuPage(editUserEmail: widget.editUserMap['Email']), animationType : 'scrollLeft'),
                        )
                        ]
                      ),
                    ),
// section 2
                    Container(
                      height: (sHeight * 0.6),
                      child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[


        //Edit title
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Edit Personal \nDetails",
                                fontSize: h2s,
                                fontWeight: h2w,
                                textColor: Theme.of(context).colorScheme.onBackground,
                                ),
                            ],
                          ),
                      ),


        //Edit subtitle 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.10)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Edit name and phone number",
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
                                    enabled: !editBtnVisible,
                                    focusNode: firstNameFocusNode,
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
                                    enabled: !editBtnVisible,
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
                                    enabled: !editBtnVisible,
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



// edit button
                      Visibility(
                        visible: editBtnVisible,
                        child:
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, (sWidth * 0.1), 0, (sWidth * 0.01)), // set top and bottom padding
                          child: 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child:
                                  createButton(
                                    text: "Edit",
                                    fontSize: n2s, 
                                    fontWeight: n2w,
                                    bgColor: Theme.of(context).colorScheme.primary, 
                                    textColor: Theme.of(context).colorScheme.onPrimary, 
                                    letterSpacing: l2Space, 
                                    px: 30,
                                    py: 15, 
                                    bradius: 15,
                                    onPressed: () => {
                                      setState((){
                                        editBtnVisible = false;
                                      }),
                                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                                        firstNameFocusNode.requestFocus();
                                      }),
                                    },
                                    ),                               
                                ),

                              ],
                            ),
                        ),
                      ),


// cancel button
                      Visibility(
                        visible: !editBtnVisible,
                        child:
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, (sWidth * 0.1), 0, (sWidth * 0.01)), // set top and bottom padding
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
                                    setState((){
                                      editBtnVisible = true;
                                      _firstNameController.text = widget.editUserMap['FirstName'];
                                      _lastNameController.text = widget.editUserMap['LastName'];
                                      _phoneController.text = widget.editUserMap['PhoneNo'];
                                    }),
                                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                                      FocusScope.of(context).unfocus();
                                    }),
                                  },
                                  ),
                                ),

                              ],
                            ),
                        ),
                      ),

// confirm button
                      Visibility(
                        visible: !editBtnVisible,
                        child: 
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, (sWidth * 0.01)), // set top and bottom padding
                          child: 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child:
                                  createButton(
                                    text: "Confirm",
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
                                        if(_firstNameController.text == widget.editUserMap['FirstName'] && _lastNameController.text == widget.editUserMap['LastName'] && _phoneController.text == widget.editUserMap['PhoneNo']){
                                          setState((){
                                            editBtnVisible = true;
                                          }),
                                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                                            FocusScope.of(context).unfocus();
                                          }),
                                        }
                                        else{
                                          setState((){
                                            editBtnVisible = true;
                                          }),
                                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                                            FocusScope.of(context).unfocus();
                                          }),
                                          update(_firstNameController.text, _lastNameController.text, _phoneController.text)
                                        }

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
                      )
                      
                      
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

  @override
  void dispose(){
    firstNameFocusNode.dispose();
    super.dispose();
  }
}