

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/autocounter/acinvmenu_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class EditInvPage extends StatefulWidget {
  final Map<String, dynamic> editInvMap;
  const EditInvPage({super.key, required this.editInvMap});
  

  @override
  State<EditInvPage> createState() => _EditInvPageState();
}

class _EditInvPageState extends State<EditInvPage>{
  
  final _qtyFormKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();

  bool editBtnVisible = true;
  late bool isHidden;

  final FocusNode qtyFocusNode = FocusNode();

  @override
  void initState(){
    super.initState();
    isHidden = widget.editInvMap['Hidden']; 
  }

  Future<void> loadQty() async {
    _qtyController.text = widget.editInvMap['Quantity'].toString();
  }

  void setHidden(bool hide) async {

    Map<String, dynamic> updateMap = widget.editInvMap;
    updateMap['Hidden'] = hide;

    await DatabaseMethods.updateInvDetails(updateMap);

    widget.editInvMap['Hidden'] = hide;
    setState(() {
      isHidden = hide;
    });

  }

  void update(int qty) async {


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

    Map<String, dynamic> updateMap = widget.editInvMap;

    BuildContext oriContext = context;

    String alertMsg = '';

    updateMap['Quantity']= qty;

    alertMsg = await DatabaseMethods.updateInvDetails(updateMap);

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
  
  void tally() async {
    BuildContext oriContext = context;
    Map<String, dynamic> productmap = await DatabaseMethods.getProductMapByName(widget.editInvMap['ProductName']);


    Navigator.push(context, MaterialPageRoute(builder: (context)=> ACInvMenuPage(invMap: widget.editInvMap, productDetails: productmap)));

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
        navigateTo(oriContext, widget, LandingPage(pageIndex: 3,), animationType: "scrollLeft"),
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
        // Navigator.of(context).pop(),
        navigateTo(oriContext, widget, LandingPage(pageIndex: 3,), animationType: "scrollLeft"),
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
        future: loadQty(),
        builder: (context, snapshot) {
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


                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  BackButton(
                                    onPressed: ()=> navigateTo(context, widget, LandingPage(pageIndex: 3), animationType : 'scrollLeft'),
                                  )
                                ],
                              )
                            ],

                          ),



                          Spacer(),



                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [


                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: 
                                (isHidden)? 
                                [
                                  IconButton(
                                    onPressed: (){
                                      setHidden(false);
                                    },
                                    icon: Icon(Icons.visibility_off_outlined),
                                    // color: Theme.of(context).colorScheme.onTertiaryContainer
                                  )
                                ] 
                                :
                                [
                                  IconButton(
                                    onPressed: (){
                                      setHidden(true);
                                    },
                                    icon: Icon(Icons.visibility_outlined),
                                    // color: Theme.of(context).colorScheme.onTertiaryContainer
                                  )
                                ]
                              )
                            ],



                          ),



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
                                "Edit \n${widget.editInvMap['ProductName']}",
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
                                "Last Tallied at :\n${timestampToStr(widget.editInvMap['LastTallied'], 'dd/MM/yyyy, HH:mm')}",
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
                                  key: _qtyFormKey,
                                  child:
                                  createFormTextField(
                                    focusNode: qtyFocusNode,
                                    hintText: "e.g. 10",
                                    labelText: "Quantity",
                                    bradius: 15,
                                    enabled: !editBtnVisible,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    keyboardType: TextInputType.number,
                                    controller: _qtyController,
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


                        Padding(
                          padding: EdgeInsets.fromLTRB(0, (sWidth * 0.1), 0, (sWidth * 0.0)), // set top and bottom padding
                          child: 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child:
                                  createButton(
                                    text: "Tally",
                                    fontSize: n2s, 
                                    fontWeight: n2w,
                                    bgColor: Theme.of(context).colorScheme.tertiary, 
                                    textColor: Theme.of(context).colorScheme.onTertiary, 
                                    letterSpacing: l2Space, 
                                    px: 30,
                                    py: 15, 
                                    bradius: 15,
                                    onPressed: () => {
                                      tally(),
                                    },
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
                                        qtyFocusNode.requestFocus();
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
                                      _qtyController.text = widget.editInvMap['Quantity'].toString();
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
                                      _qtyFormKey.currentState!.validate(), 
                                      if(_qtyFormKey.currentState!.validate()){
                                        if(_qtyController.text == widget.editInvMap['Quantity'].toString()){
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
                                            int.parse(_qtyController.text)
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