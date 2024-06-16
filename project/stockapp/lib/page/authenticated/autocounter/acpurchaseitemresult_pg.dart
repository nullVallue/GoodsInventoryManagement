

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/autocounter/acpurchaseitemmenu_pg.dart';
import 'package:stockapp/page/authenticated/product/editproductdetails_pg.dart';
import 'package:stockapp/page/authenticated/product/viewproductsupplier_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/purchase/viewpurchasedetails_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class ACPurchaseItemResultPage extends StatefulWidget {
  final Uint8List resultImage;
  final int resultQty;
  final int totalQty;
  final Map<String, dynamic> pmap;
  final Map<String, dynamic> purchaseItemMap;


  const ACPurchaseItemResultPage({super.key, required this.resultImage, required this.resultQty, required this.pmap, required this.purchaseItemMap, required this.totalQty});

  @override
  State<ACPurchaseItemResultPage> createState() => _ACPurchaseItemResultPageState();

}

class _ACPurchaseItemResultPageState extends State<ACPurchaseItemResultPage>{


  final _qtyFormKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final FocusNode qtyFocusNode = FocusNode();

  Map<String, dynamic> productDetails = {};
  int productID = 0;
  late Map<String, dynamic> purchaseItemMap;
  Map<String, dynamic> productSupplierMap = {};

  Uint8List? uploadimage;


  bool editBtnVisible = true;


  @override
  void initState(){
    super.initState();
    purchaseItemMap = widget.purchaseItemMap;
    uploadimage = widget.resultImage;
    _qtyController.text = widget.totalQty.toString();
  }


  Future<void> loadDetails() async {

    productSupplierMap = await DatabaseMethods.getProductSupplierByIDAsMap(purchaseItemMap['ProductSupplierID']); 

    productDetails = await DatabaseMethods.getProductByIDAsMap(productSupplierMap['ProductID']);

  }

