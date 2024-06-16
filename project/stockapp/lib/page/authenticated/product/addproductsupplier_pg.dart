
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/product/addproduct_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class AddProductSupplierPage extends StatefulWidget {
  final Map<String, dynamic> productMap;
  final File? productImage;
  const AddProductSupplierPage({super.key, required this.productMap, required this.productImage});
  

  @override
  State<AddProductSupplierPage> createState() => _AddProductSupplierPageState();
}

class _AddProductSupplierPageState extends State<AddProductSupplierPage>{
  
  final _supplierFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  final _existSupplierFormKey = GlobalKey<FormState>();
  final _supplierController = TextEditingController();
  final _nameController = TextEditingController();

  bool ddlVisible = true;


  String? _dropdownSupplierValue;

  List<String> supplierList = [];


  Future<void> loadDropdown() async {
    supplierList = await DatabaseMethods.getSupplierList();
  }

  addProduct(String supplierEmail, String supplierName) async {
    showLoadingDialog(
      title: "Adding Product",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );

    String alertMsg = '';
    String sAlertMsg = '';
  
    BuildContext originalContext = context;

    Map<String, dynamic> productMap = {
      'ProductName' : widget.productMap['ProductName'],
      'ProductID' : 0,
      'ProductImgPath' : '',
      'Status' : 'Inactive',
      'Price' : widget.productMap['Price'], 
    };
    if(ddlVisible){
      alertMsg = await DatabaseMethods.addProductDetails(productMap, _dropdownSupplierValue!, widget.productImage);
    }
    else{
      Map<String, dynamic> supplierMap = {
        'SupplierID' : 0,
        'SupplierName' : supplierName,
        'SupplierEmail': supplierEmail,
      };

      sAlertMsg = await DatabaseMethods.addSupplierDetails(supplierMap);
      if(sAlertMsg == ''){
        alertMsg = await DatabaseMethods.addProductDetails(productMap, supplierName, widget.productImage);
      }

    }
      // ignore: use_build_context_synchronously
    Navigator.pop(originalContext);

    if(alertMsg.isEmpty && sAlertMsg.isEmpty){
      // ignore: use_build_context_synchronously
      createSuccess(originalContext);
    }
    else{
      // else show dialog message
      if(alertMsg.isEmpty){
      // ignore: use_build_context_synchronously
        createFail(originalContext, sAlertMsg);
      }
      else if(sAlertMsg.isEmpty){
      // ignore: use_build_context_synchronously
        createFail(originalContext, alertMsg);
      }
    }

  }



  createSuccess(BuildContext oriContext){
    
    showAlertDialog(
      title: "Product Added Successfully",
      message: "Product has been created successfully",
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
        navigateTo(oriContext, widget, LandingPage(pageIndex: 1,), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
      );

      
  }

  
  createFail(BuildContext oriContext, String alertMsg){
    
    showAlertDialog(
      title: "Failed to Add Product",
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
        navigateTo(oriContext, widget, LandingPage(pageIndex: 1), animationType: "scrollLeft"),
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
      FutureBuilder(
        future: loadDropdown(),
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
                          onPressed: ()=> navigateTo(context, widget, AddProductPage(), animationType : 'scrollLeft'),
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
                                "Product Supplier",
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
                                "Selecte existing supplier or add \na new supplier",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),



        ////////////////////////////////////////////////////////////////////////////////////////////////////////

// supplier ddl
                    Visibility(
                      visible: ddlVisible,
                      child: 

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _existSupplierFormKey,
                                  child:
                                  createFormDropdownMenu(
                                  hintText: "Select a supplier",
                                  labelText: "Suppliers",
                                  bradius: 15,
                                  fontSize: n2s,
                                  fontWeight: n2w,
                                  textColor: Theme.of(context).colorScheme.onBackground,
                                  dropdownValue: _dropdownSupplierValue,
                                  dropdownItems: supplierList,
                                  onChanged: (value){
                                    setState(() {
                                      _dropdownSupplierValue = value;
                                    });
                                  },
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Please select a supplier";
                                    }
                                    return null;
                                  }
                                  ),
                                ),
                              ),


                            ],
                          ),
                      ),

                    ),


        ////////////////////////////////////////////////////////////////////////////////////////////////////////
// new supplier name text field
                    Visibility(
                      visible: !ddlVisible,
                      child: 
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
                                    hintText: "e.g. Foxconn Co.",
                                    labelText: "Supplier Name",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _nameController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter supplier name";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
        ////////////////////////////////////////////////////////////////////////////////////////////////////////

// new supplier email text field
                    Visibility(
                      visible: !ddlVisible,
                      child: 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              Expanded(child: 
                                Form(
                                  key: _supplierFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. appleseed@apple.com",
                                    labelText: "Supplier Email",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _supplierController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter supplier email";
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
                    ),
        ////////////////////////////////////////////////////////////////////////////////////////////////////////


// edit button
                      Visibility(
                        visible: ddlVisible,
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
                                    text: "Use New Supplier",
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
                                        ddlVisible = false;
                                      }),
                                    },
                                    ),                               
                                ),

                              ],
                            ),
                        ),
                      ),



// use existing button
                      Visibility(
                        visible: !ddlVisible,
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
                                  text: "Use Existing Supplier",
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
                                      ddlVisible = true;
                                    }),
                                  },
                                  ),
                                ),

                              ],
                            ),
                        ),
                      ),

        ////////////////////////////////////////////////////////////////////////////////////////////////////////


// Add button
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.1), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child:
                                 createButton(
                                  text: "Add",
                                  fontSize: n2s, 
                                  fontWeight: n2w,
                                  bgColor: Theme.of(context).colorScheme.primary, 
                                  textColor: Theme.of(context).colorScheme.onPrimary, 
                                  letterSpacing: l2Space, 
                                  px: 30,
                                  py: 15, 
                                  bradius: 15,
                                  onPressed: () => {
                                    if(ddlVisible){
                                      _existSupplierFormKey.currentState!.validate(), 
                                      if(_existSupplierFormKey.currentState!.validate()){
                                        addProduct(_dropdownSupplierValue??'', ''),
                                      }
                                    }
                                    else{
                                      _nameFormKey.currentState!.validate(), 
                                      _supplierFormKey.currentState!.validate(),
                                      if(_supplierFormKey.currentState!.validate() && _nameFormKey.currentState!.validate()){
                                        addProduct(_supplierController.text, _nameController.text)
                                      }
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