
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/outlet/viewoutletstaff_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class OutletAddStaffPage extends StatefulWidget {
  final Map<String, dynamic> outletMap;
  const OutletAddStaffPage({super.key, required this.outletMap});
  

  @override
  State<OutletAddStaffPage> createState() => _OutletAddStaffPageState();
}

class _OutletAddStaffPageState extends State<OutletAddStaffPage>{
  
  final _staffFormKey = GlobalKey<FormState>();

  String? _dropdownStaffValue;

  bool editBtnVisible = true;


  List<String> dropdownStaff = [];

  Future<void> loadDropDownList() async {
    dropdownStaff = await DatabaseMethods.getAllUserNoOutletAsList();

    for(int i = 0; i < dropdownStaff.length; i++){
      Map<String, dynamic> user = await DatabaseMethods.getUserByEmailAsMap(dropdownStaff[i]);
      if(user['Status'] != 'Active'){
        dropdownStaff.removeAt(i);
        i--;
      }
    }

    if(dropdownStaff.isEmpty){
      dropdownStaff.add('No Staff Available');
    }


  }

  void update(String email) async {
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
    Map<String, dynamic> updateMap = await DatabaseMethods.getUserByEmailAsMap(email);

    BuildContext oriContext= context;

    String alertMsg = '';

    if(updateMap['UserID'] != null){
      updateMap['OutletID'] = widget.outletMap['OutletID'];
    }
    else{
      Navigator.pop(oriContext);
      updateFail(oriContext, "Account Update Failed");
      return;
    }

    alertMsg = await DatabaseMethods.updateUserDetails(updateMap);

    Navigator.pop(oriContext);


    if(alertMsg.isEmpty){
      // when register success, bring user to dashboard

      // ignore: use_build_context_synchronously
      updateSuccess(oriContext);
    }
    else{
      // else show dialog message
      // ignore: use_build_context_synchronously
      updateFail(oriContext, alertMsg);
    }

  }


  updateSuccess(BuildContext oriContext){

    showAlertDialog(
      title: "Added Successfully",
      message: "Staff has been added successfully",
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
        navigateTo(oriContext, widget, ViewOutletStaffPage(outletDetails: widget.outletMap), animationType : 'scrollLeft'),
        // navigateTo(oriContext, widget, LandingPage(pageIndex: 4,), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
    );
  }

  updateFail(BuildContext oriContext, String errMsg){

    showAlertDialog(
      title: "Failed to add staff",
      message: "Error: $errMsg",
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
        navigateTo(oriContext, widget, ViewOutletStaffPage(outletDetails: widget.outletMap), animationType : 'scrollLeft'),
        // navigateTo(oriContext, widget, LandingPage(pageIndex: 4,), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
    );
  }

  @override
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:
        FutureBuilder(
        future: loadDropDownList(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            if(dropdownStaff.isEmpty){
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
                          onPressed: ()=> navigateTo(context, widget, ViewOutletStaffPage(outletDetails: widget.outletMap), animationType : 'scrollLeft'),
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


        //Edit title
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Add User To Outlet",
                                fontSize: h2s,
                                fontWeight: h2w,
                                textColor: Theme.of(context).colorScheme.onBackground,
                                ),
                            ],
                          ),
                      ),


        //Edit subtitle 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.10)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Add an user to outlet",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),


// role ddl 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _staffFormKey,
                                  child:
                                  createFormDropdownMenu(
                                  hintText: "Add a Staff",
                                  labelText: "Select Staff",
                                  bradius: 15,
                                  fontSize: n2s,
                                  fontWeight: n2w,
                                  textColor: Theme.of(context).colorScheme.onBackground,
                                  dropdownValue: _dropdownStaffValue,
                                  dropdownItems: dropdownStaff,
                                  onChanged: (value){
                                    setState((){
                                      _dropdownStaffValue = value;
                                    });
                                  },
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Please select a staff";
                                    }
                                    else if(value == 'No Staff Available'){
                                      return "No Staff Available";
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




// add button
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, (sWidth * 0.01)), // set top and bottom padding
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
                                    _staffFormKey.currentState!.validate(),
                                    if(_staffFormKey.currentState!.validate()){
                                      update(
                                        _dropdownStaffValue??'', 
                                      )

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