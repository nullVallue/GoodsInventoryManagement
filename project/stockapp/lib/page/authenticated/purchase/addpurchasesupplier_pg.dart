

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaseitem_pg.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaselist_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class AddPurchaseSupplierPage extends StatefulWidget {
  final List<Map<String, dynamic>> itemmaplist;
  final int outletid;
  final int quantity;
  final double totalprice;
  final Map<String, dynamic> productmap;
  const AddPurchaseSupplierPage({super.key, required this.outletid, required this.itemmaplist, required this.quantity, required this.productmap, required this.totalprice});
  

  @override
  State<AddPurchaseSupplierPage> createState() => _AddPurchaseSupplierPageState();
}

class _AddPurchaseSupplierPageState extends State<AddPurchaseSupplierPage>{
  
  final _supplierFormKey = GlobalKey<FormState>();

  String? _dropdownSupplierValue;

  // List<DropdownMenuItem<String>> managerList = [];
  List<String> supplierList = [];

  Future<void> loadSupplierDropdown() async {
    if(supplierList.isEmpty){
      List<String> fetchList = await DatabaseMethods.getSupplierList();


      for(int i = 0; i < fetchList.length; i++){
        int supplierid = await DatabaseMethods.getSupplierIdByName(fetchList[i]);
        if(await DatabaseMethods.checkIsProductSupplier(widget.productmap['ProductID'], supplierid)){
          supplierList.add(fetchList[i]);
        }
      }    

      if(supplierList.isEmpty){
        supplierList.add('No Suppliers Available');
      }
    }

  }


  addMapToList() async {
    showLoadingDialog(
      title: "Adding Item",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );
    List<Map<String, dynamic>> itemmaplist = widget.itemmaplist;

    BuildContext oriContext = context;

    String alertMsg = '';
    int productSupplierId = 0;

    int supplierId = await DatabaseMethods.getSupplierIdByName(_dropdownSupplierValue!);

    try{
      productSupplierId = await DatabaseMethods.getCrespondingProductSupplier(widget.productmap['ProductID'], supplierId);
    }
    catch(e){
      alertMsg = 'e';
      createFail(oriContext, alertMsg);
      return;
    }



    Map<String, dynamic> addmap = 
    {
      'ProductSupplierID' : productSupplierId,
      'Quantity' : widget.quantity,
      'ProductName' : widget.productmap['ProductName'],
      'SupplierID' : supplierId,
      'Price' : widget.productmap['Price'],
      'TotalPrice' : widget.totalprice,
      'ProductImgPath' : widget.productmap['ProductImgPath'],
    };

    itemmaplist.add(addmap);

    Navigator.pop(oriContext);
    if(alertMsg.isEmpty){
      // when register success, bring user to dashboard

      // ignore: use_build_context_synchronously
      navigateTo(oriContext, widget, AddPurchaseListPage(itemmaplist: itemmaplist, outletid: widget.outletid,), animationType: "scrollLeft");
    }
    else{
      // else show dialog message
      // ignore: use_build_context_synchronously
      createFail(oriContext, alertMsg);
    }


  }


  createSuccess(BuildContext oriContext){
    
    showAlertDialog(
      title: "Record Added Successfully",
      message: "Inventory record has been created successfully.",
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
      title: "Failed to add record",
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
        navigateTo(oriContext, widget, LandingPage(pageIndex: 3), animationType: "scrollLeft"),
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
        future: loadSupplierDropdown(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            if(supplierList.isEmpty){
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
                          onPressed: ()=> navigateTo(context, widget, AddPurchaseItemPage(outletid: widget.outletid, itemmaplist: widget.itemmaplist), animationType : 'scrollLeft'),
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
                                "Select a Supplier",
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
                                "Choose a supplier to order from",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),

                      
// product 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _supplierFormKey,
                                  child:
                                  createFormDropdownMenu(
                                  hintText: "Select Supplier",
                                  labelText: "Supplier",
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
                                    if(value == null || value == ''){
                                      return "Please select supplier";
                                    }
                                    else if(value == 'No Suppliers Available'){
                                      return "No suppliers available";
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

    bottomNavigationBar: BottomAppBar(
      elevation: 3,
      color: Theme.of(context).colorScheme.secondary,
      child: Container(
        height: sHeight * 0.12,
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

////////////////////////////////////////////////////////////////
///       
/// 
/// 

          Container(
            width: sWidth*0.65,
            child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 50, 10),
                child:

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child:
                      createText(
                        'Unit Price : RM ${widget.productmap['Price'].toStringAsFixed(2)} x ${widget.quantity}',
                        fontSize: sub4s,
                        fontWeight: sub1w,
                        textColor: Theme.of(context).colorScheme.onSecondary,
                        overflow: TextOverflow.ellipsis,

                      ),
                    )
                  ],
                ),


              ),


              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 50, 0),
                child:

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child:
                      createText(
                        'Total : RM ${(widget.productmap['Price'] * widget.quantity).toStringAsFixed(2)}',
                        fontSize: h4s,
                        fontWeight: h1w,
                        textColor: Theme.of(context).colorScheme.onSecondary,
                        overflow: TextOverflow.ellipsis,

                      ),
                    )
                  ],
                ),


              ),
            ],
          ),
          ),

////////////////////////////////////////////////////////////////
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
// next button
              Padding(
                padding: EdgeInsets.fromLTRB(0, (sWidth * 0), 0, (sWidth * 0.0)), // set top and bottom padding
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                          createButton(
                          text: "Add",
                          fontSize: 18, 
                          fontWeight: n2w,
                          bgColor: Theme.of(context).colorScheme.primary, 
                          textColor: Theme.of(context).colorScheme.onPrimary, 
                          letterSpacing: l2Space, 
                          px: 30,
                          py: 15, 
                          bradius: 15,
                          onPressed: () => {
                            _supplierFormKey.currentState!.validate(), 
                            if(_supplierFormKey.currentState!.validate()){
                              addMapToList(),
                            },
                          },
                          ),                               

                    ],
                  ),
              ),


            ],
          ),

////////////////////////////////////////////////////////////////





          ],
        ),
      ),
    ),


    );
  }
}