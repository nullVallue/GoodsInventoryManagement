
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/profile/editprofileaccount_pg.dart';
import 'package:stockapp/page/authenticated/profile/editprofileaddr_pg.dart';
import 'package:stockapp/page/authenticated/profile/editprofilepersonal_pg.dart';
import 'package:stockapp/page/authenticated/user/edituseraccount_pg.dart';
import 'package:stockapp/page/authenticated/user/edituseraddress_pg.dart';
import 'package:stockapp/page/authenticated/user/edituserpersonal_pg.dart';
import 'package:stockapp/page/authenticated/user/userfulldetails_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class EditProfileMenuPage extends StatefulWidget {
  const EditProfileMenuPage({super.key});

  @override
  State<EditProfileMenuPage> createState() => _EditProfileMenuPageState();
}

class _EditProfileMenuPageState extends State<EditProfileMenuPage>{

  Map<String, dynamic> userDetails = {};
  String userEmail = '';


  @override
  void initState(){
    super.initState();
    userEmail = sessionUser['Email'];
  }


  Future<void> loadUserDetails() async {
    userDetails = await DatabaseMethods.getUserByEmailAsMap(userEmail);
  }


  void updateProfilePic(File imageFile) async {
    showLoadingDialog(
      title: "Uploading Image",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );

    String successMsg = '';
    successMsg = await FirebaseStorageMethods.uploadUserImage(imageFile, userDetails['UserID'].toString()); 

    BuildContext oriContext = context;


    if(successMsg.isEmpty || successMsg == ''){
      Navigator.pop(context);
      uploadFail(oriContext);
    }
    else{
      Navigator.pop(context);
      setState(() {
        userDetails['ImageURL'] = successMsg;
      });
      DatabaseMethods.updateUserDetails(userDetails);
      uploadSuccess(oriContext);
    }
  }

  Future uploadFromGallery() async {
    File? image = await DeviceIOMethods.pickImageFromGallery();

    if(image != null){
      // ignore: use_build_context_synchronously
      updateProfilePic(image);
    }
    else{
      return;
    }
  }

  Future uploadFromCamera() async {
    File? image = await DeviceIOMethods.pickImageFromCamera();
    if(image != null){
      updateProfilePic(image);
    }
    else{
      return;
    }
  }

  uploadFail(BuildContext oriContext){
    
    showAlertDialog(
      title: "Failed to Update Profile Picture",
      message: "Failed to upload profile picture",
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

      },
      btnBgColor: Theme.of(context).colorScheme.error,
      btnTextColor: Theme.of(context).colorScheme.onError,
      );

      
  }

  uploadSuccess(BuildContext oriContext){
    
    showAlertDialog(
      title: "Picture uploaded successfully",
      message: "Your picture has been uploaded successfully",
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

      },
    );

  }

  Widget displayModalBottomSheet(){
    return
    Container(
      height: 250,
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          SizedBox(height: 40,),

          InkWell(
            onTap: (){
              Navigator.pop(context);
              uploadFromGallery();
            },
            child: 
            Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.image_rounded,
                    size: 35,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  createText(
                    'Upload From Gallery',
                    fontSize: h4s,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    ml: 30,
                  )
                ],
              )
            ),
          ),

          SizedBox(height: 20,),

          InkWell(
            onTap: (){
              Navigator.pop(context);
              uploadFromCamera();
            },
            child: 
            Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.photo_camera,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: 35,
                  ),
                  createText(
                    'Take From Camera',
                    fontSize: h4s,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    ml: 30,
                  )
                ],
              )
            ),
          )


        ],
      ),
    );
  }


  @override
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:
      FutureBuilder(
        future: loadUserDetails(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            if(userDetails.isEmpty){
              return Center(
                child: 
                  LoadingAnimationWidget.stretchedDots(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  ),
              );
            }
          }
          else if(snapshot.hasError){
            return Center(
              child: 
              createText('Error ${snapshot.error}')
            );
          }
        return
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
                          onPressed: ()=> navigateTo(context, widget, LandingPage(pageIndex: 0,), animationType : 'scrollLeft'),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.person_rounded),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserFullDetailsPage(userDetails: userDetails,)));
                          },
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        ]
                      ),
                    ),
