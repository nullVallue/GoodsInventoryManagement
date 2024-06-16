

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaselist_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class EditPurchaseItemPage extends StatefulWidget {
  final List<Map<String, dynamic>> itemmaplist;
  final int outletid;
  final int selectedIndex;
  const EditPurchaseItemPage({super.key, required this.outletid, required this.itemmaplist, required this.selectedIndex});
  

  @override
  State<EditPurchaseItemPage> createState() => _EditPurchaseItemPageState();
}

class _EditPurchaseItemPageState extends State<EditPurchaseItemPage>{
  
  final _supplierFormKey = GlobalKey<FormState>();
  final _qtyFormKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();

  String? _dropdownSupplierValue;


  String totalStr = 'Total : RM 0.00';
  String unitStr = 'Unit Price : RM 0.00';

  // List<DropdownMenuItem<String>> managerList = [];
  List<String> supplierList = [];

  Map<String, dynamic> currentProduct = {};

  @override
  void initState(){
    super.initState();
    if(widget.selectedIndex < widget.itemmaplist.length){
      _qtyController.text = widget.itemmaplist[widget.selectedIndex]['Quantity'].toString();
    }
  }

  Future<void> loadSupplierDropdown() async {
    if(widget.selectedIndex < widget.itemmaplist.length){

      if(supplierList.isEmpty){
        await setCurrentProduct(widget.itemmaplist[widget.selectedIndex]['ProductName']);


        List<String> fetchList = await DatabaseMethods.getSupplierList();

        Map<String, dynamic> suppliermap = await DatabaseMethods.getSupplierMapById(widget.itemmaplist[widget.selectedIndex]['SupplierID']);


        Map<String, dynamic> product= await DatabaseMethods.getProductMapByName(widget.itemmaplist[widget.selectedIndex]['ProductName']);


        currentProduct = product;


        for(int i = 0; i < fetchList.length; i++){
          int supplierid = await DatabaseMethods.getSupplierIdByName(fetchList[i]);
          if(await DatabaseMethods.checkIsProductSupplier(product['ProductID'], supplierid)){
            supplierList.add(fetchList[i]);
            if(fetchList[i] == suppliermap['SupplierName']){
              _dropdownSupplierValue = fetchList[i];
            }
          }
        }    

        if(supplierList.isEmpty){
          supplierList.add('No Suppliers Available');
        }
      }
    }

  }


  void updateString(){
    int qty = 0;
    double unitprice = 0.0;
    double totalprice = 0.0;
    String totalString = '';
    String unitString = '';


    if(currentProduct != null && _qtyFormKey.currentState!.validate()){
      unitprice = double.parse(currentProduct!['Price'].toString());
      qty = int.parse(_qtyController.text);
      totalprice = unitprice * qty;
    }

    if(qty != 0){
      unitString = 'Unit Price : RM ${unitprice.toStringAsFixed(2)} x ${qty.toStringAsFixed(2)}';
      totalString = 'Total : RM ${totalprice.toStringAsFixed(2)}';
    }
    else{
      unitString = 'Unit Price : RM 0.00';
      totalString = 'Total : RM 0.00';
    }

    setState(() {
      unitStr = unitString; 
      totalStr = totalString; 
    });

  }


  Future<void> setCurrentProduct(String? productName) async {
    Map<String, dynamic> temp = await DatabaseMethods.getProductMapByName(productName!);
    // setState(() {
      currentProduct = temp;    
    // });
  }

  updateMapToList() async {
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
    List<Map<String, dynamic>> itemmaplist = widget.itemmaplist;

    BuildContext oriContext = context;

    String alertMsg = '';
    int productSupplierId = 0;

    int supplierId = await DatabaseMethods.getSupplierIdByName(_dropdownSupplierValue!);

    try{
      productSupplierId = await DatabaseMethods.getCrespondingProductSupplier(currentProduct['ProductID'], supplierId);
    }
    catch(e){
      alertMsg = 'e';
      createFail(oriContext, alertMsg);
      return;
    }

    double totalprice = currentProduct['Price'].toDouble() * double.parse(_qtyController.text);


    Map<String, dynamic> addmap = 
    {
      'ProductSupplierID' : productSupplierId,
      'Quantity' : int.parse(_qtyController.text),
      'ProductName' : currentProduct['ProductName'],
      'SupplierID' : supplierId,
      'Price' : currentProduct['Price'],
      'TotalPrice' : totalprice,
      'ProductImgPath' : currentProduct['ProductImgPath'],
    };

    itemmaplist[widget.selectedIndex] = addmap;

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


  removeItem(){

    List<Map<String, dynamic>> itemmaplist = widget.itemmaplist;

    itemmaplist.removeAt(widget.selectedIndex);

    navigateTo(context, widget, AddPurchaseListPage(itemmaplist: itemmaplist, outletid: widget.outletid,), animationType: "scrollLeft");

  }


  confirmRemove(){
    
    showAlertDialog(
      title: "Remove item?",
      message: "Are you sure you want to remove item from order?",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      bradius: 15,

      // button params
      
      btnText : "Remove",
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
        removeItem(),
        Navigator.of(context).pop(),


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
                          onPressed: ()=> navigateTo(context, widget, AddPurchaseListPage(outletid: widget.outletid, itemmaplist: widget.itemmaplist), animationType : 'scrollLeft'),
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
                                "Edit Order For\n${currentProduct!['ProductName']}",
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
                                "Edit order details",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),

                      
//supplier 
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
                                  onChanged: (value) async {
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

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _qtyFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. 10",
                                    labelText: "Quantity",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _qtyController,
                                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                    onChanged: (value){
                                      updateString();
                                      // FocusScope.of(context).unfocus();
                                    },
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

                                        if(parsedValue < 1){
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
                                  text: "Remove Item",
                                  fontSize: n2s, 
                                  fontWeight: n2w,
                                  bgColor: Theme.of(context).colorScheme.error, 
                                  textColor: Theme.of(context).colorScheme.onError, 
                                  letterSpacing: l2Space, 
                                  px: 30,
                                  py: 15, 
                                  bradius: 15,
                                  onPressed: () => {
                                    confirmRemove()
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




        Container(
          width: sWidth * 0.65,
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
                        unitStr,
                        fontSize: sub4s,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: sub1w,
                        textColor: Theme.of(context).colorScheme.onSecondary,

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
                        totalStr,
                        fontSize: h4s,
                        fontWeight: h1w,
                        overflow: TextOverflow.ellipsis,
                        textColor: Theme.of(context).colorScheme.onSecondary,

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                          createButton(
                          text: "Edit",
                          fontSize: 18, 
                          fontWeight: n2w,
                          bgColor: Theme.of(context).colorScheme.primary, 
                          textColor: Theme.of(context).colorScheme.onPrimary, 
                          letterSpacing: l2Space, 
                          px: 30,
                          py: 15, 
                          bradius: 15,
                          onPressed: () => {
                            _qtyFormKey.currentState!.validate(), 
                            _supplierFormKey.currentState!.validate(),
                            if(_qtyFormKey.currentState!.validate() && _supplierFormKey.currentState!.validate()){
                              updateMapToList(),
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