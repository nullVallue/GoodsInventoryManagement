
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/outlet/editoutletaddr_pg.dart';
import 'package:stockapp/page/authenticated/outlet/editoutletdetails_pg.dart';
import 'package:stockapp/page/authenticated/outlet/viewoutletstaff_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class EditOutletMenuPage extends StatefulWidget {
  final int editOutletID;

  const EditOutletMenuPage({super.key, required this.editOutletID,});

  @override
  State<EditOutletMenuPage> createState() => _EditOutletMenuPageState();
}

class _EditOutletMenuPageState extends State<EditOutletMenuPage>{

  Map<String, dynamic> outletDetails = {};
  int outletID = 0;

  Future<void> loadUserDetails() async {
    outletDetails = await DatabaseMethods.getOutletByIDAsMap(outletID);
  }


  switchFail(BuildContext oriContext){

    showAlertDialog(
      title: "Unable to activate outlet",
      message: "Outlet currently has no staff. Outlet must have at least one staff to be activated.\n\nPlease add staff in the outlet to activate outlet",
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
      btnBgColor: Theme.of(context).colorScheme.error,
      btnTextColor: Theme.of(context).colorScheme.onError,
      btnOnPressed: () => {
        Navigator.of(context).pop(),

      },
    );
  }

  switchStatus(bool isActive, int oid) async {


    if(isActive){
      if(!await DatabaseMethods.checkHasStaff(oid)){
        switchFail(context);
        return;
      }
    }

    await DatabaseMethods.updateOutletStatus(isActive, oid);
    String status = '';
    if(isActive){
      status = 'Active';
    }
    else{
      status = 'Inactive';
    }
    
    setState(() {
      outletDetails['Status'] = status;
    });
  }

  @override
  void initState(){
    super.initState();
    outletID = widget.editOutletID;
  }

  @override
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:
      FutureBuilder(
        future: loadUserDetails(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            if(outletDetails.isEmpty){
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
                          onPressed: ()=> navigateTo(context, widget, LandingPage(pageIndex: 6,), animationType : 'scrollLeft'),
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
                          
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  createText(
                                    outletDetails['OutletName'],
                                    fontSize: h3s,
                                    fontWeight: h2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    ),
                                ],
                              ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  createText(
                                    'ID : ${outletDetails['OutletID'].toString()}',
                                    fontSize: h4s,
                                    fontWeight: h2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
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
                                    outletDetails['City'],
                                    fontSize: sub3s,
                                    fontWeight: sub3w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
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
                                    '${outletDetails['State']}',
                                    fontSize: sub3s,
                                    fontWeight: sub3w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
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
                                    outletDetails['PhoneNo'],
                                    fontSize: sub3s,
                                    fontWeight: sub3w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                  ),
                                ],
                              ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.circle_rounded,
                                    size: 12,
                                    color: getStatusColor(outletDetails['Status']),
                                    ),
                                  createText(
                                    outletDetails['Status'],
                                    fontSize: n3s,
                                    fontWeight: h4w,
                                    textColor: Theme.of(context).colorScheme.onSecondary,
                                    ml: 10,
                                  ),
                                ],
                              ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  createSwitch(
                                    inactiveThumbColor: Colors.white,
                                    activeColor: Colors.white,
                                    activeTrackColor: Colors.greenAccent,
                                    value: (outletDetails['Status'] == 'Active')?true:false,
                                    onChanged: (value){
                                      switchStatus(value, outletDetails['OutletID']);
                                    }
                                  ),
                                ],
                              ),
                          ),

// view outlet staff details button
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 50, 0, 20), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Expanded(
                                    child: 
                                      createButton(
                                      text: "Outlet Staff List",
                                      fontSize: n2s, 
                                      fontWeight: FontWeight.w600,
                                      textColor: Theme.of(context).colorScheme.primary, 
                                      letterSpacing: l2Space, 
                                      py: 15,
                                      bradius: 15,
                                      bColor: Theme.of(context).colorScheme.primary,
                                      bWidth: 1.2,
                                      bStyle: BorderStyle.solid,
                                      endingIcon: Icons.arrow_forward_ios_rounded,
                                      iconOffset: 20,
                                      onPressed: () => {
                                        navigateTo(context, widget, ViewOutletStaffPage(outletDetails: outletDetails), animationType : 'scrollRight')
                                      },
                                      ),
                                  ),

                                ],
                              ),
                          ),




// edit outlet details button
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Expanded(
                                    child: 
                                      createButton(
                                      text: "Outlet Details",
                                      fontSize: n2s, 
                                      fontWeight: FontWeight.w600,
                                      textColor: Theme.of(context).colorScheme.primary, 
                                      letterSpacing: l2Space, 
                                      py: 15,
                                      bradius: 15,
                                      bColor: Theme.of(context).colorScheme.primary,
                                      bWidth: 1.2,
                                      bStyle: BorderStyle.solid,
                                      endingIcon: Icons.arrow_forward_ios_rounded,
                                      iconOffset: 20,
                                      onPressed: () => {
                                        navigateTo(context, widget, EditOutletDetailsPage(editOutletMap: outletDetails), animationType : 'scrollRight')
                                      },
                                      ),
                                  ),

                                ],
                              ),
                          ),


// edit outlet address button
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0), // set top and bottom padding
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Expanded(
                                    child: 
                                      createButton(
                                      text: "Outlet Address",
                                      fontSize: n2s, 
                                      fontWeight: FontWeight.w600,
                                      textColor: Theme.of(context).colorScheme.primary, 
                                      letterSpacing: l2Space, 
                                      py: 15,
                                      bradius: 15,
                                      bColor: Theme.of(context).colorScheme.primary,
                                      bWidth: 1.2,
                                      bStyle: BorderStyle.solid,
                                      endingIcon: Icons.arrow_forward_ios_rounded,
                                      iconOffset: 20,
                                      onPressed: () => {
                                        navigateTo(context, widget, EditOutletAddrPage(outletDetails: outletDetails), animationType : 'scrollRight')
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