  void addOn(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ACPurchaseItemMenuPage(purchaseItemMap: purchaseItemMap, pmap: widget.pmap, currentQty: int.parse(_qtyController.text),)));
  }


  void updateQty() async {
    showLoadingDialog(
      title: "Processing",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );

    String invAlertMsg = '';

    BuildContext oriContext = context;

    Map<String, dynamic> pmap = widget.pmap;

    Map<String, dynamic> invRecord = await DatabaseMethods.getOutletInvAsMapByProductName(productDetails['ProductName'], pmap['OutletID']);

    invRecord['Quantity'] = invRecord['Quantity'] + int.parse(_qtyController.text);

    invAlertMsg = await DatabaseMethods.updateInvDetails(invRecord);

    if(invAlertMsg == ''){
      Map<String, dynamic> purchaseItem = purchaseItemMap;

      purchaseItem['Counted'] = true;


      String updtCountedStr = await DatabaseMethods.updatePurchaseItemDetails(purchaseItem);

      print(updtCountedStr);


      Map<String, dynamic> addMvmtMap = {
        'InvRecordID' : invRecord['InventoryID'],
        'MovementTimestamp' : DateTime.now(),
        'OutletID' : invRecord['OutletID'],
        'ProductName' : invRecord['ProductName'],
        'Quantity' : int.parse(_qtyController.text),
        'Source' : pmap['PurchaseID'],
        'StockCountRecordID' : 0,
        'StockMovementID' : 0,
        'Type' : 'Purchase',
        'isIn' : true,

      };

      String mvmtSenderAlertMsg = await DatabaseMethods.addStockMvmtDetails(addMvmtMap);



      int loss = widget.purchaseItemMap['Quantity'] - int.parse(_qtyController.text);

      if(loss != 0){
        Map<String, dynamic> lossmap = {
          'InventoryID' : invRecord['InventoryID'],
          'LossQty' : loss,
          'LossTimestamp' : DateTime.now(),
          'OutletID' : invRecord['OutletID'],
          'ProductName' : invRecord['ProductName'],
          'Type' : 'Purchase',
        };

        String lossAlertMsg = await DatabaseMethods.addLossDetails(lossmap);

        if(lossAlertMsg != ''){
          Navigator.pop(oriContext);
          updateFail(oriContext, lossAlertMsg);
          return;
        }

      }


      // check if all purchase items are done
      bool purchaseComplete = await DatabaseMethods.checkPurchaseComplete(pmap['PurchaseID']);


      // then change purchase status to complete
      if(purchaseComplete){
        pmap['Status'] = 'Complete';

        String completeMsg = await DatabaseMethods.updatePurchaseDetails(pmap);

        if(completeMsg != ''){
          Navigator.pop(oriContext);
          updateFail(oriContext, completeMsg);
          return;
        }

      }



    }


    Navigator.pop(oriContext);

    if(invAlertMsg == ''){
      updateSuccess(oriContext, pmap);
    }
    else{
      updateFail(oriContext, invAlertMsg);
    }

  }


  confirmAddOn(BuildContext oriContext){



    String message = 'Do you wish to add on another image?';
    
    showAlertDialog(
      title: "Add On?",
      message: message,
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      bradius: 15,

      // button params
      
      btnText : "Add",
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
        addOn(),

      },
    );

  }


  confirmAdd(BuildContext oriContext){

    String message = "The inventory level will be updated according to the quantity.";


    int loss = widget.purchaseItemMap['Quantity'] - int.parse(_qtyController.text);


    if(loss != 0){

      String difference = '';

      if(loss > 0){
        difference = '-${loss.toString()}';
      }
      else{
        difference = '+${loss.abs().toString()}';
      }

      message = 'Inventory level will be updated accordingly\n\nNote: there is a difference of ${difference}.';
    }
    
    showAlertDialog(
      title: "Confirm Results?",
      message: message,
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      bradius: 15,

      // button params
      
      btnText : "Confirm",
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
        updateQty(),

      },
    );

  }

  updateFail(BuildContext oriContext, String alertMsg){
    
    showAlertDialog(
      title: "Failed to Update Inventory Record",
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

      },
      btnBgColor: Theme.of(context).colorScheme.error,
      btnTextColor: Theme.of(context).colorScheme.onError,
      );

      
  }



  updateSuccess(BuildContext oriContext, Map<String, dynamic> newPmap){
    
    showAlertDialog(
      title: "Updated Successfully",
      message: "Inventory quantity has been update successfully.",
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
        navigateTo(context, widget, ViewPurchaseDetailsPage(pmap: newPmap), animationType : 'scrollLeft')

      },
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
          if(snapshot.connectionState == ConnectionState.waiting){
            if(productDetails.isEmpty){
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
              padding: EdgeInsets.fromLTRB((sWidth * 0.1), 0, (sWidth * 0.1), (sHeight * 0.05)),
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
                          onPressed: ()=> navigateTo(context, widget, ViewPurchaseDetailsPage(pmap: widget.pmap), animationType : 'scrollLeft'),
                        ),

                        Spacer(),

                        SizedBox(
                          child: 
                          Row(children: [
                            // createText(
                            //   'Add On',
                            //   fontSize: n2s,
                            //   fontWeight: n2w,
                            // ),

                            IconButton(
                              icon: Icon(
                                Icons.add_a_photo
                              ),
                              onPressed: (){
                                confirmAddOn(context);
                              },
                            ),

                          ]),
                        )

                        // createButton(
                        //   text: "Add On",
                        //   fontSize: n2s, 
                        //   fontWeight: n2w,
                        //   bgColor: Theme.of(context).colorScheme.primary, 
                        //   textColor: Theme.of(context).colorScheme.onPrimary, 
                        //   letterSpacing: l2Space, 
                        //   px: 30,
                        //   py: 15, 
                        //   bradius: 15,
                        //   // endingIcon: Icons.person_rounded,
                        //   onPressed: () => {
                        //     _qtyFormKey.currentState!.validate(), 
                        //     if(_qtyFormKey.currentState!.validate()){
                        //         setState((){
                        //           editBtnVisible = true;
                        //         }),
                        //         WidgetsBinding.instance!.addPostFrameCallback((_) {
                        //           FocusScope.of(context).unfocus();
                        //         }),
                        //         // confirmAdd(context),

                        //     },
                        //     // navigateTo(context, widget, AddUserDetailsPage(
                        //     //   userDetails: {
                        //     //   'email': _emailController.text,
                        //     //   'pw': _pwController.text
                        //     //   }),
                        //     //   animationType: 'scrollRight')
                        //   },
                        // ),                               

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
                                    Image.memory(uploadimage!, fit: BoxFit.cover)
                                ),
                            )

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
                                    'Count Result : ${widget.resultQty}',
                                    fontSize: h4s,
                                    fontWeight: h2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                  ),

                                  Spacer(),


                                  // createText(
                                  //   'Current Total: ${widget.totalQty}',
                                  //   fontSize: h4s,
                                  //   fontWeight: h2w,
                                  //   textColor: Theme.of(context).colorScheme.onBackground,
                                  // ),

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
                                    'Expected Total : ${purchaseItemMap['Quantity'].toString()}',
                                    fontSize: sub3s,
                                    fontWeight: sub3w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                  ),
                                  Spacer(),
                                ],
                              ),
                          ),


                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  createText(
                                    '(Edit total quantity if results are incorrect)',
                                    fontSize: sub4s,
                                    fontWeight: sub3w,
                                    textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                  ),
                                  Spacer(),
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
                                  key: _qtyFormKey,
                                  child:
                                  createFormTextField(
                                    focusNode: qtyFocusNode,
                                    hintText: "e.g. 10",
                                    labelText: "Current Total Quantity",
                                    bradius: 15,
                                    enabled: !editBtnVisible,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    keyboardType: TextInputType.number,
                                    controller: _qtyController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter quantity";
                                      }


                                      try {
                                        int parsedValue = int.parse(value);
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


// edit account details button
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
                                        qtyFocusNode.requestFocus();
                                      }),
                                    },
                                    ),                               
                                ),

                              ],
                            ),
                        ),
                      ),


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
                                      _qtyController.text = widget.totalQty.toString();
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


                      Visibility(
                        visible: true,
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
                                      _qtyFormKey.currentState!.validate(), 
                                      if(_qtyFormKey.currentState!.validate()){
                                          setState((){
                                            editBtnVisible = true;
                                          }),
                                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                                            FocusScope.of(context).unfocus();
                                          }),
                                          confirmAdd(context),

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