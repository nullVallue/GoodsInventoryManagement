
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/page/authenticated/outlet/addoutletaddr_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class AddOutletPage extends StatefulWidget {
  const AddOutletPage({super.key});
  

  @override
  State<AddOutletPage> createState() => _AddOutletPageState();
}

class _AddOutletPageState extends State<AddOutletPage>{
  
  final _nameFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _managerFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _dropdownManagerValue;
  bool noManager = true;

  // List<DropdownMenuItem<String>> managerList = [];
  List<String> managerList = [];

  Future<void> loadManagerDropdown() async {
    managerList = await DatabaseMethods.getManagerList();

    for(int i = 0; i < managerList.length; i++){
      Map<String, dynamic> user = await DatabaseMethods.getUserByEmailAsMap(managerList[i]);
      if(await DatabaseMethods.checkManagerHolding(user['UserID'])){
        managerList.removeAt(i);
        i--;
      }
      else if(user['Status'] != 'Active'){
        managerList.removeAt(i);
        i--;
      }
    }    

    if(managerList.isEmpty){
      managerList.add('No Managers Available');
    }
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
                      
        //sign up heading 
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0.01), 0, (sWidth * 0.01)), // set top and bottom padding
                        child: 
                          Row(
                            children: <Widget>[
                              createText(
                                "Add an Outlet",
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
                                "Add a new outlet to the system",
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
                                    hintText: "e.g. Apple Georgetown",
                                    labelText: "Outlet Name",
                                    bradius: 15,
                                    fontSize: n2s,
                                    fontWeight: n2w,
                                    textColor: Theme.of(context).colorScheme.onBackground,
                                    controller: _nameController,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "Pleaes Enter Outlet Name";
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
                                  onChanged: (value){
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
                                    _nameFormKey.currentState!.validate(), 
                                    _phoneFormKey.currentState!.validate(),
                                    _managerFormKey.currentState!.validate(),
                                    if(_nameFormKey.currentState!.validate() && _phoneFormKey.currentState!.validate() && _managerFormKey.currentState!.validate()){
                                      navigateTo(context, widget, AddOutletAddrPage(
                                        outletDetails: {
                                        'OutletName': _nameController.text,
                                        'PhoneNo': _phoneController.text,
                                        'UserEmail' : _dropdownManagerValue,
                                        }),
                                        animationType: 'scrollRight')
                                    },
                                      // navigateTo(context, widget, AddOutletAddrPage(
                                      //   outletDetails: {
                                      //   'OutletName': _nameController.text,
                                      //   'PhoneNo': _phoneController.text,
                                      //   'UserEmail' : _dropdownManagerValue,
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