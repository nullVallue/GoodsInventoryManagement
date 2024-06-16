
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/outlet/editoutletmenu_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class EditOutletDetailsPage extends StatefulWidget {
  final Map<String, dynamic> editOutletMap;
  const EditOutletDetailsPage({super.key, required this.editOutletMap});
  

  @override
  State<EditOutletDetailsPage> createState() => _EditOutletDetailsPageState();
}

class _EditOutletDetailsPageState extends State<EditOutletDetailsPage>{
  
  final _nameFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _managerFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _dropdownManagerValue;

  bool editBtnVisible = true;

  final FocusNode nameFocusNode = FocusNode();

  // List<DropdownMenuItem<String>> managerList = [];
  List<String> managerList = [];

  Map<String, dynamic> currentManager = {};

  @override
  void initState(){
    super.initState();
    _nameController.text = widget.editOutletMap['OutletName'];
    _phoneController.text = widget.editOutletMap['PhoneNo'];
  }

  Future<void> loadManagerDropdown() async {
    managerList = await DatabaseMethods.getManagerList();

    for(int i = 0; i < managerList.length; i++){
      Map<String, dynamic> user = await DatabaseMethods.getUserByEmailAsMap(managerList[i]);
      if(await DatabaseMethods.checkManagerHolding(user['UserID'])){
        managerList.removeAt(i);
        i--;
      }
    }    

    Map<String, dynamic> user = await DatabaseMethods.getUserByIDAsMap(widget.editOutletMap['UserID']);

    managerList.add(user['Email']);

    currentManager = user;
    _dropdownManagerValue = currentManager['Email'];

    if(managerList.isEmpty){
      managerList.add('No Managers Available');
    }
  }


  void update(String outletName, String phoneNo, String managerEmail) async {


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

    Map<String, dynamic> updateMap = widget.editOutletMap;

    BuildContext oriContext = context;

    String alertMsg = '';

    Map<String, dynamic> user = await DatabaseMethods.getUserByEmailAsMap(managerEmail);

    if(user.isNotEmpty){
      if(updateMap['OutletID'] != null){
        updateMap['OutletName'] = outletName;
        updateMap['PhoneNo'] = phoneNo;
        updateMap['UserID'] = user['UserID'];
      }
      else{
        Navigator.pop(oriContext);
        updateFail(oriContext, "Update Failed");
        return;
      }
    }
    else{
      Navigator.pop(oriContext);
      updateFail(oriContext, "Update Failed");
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
      FutureBuilder(
        future: loadManagerDropdown(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            if(managerList.isEmpty){
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
                          onPressed: ()=> navigateTo(context, widget, EditOutletMenuPage(editOutletID: widget.editOutletMap['OutletID']), animationType : 'scrollLeft'),
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
                                "Edit Outlet",
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
                                "Edit the details of an outlet",
                                fontSize: sub3s,
                                fontWeight: sub3w,
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              Expanded(child: 
                                Form(
                                  key: _nameFormKey,
                                  child:
                                  createFormTextField(
                                    focusNode: nameFocusNode,
                                    hintText: "e.g. Apple Georgetown",
                                    labelText: "Outlet Name",
                                    bradius: 15,
                                    enabled: !editBtnVisible,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _nameController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter outlet name";
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
                                  key: _phoneFormKey,
                                  child:
                                  createFormTextField(
                                    hintText: "e.g. 0123456789",
                                    labelText: "Phone No",
                                    enabled: !editBtnVisible,
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    mr: 0.01 * sWidth,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _phoneController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Please enter phone no.";
                                      }
                                      else if(!RegExp(r'^\d{3}-?\d{6,11}$').hasMatch(value)){
                                        return "Please enter a valid phone no.\ne.g. 012-3456789";
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

// outlet manager
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.05), 0, 0), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[

                              Expanded(child: 
                                Form(
                                  key: _managerFormKey,
                                  child:
                                  createFormDropdownMenu(
                                  hintText: "Assign a manager",
                                  labelText: "Outlet Manager",
                                  bradius: 15,
                                  fontSize: n2s,
                                  fontWeight: n2w,
                                  textColor: Theme.of(context).colorScheme.onBackground,
                                  dropdownValue: _dropdownManagerValue,
                                  dropdownItems: managerList,
                                  onChanged: editBtnVisible? null :(value){
                                    setState(() {
                                      _dropdownManagerValue = value;
                                    });
                                  },
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Please select an outlet";
                                    }
                                    else if(value == 'No Managers Available'){
                                      return "No manager available";
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

        ///       // edit button
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
                                        nameFocusNode.requestFocus();
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
                                      _nameController.text = widget.editOutletMap['OutletName'];
                                      _phoneController.text = widget.editOutletMap['PhoneNo'];
                                      _dropdownManagerValue= currentManager['Email'];
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
                                      _nameFormKey.currentState!.validate(), 
                                      _phoneFormKey.currentState!.validate(),
                                      _managerFormKey.currentState!.validate(),
                                      if(_nameFormKey.currentState!.validate() && _phoneFormKey.currentState!.validate() && _managerFormKey.currentState!.validate()){
                                        if(_nameController.text == widget.editOutletMap['OutletName'] && _phoneController.text == widget.editOutletMap['PhoneNo'] && _dropdownManagerValue == currentManager['Email']){
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
                                            _nameController.text,
                                            _phoneController.text,
                                            _dropdownManagerValue??'', 
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


// sign up button
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(0, (sWidth * 0.1), 0, (sWidth * 0.01)), // set top and bottom padding
                      //   child: 
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: <Widget>[
                      //         Expanded(
                      //           child:
                      //            createButton(
                      //             text: "Next",
                      //             fontSize: n2s, 
                      //             fontWeight: n2w,
                      //             bgColor: Theme.of(context).colorScheme.primary, 
                      //             textColor: Theme.of(context).colorScheme.onPrimary, 
                      //             letterSpacing: l2Space, 
                      //             px: 30,
                      //             py: 15, 
                      //             bradius: 15,
                      //             onPressed: () => {
                      //               _nameFormKey.currentState!.validate(), 
                      //               _phoneFormKey.currentState!.validate(),
                      //               _managerFormKey.currentState!.validate(),
                      //               if(_nameFormKey.currentState!.validate() && _phoneFormKey.currentState!.validate() && _managerFormKey.currentState!.validate()){
                      //                 navigateTo(context, widget, AddOutletAddrPage(
                      //                   outletDetails: {
                      //                   'OutletName': _nameController.text,
                      //                   'PhoneNo': _phoneController.text,
                      //                   'UserEmail' : _dropdownManagerValue,
                      //                   }),
                      //                   animationType: 'scrollRight')
                      //               },
                      //                 // navigateTo(context, widget, AddOutletAddrPage(
                      //                 //   outletDetails: {
                      //                 //   'OutletName': _nameController.text,
                      //                 //   'PhoneNo': _phoneController.text,
                      //                 //   'UserEmail' : _dropdownManagerValue,
                      //                 //   }),
                      //                 //   animationType: 'scrollRight')
                      //             },
                      //             ),                               
                      //         ),

                      //       ],
                      //     ),
                      // ),
                      
                      
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