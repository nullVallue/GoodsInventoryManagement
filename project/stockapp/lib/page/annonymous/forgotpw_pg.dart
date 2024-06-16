
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/annonymous/login_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class ForgotPwPage extends StatefulWidget {
  const ForgotPwPage({super.key});
  

  @override
  State<ForgotPwPage> createState() => _ForgotPwPageState();
}

class _ForgotPwPageState extends State<ForgotPwPage>{
  
  final _emailFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  authUser() async { // authorisation and authentication of user occurs here
    showLoadingDialog(
      title: "Processing..",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );
    BuildContext oriContext = context;
    String errMsg = await Auth().resetPassword(_emailController.text);

    Navigator.pop(oriContext);
    if(errMsg == ''){
      sendSuccess(oriContext);
    }
    else{
      sendFail(oriContext, errMsg);
    }


  }


  sendSuccess(BuildContext oriContext){
    FocusScope.of(oriContext).unfocus();
    showAlertDialog(
      title: "Reset Success",
      message: 'Reset link has been sent to your email',
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
      btnMt: 5,
      btnMl: 5,
      btnBradius: 15,
      btnOnPressed: () => {
        Navigator.of(oriContext).pop(),
        navigateTo(oriContext, widget, LoginPage(), animationType : 'scrollLeft')
      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
      btnBgColor: Theme.of(context).colorScheme.errorContainer,
      btnTextColor: Theme.of(context).colorScheme.onError,
      );
  }

  sendFail(BuildContext oriContext, String message){
    FocusScope.of(oriContext).unfocus();
    showAlertDialog(
      title: "Reset Failed",
      message: message,
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
      btnMt: 5,
      btnMl: 5,
      btnBradius: 15,
      btnOnPressed: () => {
        Navigator.of(oriContext).pop(),
        // navigateTo(oriContext, widget, LoginPage(), animationType : 'scrollLeft')
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
// section 1
                    Container(
                      height: (0.2*sHeight),
                      child:
                      Row(
                        children: <Widget>[
                        BackButton(
                          onPressed: ()=> navigateTo(context, widget, LoginPage(), animationType : 'scrollLeft'),
                        )
                        ]
                      ),
                    ),



// section 2
                    Container(
                      height: (0.6*sHeight),                child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      
        //forgot pw heading 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Forgot Password",
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
                                "Enter email to recover password",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),

        // email label and textfield

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              Expanded(child: 
                                Form(
                                  key: _emailFormKey,
                                  child:
                                  createFormTextField(
                                    labelText: "Email",
                                    hintText: "Example@email.com",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _emailController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter email";
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

// recover button
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              createButton(
                                text: "Recover",
                                fontSize: n2s, 
                                fontWeight: n2w,
                                bgColor: Theme.of(context).colorScheme.primary, 
                                textColor: Theme.of(context).colorScheme.onPrimary, 
                                letterSpacing: l2Space, 
                                px: 30,
                                py: 15, 
                                bradius: 15,
                                onPressed: () => {
                                  
                                  if(_emailFormKey.currentState!.validate()){
                                    authUser()
                                  }
                                },
                                ),
                            ],
                          ),
                      ),
                    ]
                  ),
                    ),
// section 3
                    Container(
                      height: (0.2*sHeight),
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