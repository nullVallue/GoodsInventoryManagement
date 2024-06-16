
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class SetStaffRolePage extends StatefulWidget {
  final Map<String, dynamic> editUserMap;
  final Map<String, dynamic> editOutletMap;
  const SetStaffRolePage({super.key, required this.editUserMap, required this.editOutletMap});
  

  @override
  State<SetStaffRolePage> createState() => _SetStaffRolePageState();
}

class _SetStaffRolePageState extends State<SetStaffRolePage>{
  
  final _roleFormKey = GlobalKey<FormState>();
  final _roleController = TextEditingController();

  String? _dropdownRoleValue;

  bool editBtnVisible = true;

  List<String> dropdownRoles= [];


  List<String> dropdownOutlets = [];

  Future<void> loadDropDownList() async {
    dropdownRoles = [
      'Admin', 
      'Manager', 
      'Staff',
    ];
  }

  @override
  void initState(){
    super.initState();
    _dropdownRoleValue = widget.editUserMap['Role'];
  }

  void update(String role) async {
    
    BuildContext originalContext = context;

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

    Map<String, dynamic> updateMap = widget.editUserMap;

    BuildContext oriContext= context;

    String alertMsg = '';

    if(updateMap['Email'] != null){
      updateMap['Role'] = role;
    }
    else{
      Navigator.pop(originalContext);
      updateFail(oriContext, "Account Update Failed");
      return;
    }

    alertMsg = await DatabaseMethods.updateUserDetails(updateMap);


    Navigator.pop(originalContext);
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

  void removeFromOutlet() async {
    Map<String, dynamic> updateMap = widget.editUserMap;

    BuildContext oriContext= context;

    String alertMsg = '';

    if(updateMap['Email'] != null){
      updateMap['OutletID'] = 1000;
    }
    else{
      updateFail(oriContext, "Account Update Failed");
      return;
    }

    alertMsg = await DatabaseMethods.updateUserDetails(updateMap);


    if(alertMsg.isEmpty){
      // when register success, bring user to dashboard

      // ignore: use_build_context_synchronously
      DatabaseMethods.updateOutletStatus(false, widget.editOutletMap['OutletID']);
      updateSuccess(oriContext);
    }
    else{
      // else show dialog message
      // ignore: use_build_context_synchronously
      updateFail(oriContext, alertMsg);
    }
  }


  confirmRemove(BuildContext oriContext){

    showAlertDialog(
      title: "Confirm Removal?",
      message: "Are you sure you want to remove ${widget.editUserMap['FirstName']} from the outlet?\n\nNote : if this is the last staff, outlet will be set to inactive",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      bradius: 15,

      // button params
      
      btnText : "Confirm",
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
        removeFromOutlet(),
        Navigator.of(context).pop(),
        // navigateTo(oriContext, widget, LandingPage(pageIndex: 4,), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
    );
  }


  updateSuccess(BuildContext oriContext){

    showAlertDialog(
      title: "Update Success",
      message: "Details have been updated successfully",
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
        Navigator.of(oriContext).pop(),
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
        Navigator.of(oriContext).pop(),
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
            if(dropdownOutlets.isEmpty){
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
            physics: const NeverScrollableScrollPhysics(),
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
                          onPressed: ()=> Navigator.pop(context),
                        )
                        ]
                      ),
                    ),
// section 2
                    Container(
                      height: (sHeight * 0.6),
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
                                "Assign \n${widget.editUserMap['FirstName']}'s \nRole",
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
                                "Set the role for the staff member",
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
                                  key: _roleFormKey,
                                  child:
                                  createFormDropdownMenu(
                                  hintText: "Select a role",
                                  labelText: "Account Role",
                                  controller: _roleController,
                                  bradius: 15,
                                  fontSize: n2s,
                                  fontWeight: n2w,
                                  textColor: Theme.of(context).colorScheme.onBackground,
                                  dropdownValue: _dropdownRoleValue,
                                  dropdownItems: dropdownRoles,
                                  onChanged: editBtnVisible? null : (value){
                                    setState((){
                                      _dropdownRoleValue = value;
                                    });
                                  },
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return "Please select a role";
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
                                      _roleController.text = widget.editUserMap['Role'];
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
                                      _roleFormKey.currentState!.validate(),
                                      if(_roleFormKey.currentState!.validate()){
                                        if(_roleController.text == widget.editUserMap['Role']){
                                          setState((){
                                            editBtnVisible = true;
                                          }),
                                        }
                                        else{
                                          setState((){
                                            editBtnVisible = true;
                                          }),
                                          print(_roleController.text),
                                          update(
                                            _dropdownRoleValue??'', 
                                          )
                                        }

                                      },
                                    },
                                    ),                               
                                ),

                              ],
                            ),
                        ),
                      ),

                      Visibility(
                        visible: editBtnVisible,
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
                                    text: "Remove From Outlet",
                                    fontSize: n2s, 
                                    fontWeight: n2w,
                                    bgColor: Theme.of(context).colorScheme.error, 
                                    textColor: Theme.of(context).colorScheme.onPrimary, 
                                    letterSpacing: l2Space, 
                                    px: 30,
                                    py: 15, 
                                    bradius: 15,
                                    onPressed: () => {
                                      confirmRemove(context),
                                    },
                                    ),                               
                                ),

                              ],
                            ),
                        ),
                      )

                      
                      
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