// section 2
                    Container(
                      // height: (sHeight * 0.6),
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  


                                  InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: (){
                                      showModalBottomSheet(
                                        backgroundColor: Theme.of(context).colorScheme.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        context: context, 
                                        builder: (BuildContext context){
                                          return displayModalBottomSheet();
                                        },
                                      );
                                    },
                                    highlightColor: Colors.transparent,
                                    child:
                                    (userDetails['ImageURL']!='')?
                                    ProfilePicture(
                                      name: '${userDetails['FirstName']} ${userDetails['LastName']}',
                                      radius: 70,
                                      fontsize: 25,
                                      img: userDetails['ImageURL'],
                                      // random: true,
                                    )
                                    :
                                    ProfilePicture(
                                      name: '${userDetails['FirstName']} ${userDetails['LastName']}',
                                      radius: 70,
                                      fontsize: 25,
                                      // random: true,
                                    ),

                                  ),
                                ],
                              ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  createText(
                                    userDetails['FirstName'],
                                    fontSize: h3s,
                                    fontWeight: h2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    ),
                                  createText(
                                    ' ' + userDetails['LastName'],
                                    fontSize: h3s,
                                    fontWeight: h2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    ),
                                ],
                              ),
                          ),




                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  createText(
                                    userDetails['Email'],
                                    fontSize: sub3s,
                                    fontWeight: sub3w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                  ),
                                ],
                              ),
                          ),



                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  createText(
                                    userDetails['Role'],
                                    fontSize: sub3s,
                                    fontWeight: sub3w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                  ),
                                ],
                              ),
                          ),



// edit account details button
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(0, 50, 0, 20), // set top and bottom padding
                          //   child: 
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: <Widget>[

                          //         Expanded(
                          //           child: 
                          //             createButton(
                          //             text: "Edit Account Details",
                          //             fontSize: n2s, 
                          //             fontWeight: FontWeight.w600,
                          //             textColor: Theme.of(context).colorScheme.primary, 
                          //             letterSpacing: l2Space, 
                          //             py: 15,
                          //             bradius: 15,
                          //             bColor: Theme.of(context).colorScheme.primary,
                          //             bWidth: 1.2,
                          //             bStyle: BorderStyle.solid,
                          //             endingIcon: Icons.arrow_forward_ios_rounded,
                          //             iconOffset: 20,
                          //             onPressed: () => {
                          //               navigateTo(context, widget, EditProfileAccountPage(editUserMap: userDetails), animationType : 'scrollRight')
                          //             },
                          //             ),
                          //         ),

                          //       ],
                          //     ),
                          // ),




// edit account details button
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 50, 0, 20), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Expanded(
                                    child: 
                                      createButton(
                                      text: "Edit Personal Details",
                                      fontSize: n2s, 
                                      fontWeight: FontWeight.w600,
                                      textColor: Theme.of(context).colorScheme.primary, 
                                      letterSpacing: l2Space, 
                                      py: 15,
                                      bradius: 15,
                                      bColor: Theme.of(context).colorScheme.primary,
                                      bWidth: 1.2,
                                      bStyle: BorderStyle.solid,
                                      endingIcon: Icons.arrow_forward_ios_rounded,
                                      iconOffset: 20,
                                      onPressed: () => {
                                        navigateTo(context, widget, EditProfilePersonalPage(editUserMap: userDetails), animationType : 'scrollRight')
                                      },
                                      ),
                                  ),

                                ],
                              ),
                          ),


// edit account details button
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Expanded(
                                    child: 
                                      createButton(
                                      text: "Edit Address Details",
                                      fontSize: n2s, 
                                      fontWeight: FontWeight.w600,
                                      textColor: Theme.of(context).colorScheme.primary, 
                                      letterSpacing: l2Space, 
                                      py: 15,
                                      bradius: 15,
                                      bColor: Theme.of(context).colorScheme.primary,
                                      bWidth: 1.2,
                                      bStyle: BorderStyle.solid,
                                      endingIcon: Icons.arrow_forward_ios_rounded,
                                      iconOffset: 20,
                                      onPressed: () => {
                                        navigateTo(context, widget, EditProfileAddressPage(editUserMap: userDetails), animationType : 'scrollRight')
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
        );

        }

      ),

    );
  }
}