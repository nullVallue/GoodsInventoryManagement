// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/autocounter/acinvresult_pg.dart';
import 'package:stockapp/page/authenticated/autocounter/acpurchaseitemresult_pg.dart';
import 'package:stockapp/page/authenticated/autocounter/acstockmvmtresult_pg.dart';
import 'package:stockapp/page/authenticated/product/editproductdetails_pg.dart';
import 'package:stockapp/page/authenticated/product/viewproductsupplier_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/purchase/viewpurchasedetails_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

import 'package:http/http.dart' as http;

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();

}

class _PlaygroundState extends State<Playground>{


  File? uploadimage;
  Map additionalData = {};
  bool uploaded = false;


  late Uint8List base64DecodeStr;

  @override
  void initState(){
    super.initState();
  }


  Future<void> loadDetails() async {


  }

  Future<void> uploadImage(File image) async {


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
      
    // final String url = 'http://34.101.253.202:8081/predict';

    try{
    String base64Image = base64Encode(uploadimage!.readAsBytesSync());

    var response = await http.post(
      Uri.parse(yoloURL),
      body: jsonEncode({'image' : base64Image}),
      headers: {'Content-Type' : 'application/json'},
    );

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      setState(() {
        base64DecodeStr = base64Decode(data['resultImage']);
        uploaded = true;
      });

      print(data['length']);
    }
    else{
      print('Failed');
    }

    }
    catch(e){

      print('Error Here: $e');
    }



    Navigator.pop(oriContext);
  }



  void updatePic(File imageFile) async {

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


    setState(() {
      uploadimage = imageFile;
    });

    Navigator.pop(context);
  }

  Future uploadFromGallery() async {
    File? image = await DeviceIOMethods.pickImageFromGallery();

    if(image != null){
      // ignore: use_build_context_synchronously
      updatePic(image);
    }
    else{
      return;
    }
  }

  Future uploadFromCamera() async {
    File? image = await DeviceIOMethods.pickImageFromCamera();
    if(image != null){
      updatePic(image);
    }
    else{
      return;
    }
  }

  uploadFail(BuildContext oriContext){
    
    showAlertDialog(
      title: "Failed to Update Picture",
      message: "Failed to upload picture",
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

  void count(){
    showTextLoadingDialog(
      title: "Counting...",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
      message: 'This may take a few minutes...',
    );

    BuildContext oriContext = context;

    // call api


    Navigator.of(oriContext).pop();

    // process and pass result to next page
    // navigateTo(context, widget, ACInvResultPage(resultImage: uploadimage!, resultQty: 50, invMap: widget.invMap, productDetails: productDetails), animationType: 'scrollRight');




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
        future: loadDetails(),
        builder: (context, snapshot){
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
                        // BackButton(
                        //   onPressed: ()=> navigateTo(context, widget, LandingPage(pageIndex: 3), animationType: 'scrollLeft'),
                        // ),
                        Spacer(),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.person_rounded),
                        //   onPressed: (){
                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => UserFullDetailsPage(userDetails: userDetails,)));
                        //   },
                        //   color: Theme.of(context).colorScheme.onBackground,
                        // ),
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



                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                SizedBox(
                                  // height: sWidth * 0.50,
                                  width: sWidth * 0.8,
                                  height: sWidth * 0.7,
                                  child:
                                  (uploadimage != null)?
                                    Image.file(uploadimage!, fit: BoxFit.cover)
                                  :
                                  Container(
                                    color: Theme.of(context).colorScheme.secondary,
                                    child:
                                    Center(
                                      child:
                                      Icon(
                                        Icons.add_a_photo_rounded,
                                        size: 30,
                                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                                        ),
                                    )
                                  )
                                ),
                            )




                                  ),
                                ],
                              ),
                          ),




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



                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                SizedBox(
                                  // height: sWidth * 0.50,
                                  width: sWidth * 0.8,
                                  height: sWidth * 0.7,
                                  child:
                                  (uploaded)?
                                    Image.memory(base64DecodeStr)
                                  :
                                  SizedBox.shrink()
                                ),
                            )




                                  ),
                                ],
                              ),
                          ),


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
                                      text: "Add Picture For Counting",
                                      fontSize: n2s, 
                                      fontWeight: FontWeight.w600,
                                      textColor: Theme.of(context).colorScheme.primary, 
                                      letterSpacing: l2Space, 
                                      py: 15,
                                      bradius: 15,
                                      bColor: Theme.of(context).colorScheme.primary,
                                      bWidth: 1.2,
                                      bStyle: BorderStyle.solid,
                                      // endingIcon: Icons.arrow_forward_ios_rounded,
                                      onPressed: () => {
                                        showModalBottomSheet(
                                          backgroundColor: Theme.of(context).colorScheme.secondary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          context: context, 
                                          builder: (BuildContext context){
                                            return displayModalBottomSheet();
                                          },
                                        )
                                      },
                                      ),
                                  ),



                                ],
                              ),
                          ),


                          (uploadimage == null)?
                          SizedBox.shrink()
                          :
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 20), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Expanded(
                                    child: 
                                      createButton(
                                      text: "Start Counting",
                                      fontSize: n2s, 
                                      fontWeight: n2w,
                                      bgColor: Theme.of(context).colorScheme.primary, 
                                      textColor: Theme.of(context).colorScheme.onPrimary, 
                                      letterSpacing: l2Space, 
                                      px: 30,
                                      py: 15, 
                                      bradius: 15,
                                      // endingIcon: Icons.arrow_forward_ios_rounded,
                                      onPressed: () => {
                                        uploadImage(uploadimage!)
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