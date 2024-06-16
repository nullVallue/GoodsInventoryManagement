// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/product/addproductsupplier_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});
  

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage>{
  
  final _nameFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final _priceFormKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  // List<DropdownMenuItem<String>> managerList = [];
  File? productImage;


  Future<void> loadManagerDropdown() async {
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


  Future uploadFromGallery() async {
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
    File? image = await DeviceIOMethods.pickImageFromGallery();

    if(image != null){
      setState(() {
        productImage = image;
      });
      Navigator.pop(context);
    }
    else{
      uploadFail(context);
      Navigator.pop(context);
      return;
    }
  }

  Future uploadFromCamera() async {
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

    File? image = await DeviceIOMethods.pickImageFromCamera();

    if(image != null){
      setState(() {
        productImage = image;
      });
      Navigator.pop(context);
    }
    else{
      uploadFail(context);
      Navigator.pop(context);
      return;
    }
  }

  uploadFail(BuildContext oriContext){
    
    showAlertDialog(
      title: "Failed to Upload Picture",
      message: "Failed to picture for product",
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


  @override
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:
      FutureBuilder(
        future: loadManagerDropdown(),
        builder: (context, snapshot) {
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
                          onPressed: ()=> navigateTo(context, widget, LandingPage(pageIndex: 1,), animationType : 'scrollLeft'),
                        )
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
                      
        //sign up heading 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Add a Product",
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
                                "Add a new product to the system",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),

// product image
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
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
                                child:
                                Container(
                                  height: sWidth * 0.50,
                                  constraints: BoxConstraints(
                                    maxWidth: sWidth * 0.5,
                                    maxHeight: sWidth*0.5,
                                    minWidth: sWidth * 0.5,
                                    minHeight: sWidth*0.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child:
                                  (productImage != null)?
                                  Image.file(productImage!)
                                  :
                                  Center(
                                    child:
                                    Icon(
                                      Icons.add_a_photo_rounded,
                                      size: 30,
                                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                                      ),
                                  )
                                ),
                              

                              )
                            ],
                          ),
                      ),

        ////////////////////////////////////////////////////////////////////////////////////////////////////////


                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, sWidth*0.08), // set top and bottom padding
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              createText(
                                'Add Image (Optional)',
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),
        ////////////////////////////////////////////////////////////////////////////////////////////////////////

// product text field
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              Expanded(child: 
                                Form(
                                  key: _nameFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. iPhone 12 Pro",
                                    labelText: "Product Name",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _nameController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter supplier email";
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

// product price
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              Expanded(child: 
                                Form(
                                  key: _priceFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. 1000",
                                    labelText: "Unit Price",
                                    bradius: 15,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _priceController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter unit price";
                                      }

                                      try {
                                        double parsedValue = double.parse(value);
                                        bool isNan = parsedValue.isNaN;
                                        if (isNan) {
                                          return 'Please enter a valid quantity';
                                        }

                                        if(parsedValue < 0){
                                          return 'Please enter a valid quantity';
                                        }
                                      } 
                                      catch (e) {
                                        return 'Please enter a valid quantity';
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


        ////////////////////////////////////////////////////////////////////////////////////////////////////////


// next button
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
                                    _nameFormKey.currentState!.validate(), 
                                    _priceFormKey.currentState!.validate(), 
                                    if(_nameFormKey.currentState!.validate() && _priceFormKey.currentState!.validate()){
                                      navigateTo(context, widget, AddProductSupplierPage( 
                                        productMap: {
                                        'ProductName' : _nameController.text,
                                        'Price' : double.parse(_priceController.text),
                                      }, productImage: productImage))
                                    },
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