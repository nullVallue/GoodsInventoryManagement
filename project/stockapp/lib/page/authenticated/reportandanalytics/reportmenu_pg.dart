
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/lossreportmenu_pg.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/lossreporttype_pg.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/purchaserptmenu_pg.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/purchaserpttype_pg.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/stockinrptmenu_pg.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/stockinrpttype_pg.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockmvmtmanage_pg.dart';
import 'package:stockapp/page/authenticated/user/edituseraccount_pg.dart';
import 'package:stockapp/page/authenticated/user/edituseraddress_pg.dart';
import 'package:stockapp/page/authenticated/user/edituserpersonal_pg.dart';
import 'package:stockapp/page/authenticated/user/userfulldetails_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class ReportMenuPage extends StatefulWidget {

  const ReportMenuPage({super.key,});

  @override
  State<ReportMenuPage> createState() => _ReportMenuPageState();
}

class _ReportMenuPageState extends State<ReportMenuPage>{



  Future<void> loadDetails() async {

  }

  @override
  void initState(){
    super.initState();
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
                      // height: (sHeight * 0.6),
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          


                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 50, 0, 20), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  Expanded(
                                    child: 
                                    createText(
                                      'Hello \n${sessionUser['FirstName']}! \nWhich report would you like to view?',
                                      fontSize: h2s,
                                      textColor: Theme.of(context).colorScheme.onBackground,
                                    ),
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
                                      text: "Stock In Report",
                                      fontSize: n2s, 
                                      fontWeight: FontWeight.w600,
                                      textColor: Theme.of(context).colorScheme.primary, 
                                      letterSpacing: l2Space, 
                                      py: 15,
                                      bradius: 15,
                                      bColor: Theme.of(context).colorScheme.primary,
                                      bWidth: 1.2,
                                      bStyle: BorderStyle.solid,
                                      onPressed: () => {
                                        navigateTo(context, widget, StockInReportTypeMenuPage(), animationType : 'scrollRight')
                                        // navigateTo(context, widget, EditUserPersonalPage(editUserMap: userDetails), animationType : 'scrollRight')
                                      },
                                      ),
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

                                  Expanded(
                                    child: 
                                      createButton(
                                      text: "Purchase Report",
                                      fontSize: n2s, 
                                      fontWeight: FontWeight.w600,
                                      textColor: Theme.of(context).colorScheme.primary, 
                                      letterSpacing: l2Space, 
                                      py: 15,
                                      bradius: 15,
                                      bColor: Theme.of(context).colorScheme.primary,
                                      bWidth: 1.2,
                                      bStyle: BorderStyle.solid,
                                      onPressed: () => {
                                        navigateTo(context, widget, PurchaseReportTypeMenuPage(), animationType : 'scrollRight')
                                      },
                                      ),
                                  ),

                                ],
                              ),
                          ),


// edit account details button
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Expanded(
                                    child: 
                                      createButton(
                                      text: "Loss Report",
                                      fontSize: n2s, 
                                      fontWeight: FontWeight.w600,
                                      textColor: Theme.of(context).colorScheme.primary, 
                                      letterSpacing: l2Space, 
                                      py: 15,
                                      bradius: 15,
                                      bColor: Theme.of(context).colorScheme.primary,
                                      bWidth: 1.2,
                                      bStyle: BorderStyle.solid,
                                      onPressed: () => {
                                        navigateTo(context, widget, LossReportTypeMenuPage(), animationType : 'scrollRight')
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