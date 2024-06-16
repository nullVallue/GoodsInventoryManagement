
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockaddreqoutlet_pg.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockpagectrl_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class StockAddRequestPage extends StatefulWidget {
  const StockAddRequestPage({super.key});
  

  @override
  State<StockAddRequestPage> createState() => _StockAddRequestPageState();
}

class _StockAddRequestPageState extends State<StockAddRequestPage>{
  
  final _productFormKey = GlobalKey<FormState>();
  final _qtyFormKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();

  String? _dropdownProductValue;

  // List<DropdownMenuItem<String>> managerList = [];
  List<String> productList = [];

  Future<void> loadProductDropdown() async {
    if(productList.isEmpty){

      List<String> temp = await DatabaseMethods.getProductList();

      for(int i = 0; i < temp.length; i++){
        if(await DatabaseMethods.checkHasProduct(temp[i], sessionUser['OutletID'])){
          productList.add(temp[i]);
        }
      }    

      if(productList.isEmpty){
        productList.add('No new products');
      }
    }
  }

  @override
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:
      FutureBuilder(
        future: loadProductDropdown(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            if(productList.isEmpty){
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
                          onPressed: ()=> navigateTo(context, widget, LandingPage(pageIndex: 2, stockIndex: 2,), animationType : 'scrollLeft'),
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
                                "Request for Product",
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
                                "Choose a product to be requested",
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
                                  key: _productFormKey,
                                  child:
                                  createFormDropdownMenu(
                                  hintText: "Select Product",
                                  labelText: "Product",
                                  bradius: 15,
                                  fontSize: n2s,
                                  fontWeight: n2w,
                                  textColor: Theme.of(context).colorScheme.onBackground,
                                  dropdownValue: _dropdownProductValue,
                                  dropdownItems: productList,
                                  onChanged: (value){
                                    setState(() {
                                      _dropdownProductValue = value;
                                    });
                                  },
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Please select product";
                                    }
                                    else if(value == 'No new products'){
                                      return "No new products to add";
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
                                    keyboardType: TextInputType.number,
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
        ////////////////////////////////////////////////////////////////////////////////////////////////////////





// sign up button
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
                                    _qtyFormKey.currentState!.validate(), 
                                    _productFormKey.currentState!.validate(),
                                    if(_qtyFormKey.currentState!.validate() && _productFormKey.currentState!.validate()){
                                      navigateTo(context, widget, StockAddRequestOutletPage(outletid: sessionUser['OutletID'], quantity: int.parse(_qtyController.text), productName: _dropdownProductValue!,), animationType: "scrollRight"),
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