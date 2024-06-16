// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaseitem_pg.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaselist_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockaddrequest_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class StockAddRequestOutletPage extends StatefulWidget {
  final int outletid;
  final int quantity;
  final String productName;
  const StockAddRequestOutletPage({super.key, required this.outletid, required this.quantity, required this.productName});
  

  @override
  State<StockAddRequestOutletPage> createState() => _StockAddRequestOutletPageState();
}

class _StockAddRequestOutletPageState extends State<StockAddRequestOutletPage>{
  
  final _outletFormKey = GlobalKey<FormState>();

  String? _dropdownOutletValue;

  // List<DropdownMenuItem<String>> managerList = [];
  List<String> outletList = [];

  Future<void> loadSupplierDropdown() async {
    if(outletList.isEmpty){
      List<Map<String, dynamic>> outletMapList = await DatabaseMethods.getOutletAsMapList();


      for(int i = 0; i < outletMapList.length; i++){
        if(await DatabaseMethods.checkHasProduct(widget.productName, outletMapList[i]['OutletID'])){
          if(outletMapList[i]['OutletID'] != sessionUser['OutletID']){

            outletList.add(outletMapList[i]['OutletName']);
          }
        }
      }    

      if(outletList.isEmpty){
        outletList.add('No Outlets Available');
      }
    }

  }



  void sendRequest() async {
    showLoadingDialog(
      title: "Sending Request",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );

    BuildContext oriContext = context;


    String alertMsg = '';

    int productid = await DatabaseMethods.getProductIdByNameAsInt(widget.productName);

    if(productid != 0){

      int tooutletid = await DatabaseMethods.getOutletIdByNameAsInt(_dropdownOutletValue!);

      if(tooutletid != 0){

        Map<String, dynamic> updateMap = {
          'FromOutletID' : sessionUser['OutletID'],
          'Hidden' : false,
          'ProductID' : productid,
          'ProductName' : widget.productName,
          'Quantity' : widget.quantity ,
          'RequestStockID' : 0,
          'Status' : 'Pending',
          'ToOutletID' : tooutletid,
        };

        alertMsg = await DatabaseMethods.addRequestDetails(updateMap);

      }
      else{
        alertMsg = 'Failed to fetch Outlet ID';
      }
    }
    else{
      alertMsg = 'Failed to fetch Product ID';
    }



    Navigator.pop(oriContext);

    if(alertMsg == ''){
      createSuccess(oriContext);
    }
    else{
      createFail(oriContext, alertMsg);
    }

  } 


  createSuccess(BuildContext oriContext){
    
    showAlertDialog(
      title: "Request Sent",
      message: "Request has been successfully sent.",
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
        navigateTo(oriContext, widget, LandingPage(pageIndex: 2, stockIndex: 2,), animationType: "scrollLeft"),

      },
    );

      
  }

  
  createFail(BuildContext oriContext, String alertMsg){
    
    showAlertDialog(
      title: "Request Failed",
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
        navigateTo(oriContext, widget, LandingPage(pageIndex: 2, stockIndex: 2,), animationType: "scrollLeft"),
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
            if(outletList.isEmpty){
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
                          onPressed: ()=> navigateTo(context, widget, StockAddRequestPage(), animationType : 'scrollLeft'),
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
                                "Select an Outlet",
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
                                "Choose an outlet to request from",
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
                                  key: _outletFormKey,
                                  child:
                                  createFormDropdownMenu(
                                  hintText: "Select Outlet",
                                  labelText: "Outlet",
                                  bradius: 15,
                                  fontSize: n2s,
                                  fontWeight: n2w,
                                  textColor: Theme.of(context).colorScheme.onBackground,
                                  dropdownValue: _dropdownOutletValue,
                                  dropdownItems: outletList,
                                  onChanged: (value){
                                    setState(() {
                                      _dropdownOutletValue = value;
                                    });
                                  },
                                  validator: (value){
                                    if(value == null || value == ''){
                                      return "Please select outlet";
                                    }
                                    else if(value == 'No Outlets Available'){
                                      return "No outlets available";
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
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.1), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child:
                                 createButton(
                                  text: "Send Request",
                                  fontSize: n2s, 
                                  fontWeight: n2w,
                                  bgColor: Theme.of(context).colorScheme.primary, 
                                  textColor: Theme.of(context).colorScheme.onPrimary, 
                                  letterSpacing: l2Space, 
                                  px: 30,
                                  py: 15, 
                                  bradius: 15,
                                  onPressed: () => {
                                    _outletFormKey.currentState!.validate(), 
                                    if(_outletFormKey.currentState!.validate()){
                                      sendRequest(),
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