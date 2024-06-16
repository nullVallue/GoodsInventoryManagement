// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:stockapp/page/annonymous/forgotpw_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/annonymous/signup_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';
import 'package:stockapp/database/database.dart';

// ======================================================================
// Login Page
// ======================================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final _loginEmailFormKey = GlobalKey<FormState>();
  final _loginPwFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  
  authUser({required String email, required String pw}) async { 
    // authorisation and authentication of user occurs here
    showLoadingDialog(
      title: "Logging In",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );
    
    BuildContext oriContext = context;

    int loginResponse = 1;

    loginResponse = await Security.signIn(email: email, password: pw);
    
    Navigator.pop(oriContext);
    if(loginResponse == 0){
      // ignore: use_build_context_synchronously
      loginSuccess(oriContext);
    }
    else if(loginResponse == 2){
      // ignore: use_build_context_synchronously
      loginFail(oriContext, "Account not activated,\nPlease contact an admin");
    }
    else if(loginResponse == 3){
      loginFail(oriContext, "A verification link has been sent to your email,\n\nPlease verify your account to access the system.");
    }
    else{ // invalid email
      // ignore: use_build_context_synchronously
      loginFail(oriContext, "Invalid Email or Password\nPlease try again");
    }

  }
  
  loginSuccess(BuildContext oriContext){
    FocusScope.of(context).unfocus();
    Future.delayed(Duration(milliseconds: 500));
    navigateTo(oriContext, widget, LandingPage(), animationType: "scrollRight");
  }

  loginFail(BuildContext oriContext, String message){
    FocusScope.of(context).unfocus();
    showAlertDialog(
      title: "Login Failed",
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
        Navigator.of(context).pop(),
      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
      btnBgColor: Theme.of(context).colorScheme.error,
      btnTextColor: Theme.of(context).colorScheme.onError,
      );
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: 
      WillPopScope(onWillPop: () async {return false;},
        child:
      SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child:
      Padding(
        padding: EdgeInsets.fromLTRB((sWidth * 0.10), 0, (sWidth * 0.10), 0), // set left and right padding
        child: Center(

//main column 
          child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

//first expand
              Container(
                height: (0.2*sHeight),
                child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.15), 0, 0), // set top and bottom padding
                        child:
                        Transform.translate( //move object to the right
                          offset: Offset(-(sWidth * 0.40), -(sHeight * 0.005)),
                          child:
                           Container( //background shape
                            width: 400,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                         
                        ),

                      ),
                    ],
                  ),
              ),
             
            
//end of first expand
            
//Middle Expand
              Container(
                child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      
        //login heading 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Login",
                                fontSize: h2s,
                                fontWeight: h2w,
                                textColor: Theme.of(context).colorScheme.onBackground,
                                ),
                            ],
                          ),
                      ),

        //login subtitle 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.10)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Please login to continue",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),

        // email label and textfield
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(5, 0, 0, 0), // set top and bottom padding
                      //   child: 
                      //     Row(
                      //       children: <Widget>[
                      //         createText(
                      //           "Email",
                      //           fontSize: n2s,
                      //         ),
                      //       ],
                      //     ),
                      // ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.05)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              Expanded(child: 
                                Form(
                                  key: _loginEmailFormKey,
                                  child:
                                  createFormTextField(
                                    labelText: "Email",
                                    hintText: "e.g. Example@email.com",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _emailController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter email";
                                      }
                                      else{
                                        return null;
                                      }
                                    }
                                    ),
                                ),
                              ),
                            ],
                          ),
                      ),
        ////////////////////////////////////////////////////////////////////////////////////////////////////////

        // password label and textfield
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(5, 10, 0, 0), // set top and bottom padding
                      //   child: 
                      //     Row(
                      //       children: <Widget>[
                      //         createText(
                      //           "Password",
                      //           fontSize: n2s,
                      //         ),
                      //       ],
                      //     ),
                      // ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              Expanded(child: 
                                Form(
                                  key: _loginPwFormKey,
                                  child:
                                  TextFormField(
                                    controller: _pwController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter password";
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
                                        onPressed: () => {
                                          setState(() => _isPasswordVisible = !_isPasswordVisible
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

// forgot password
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0), // set top and bottom padding
                      child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          createLink(
                            text: "Forgot Password",
                            textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                            fontSize: n3s,
                            fontWeight: n3w,
                            textDecor: TextDecoration.underline,
                            onTap: ()=> {
                              
                              navigateTo(context, widget, ForgotPwPage(), animationType: "scrollRight")},
                            ),
                        ],
                      ),
                    ),
// login button
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child:
                                  createButton(
                                  text: "Login",
                                  fontSize: n2s, 
                                  fontWeight: n2w,
                                  bgColor: Theme.of(context).colorScheme.primary, 
                                  textColor: Theme.of(context).colorScheme.onPrimary, 
                                  letterSpacing: l2Space, 
                                  px: 30,
                                  py: 15, 
                                  bradius: 15,
                                  onPressed: () => {
                                    _loginPwFormKey.currentState!.validate(),
                                    _loginEmailFormKey.currentState!.validate(),
                                    if(_loginPwFormKey.currentState!.validate() && _loginEmailFormKey.currentState!.validate()){
                                      authUser(email: _emailController.text, pw: _pwController.text)
                                    }
                                  },
                                  ),
                              ),
                            ],
                          ),
                      ),
                    
// or divider 
                    Center(
                      child:
                      createText("or", fontSize: n2s, fontWeight: n2w, textColor: Theme.of(context).colorScheme.onTertiaryContainer, mt: 25, mb: 25),
                    ),

// sign up button
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, (sWidth * 0.0), 0, (sWidth * 0.0)), // set top and bottom padding
                      child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                              Expanded(
                                child:
                                  createButton(
                                  text: "Sign Up",
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
                                    navigateTo(context, widget, SignUpPage(), animationType: 'scrollDown')
                                  },
                                  ),
                              ),

                          
                        ],
                      ),
                    ),
                    ]
                  ), 
              ),
//end of middle expand

//last expand
//               Container(
//                 height: (0.1*sHeight),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[

// // sign up link                    
                    

//                   ],
//                 ),
//               ),

//end of last expand


            ],
          )
          
// end of main col

        ),
      ),
// end of main padding 
),
      )


    );
  }
}
//=======================================================================================
