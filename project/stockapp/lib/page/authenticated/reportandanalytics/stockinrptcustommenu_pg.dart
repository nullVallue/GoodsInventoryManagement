// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaseitem_pg.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaselist_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/stockinrptmenu_pg.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockaddrequest_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class StockInReportCustomMenuPage extends StatefulWidget {
  final int outletid;
  const StockInReportCustomMenuPage({super.key, required this.outletid});
  

  @override
  State<StockInReportCustomMenuPage> createState() => _StockInReportCustomMenuPageState();
}

class _StockInReportCustomMenuPageState extends State<StockInReportCustomMenuPage>{
  
  final _monthFormKey = GlobalKey<FormState>();

  String? _dropdownMonthValue;

  // List<DropdownMenuItem<String>> managerList = [];

  Future<void> loadSupplierDropdown() async {

  }

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];


  @override
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:
      FutureBuilder(
        future: loadSupplierDropdown(),
        builder: (context, snapshot) {
          // if(snapshot.connectionState == ConnectionState.waiting){
          //   if(outletList.isEmpty){
          //     return Center(
          //       child: 
          //         LoadingAnimationWidget.stretchedDots(
          //           color: Theme.of(context).colorScheme.primary,
          //           size: 50,
          //         ),
          //     );
          //   }
          // }
          // else if(snapshot.hasError){
          //   return Center(
          //     child: 
          //     createText('Error ${snapshot.error}')
          //   );
          // }

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
                          onPressed: ()=> navigateTo(context, widget, StockInReportMenuPage(), animationType : 'scrollLeft'),
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
                                "Custom Date \nReport",
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
                                "Choose your date range",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
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
                                  CalendarDatePicker2(
                                    config: CalendarDatePicker2Config(),
                                    value: _singleDatePickerValueWithDefaultValue,
                                    onValueChanged: (dates) {
                                      _singleDatePickerValueWithDefaultValue = dates;
                                    } ,
                                  )
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
                                    _monthFormKey.currentState!.validate(), 
                                    if(_monthFormKey.currentState!.validate()){
                                      // sendRequest(),
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