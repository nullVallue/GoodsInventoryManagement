
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaseitem_pg.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaselist_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/stockinrptcustommenu_pg.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/stockinrptdisplay_pg.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/stockinrptmonthmenu_pg.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/stockinrptyrdisplay_pg.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockaddrequest_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class StockInReportYrMenuPage extends StatefulWidget {
  const StockInReportYrMenuPage({super.key,});
  

  @override
  State<StockInReportYrMenuPage> createState() => _StockInReportYrMenuPageState();
}

class _StockInReportYrMenuPageState extends State<StockInReportYrMenuPage>{

  
  final _outletFormKey = GlobalKey<FormState>();
  // final _typeFormKey = GlobalKey<FormState>();

  final _monthFormKey = GlobalKey<FormState>();

  String? _dropdownMonthValue;

  String? _dropdownOutletValue;
  // String? _dropdownTypeValue;

  // List<DropdownMenuItem<String>> managerList = [];
  List<Map<String, dynamic>> outletMapList = [];

  List<String> outletList = [];

  Future<void> loadSupplierDropdown() async {
    if(outletList.isEmpty){
      outletMapList = await DatabaseMethods.getOutletAsMapList();

      for(int i = 0; i < outletMapList.length; i++){
        outletList.add(outletMapList[i]['OutletName']);
      }

      if(outletList.isEmpty){
        outletList.add('No Outlets Available');
      }
    }

  }

  // void goToStockInMonthly(){

  //   int outletid = 0;

  //   for(int i = 0; i < outletMapList.length; i++){
  //     if(outletMapList[i]['OutletName'] == _dropdownOutletValue){
  //       outletid = outletMapList[i]['OutletID'];
  //     }
  //   }

  //   if(outletid != 0){
  //     navigateTo(context, widget, StockInReportMonthMenuPage(outletid: outletid), animationType: 'scrollRight');
  //   }


  // }


  void generate(){

    int outletid = 0;

    for(int i = 0; i < outletMapList.length; i++){
      if(outletMapList[i]['OutletName'] == _dropdownOutletValue){
        outletid = outletMapList[i]['OutletID'];
      }
    }

    if(outletid != 0){
      navigateTo(context, widget, StockInReportYrDisplayPage(outletid: outletid, year: int.parse(_dropdownMonthValue!),), animationType: 'scrollRight');
    }


  }


  List<String> dropdownMonth = [
    (DateTime.now().year).toString(),
    (DateTime.now().year - 1).toString(),
    (DateTime.now().year - 2).toString(),
    (DateTime.now().year - 3).toString(),
    ];

  // List<String> dropdownType = [
  //   'Monthly',
  //   'Custom Date',
  //   ];



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
                          onPressed: ()=> navigateTo(context, widget, LandingPage(pageIndex: 7,), animationType : 'scrollLeft'),
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
                                "Report Format",
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
                                "Choose your report format",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),

                      
//outlet ddl
// 
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
        ///
        ///


        

                      


                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _monthFormKey,
                                  child:
                                  createFormDropdownMenu(
                                  hintText: "Select Report Year",
                                  labelText: "Year",
                                  bradius: 15,
                                  fontSize: n2s,
                                  fontWeight: n2w,
                                  textColor: Theme.of(context).colorScheme.onBackground,
                                  dropdownValue: _dropdownMonthValue,
                                  dropdownItems: dropdownMonth,
                                  onChanged: (value){
                                    setState((){
                                      _dropdownMonthValue = value;
                                    });
                                  },
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Please select a month";
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
                                  text: "Generate",
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
                                    _monthFormKey.currentState!.validate(),
                                    // _typeFormKey.currentState!.validate(), 
                                    if(_outletFormKey.currentState!.validate() && _monthFormKey.currentState!.validate()){
                                      generate()
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