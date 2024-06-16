// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/outlet/editoutletmenu_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';
import 'package:stockapp/database/database.dart';


class EditOutletAddrPage extends StatefulWidget {
  final Map<String, dynamic> outletDetails;

  const EditOutletAddrPage({super.key, required this.outletDetails});

  @override
  State<EditOutletAddrPage> createState() => _EditUserOutletPageState();
}

class _EditUserOutletPageState extends State<EditOutletAddrPage>{

  final _addr1FormKey = GlobalKey<FormState>();
  final _addr2FormKey = GlobalKey<FormState>();
  final _postcodeFormKey = GlobalKey<FormState>();
  final _cityFormKey = GlobalKey<FormState>();
  final _stateFormKey = GlobalKey<FormState>();

  final _addr1Controller= TextEditingController();
  final _addr2Controller = TextEditingController();
  final _postcodeController = TextEditingController();
  final _cityController = TextEditingController();
  
  String alertMsg = 'Empty Alert';

  final FocusNode addr1FocusNode = FocusNode();

  bool editBtnVisible = true;

  
  void update(String addr1, String addr2, String postcode, String city, String state) async {
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

    Map<String, dynamic> updateMap = widget.outletDetails;

    BuildContext oriContext= context;

    String alertMsg = '';

    if(updateMap['OutletID'] != null){
      updateMap['AddressLine1'] = addr1;
      updateMap['AddressLine2'] = addr2;
      updateMap['Postcode'] = postcode;
      updateMap['City'] = city;
      updateMap['State'] = state;
    }
    else{
      Navigator.pop(oriContext);
      updateFail(oriContext, "Outlet Update Failed");
      return;
    }

    alertMsg = await DatabaseMethods.updateOutletDetails(updateMap);

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


  @override
  void initState(){
    super.initState();
    _addr1Controller.text = widget.outletDetails['AddressLine1'];
    _addr2Controller.text = widget.outletDetails['AddressLine2'];
    _postcodeController.text = widget.outletDetails['Postcode'];
    _cityController.text = widget.outletDetails['City'];
    _dropdownValue = widget.outletDetails['State'];
  }


  String? _dropdownValue;
  List<String> dropdownStates = [
    'Kedah', 
    'Kelantan', 
    'Sabah',
    'Pahang',
    'Sarawak',
    'Perak',
    'Selangor',
    'N. Sembilan',
    'Terrenganu',
    'Johor',
    'P. Pinang',
    'Perlis',
    'Melaka',
    'W.P.Kuala Lumpur',
    ];
  
  
  updateSuccess(BuildContext oriContext){

    showAlertDialog(
      title: "Update Success",
      message: "Details have neen updated successfully",
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
      title: "Update Failed",
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
        WillPopScope(onWillPop: () async {return false;},
          child:
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child:
            Padding(
              padding: EdgeInsets.fromLTRB((sWidth * 0.1), 0, (sWidth * 0.1), 0),
              child: Center(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//section 1
                    Container(
                      height: (0.2*sHeight),
                      child:
                      Row(
                        children: <Widget>[
                        BackButton(
                          onPressed: ()=> navigateTo(context, widget, EditOutletMenuPage(editOutletID: widget.outletDetails['OutletID'],), animationType : 'scrollLeft'),
                        )
                        ]
                      ),
                    ),
                    
// section 2
                    Container(
                      child:

  // main column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

// sign up title
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                            child: 
                              Row(
                                children: <Widget>[
                                  createText(
                                    "Edit Address Details",
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
                                    "Edit outlet address details",
                                    fontSize: sub3s,
                                    fontWeight: sub3w,
                                    textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                  ),
                                ],
                              ),
                          ),
                          
                          
                          
// Address Line 1 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.00), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _addr1FormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. No. 1",
                                    labelText: "Address Line 1",
                                    focusNode: addr1FocusNode,
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    enabled: !editBtnVisible,
                                    mr: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _addr1Controller,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter address line 1";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),


                            ],
                          ),
                      ),



// Address Line 2 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, (sWidth * 0.05)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _addr2FormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. Keycondo, Boardstreet",
                                    labelText: "Address Line 2",
                                    bradius: 15,
                                    enabled: !editBtnVisible,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    mr: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _addr2Controller,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter address line 2";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),


                            ],
                          ),
                      ),
                      


// Postcode input
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _postcodeFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. 12345",
                                    labelText: "Postcode",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    enabled: !editBtnVisible,
                                    mr: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _postcodeController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter \npostcode";
                                      }
                                      else if(!RegExp(r'^\d{5}$').hasMatch(value)){
                                        return "Please enter \nvalid postcode";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),

// city input
                              Expanded(child: 
                                Form(
                                  key: _cityFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. New York",
                                    labelText: "City",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    ml: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    enabled: !editBtnVisible,
                                    controller: _cityController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter \ncity";
                                      }
                                      return null;
                                    }
                                    ),
                                ),
                              ),


                            ],
                          ),
                      ),


                      
// state 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _stateFormKey,
                                  child:
                                  createFormDropdownMenu(
                                  hintText: "Select state",
                                  labelText: "State",
                                  bradius: 15,
                                  fontSize: n2s,
                                  fontWeight: n2w,
                                  textColor: Theme.of(context).colorScheme.onBackground,
                                  dropdownValue: _dropdownValue,
                                  dropdownItems: dropdownStates,
                                  onChanged: editBtnVisible?null:(value){
                                    setState((){
                                      _dropdownValue = value;
                                    });
                                  },
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Please select a state";
                                    }
                                    return null;
                                  }
                                  ),
                                ),
                              ),





                            ],
                          ),
                      ),
                      

// edit button
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
                                        addr1FocusNode.requestFocus();
                                      }),
                                    },
                                    ),                               
                                ),

                              ],
                            ),
                        ),
                      ),



// cancel button
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
                                      _addr1Controller.text = widget.outletDetails['AddressLine1'];
                                      _addr2Controller.text = widget.outletDetails['AddressLine2'];
                                      _postcodeController.text = widget.outletDetails['Postcode'];
                                      _cityController.text = widget.outletDetails['City'];
                                      _dropdownValue = widget.outletDetails['State'];
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



// confirm button
                      Visibility(
                        visible: !editBtnVisible,
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
                                      _addr1FormKey.currentState!.validate(), 
                                      _addr2FormKey.currentState!.validate(),
                                      _postcodeFormKey.currentState!.validate(),
                                      _cityFormKey.currentState!.validate(),
                                      _stateFormKey.currentState!.validate(),
                                      if(_addr1FormKey.currentState!.validate() && _addr2FormKey.currentState!.validate() && _postcodeFormKey.currentState!.validate() && _cityFormKey.currentState!.validate() && _stateFormKey.currentState!.validate()){
                                        if(_addr1Controller.text == widget.outletDetails['AddressLine1'] && _addr2Controller.text == widget.outletDetails['AddressLine2'] && _postcodeController.text == widget.outletDetails['Postcode'] && _cityController.text == widget.outletDetails['City'] && _dropdownValue == widget.outletDetails['State']){
                                          setState((){
                                            editBtnVisible = true;
                                          }),
                                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                                            FocusScope.of(context).unfocus();
                                          }),
                                        }
                                        else{
                                          setState((){
                                            editBtnVisible = true;
                                          }),
                                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                                            FocusScope.of(context).unfocus();
                                          }),
                                          update(
                                            _addr1Controller.text,
                                            _addr2Controller.text,
                                            _postcodeController.text,
                                            _cityController.text,
                                            _dropdownValue??'', 
                                          )
                                        }

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
                  ],
                ),
              )
            ),
          ),
        ),
    );
  }
}