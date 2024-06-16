
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockapp/page/authenticated/outlet/addoutlet_pg.dart';
import 'package:stockapp/page/authenticated/outlet/editoutletmenu_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/util/custom_widgets.dart';

// external packages
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {



  @override
  void initState(){
    super.initState();
    // themeManager.addListener(themeListener);
  }

  bool loaded = false;

  Map<String, dynamic> managerPerm = {

    'ManageOutlet' : false,
    'ManagePurchase' : false,
    'ManageUser' : false,
    'ViewOtherOutlets' : false,
    'ViewReport' : false,
  };
  Map<String, dynamic> staffPerm = {
    'ManageOutlet' : false,
    'ManagePurchase' : false,
    'ManageUser' : false,
    'ViewOtherOutlets' : false,
    'ViewReport' : false,

  };

  loadPerms() async {
    managerPerm = await DatabaseMethods.getRolePermissionAsMap('Manager');
    staffPerm = await DatabaseMethods.getRolePermissionAsMap('Staff');


    staffManageOutlet = staffPerm['ManageOutlet'];
    staffManagePurchase = staffPerm['ManagePurchase'];
    staffManageUser = staffPerm["ManageUser"];
    staffViewOutlets = staffPerm["ViewOtherOutlets"];
    staffViewReport = staffPerm["ViewReport"];

    managerManageOutlet = managerPerm['ManageOutlet'];
    managerManagePurchase = managerPerm['ManagePurchase'];
    managerManageUser = managerPerm["ManageUser"];
    managerViewOutlets = managerPerm["ViewOtherOutlets"];
    managerViewReport = managerPerm["ViewReport"];

    loaded = true;


  }

  bool darkmode = (themeManager.themeMode == ThemeMode.dark)?true: false;

  bool staffManageOutlet = false;
  bool staffManagePurchase = false;
  bool staffManageUser = false;
  bool staffViewOutlets = false;
  bool staffViewReport = false;


  themeListener(){
    if(mounted){
      setState(() {
        
      });
    }
  }


  switchDarkMode(bool isActive) async {
    setState(() {
      darkmode = isActive;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDark', isActive);

    themeManager.toggleTheme(isActive);

  }

  switchStaffOutlet(bool isActive) async {

    staffPerm['ManageOutlet'] = isActive;

    await DatabaseMethods.updatePermDetails(staffPerm);

    setState(() {
      staffManageOutlet = isActive;
    });

  }


  switchStaffPurchase (bool isActive) async {
    staffPerm['ManagePurchase'] = isActive;

    await DatabaseMethods.updatePermDetails(staffPerm);
    setState(() {
      staffManagePurchase = isActive;
    });

  }


  switchStaffUser (bool isActive) async {
    staffPerm['ManageUser'] = isActive;

    await DatabaseMethods.updatePermDetails(staffPerm);
    setState(() {
      staffManageUser = isActive;
    });

  }


  switchStaffViewOutlet(bool isActive) async {
    staffPerm['ViewOtherOutlets'] = isActive;

    await DatabaseMethods.updatePermDetails(staffPerm);
    setState(() {
      staffViewOutlets = isActive;
    });

  }


  switchStaffReport(bool isActive) async {
    staffPerm['ViewReport'] = isActive;

    await DatabaseMethods.updatePermDetails(staffPerm);
    setState(() {
      staffViewReport = isActive;
    });

  }


  bool managerManageOutlet = false;
  bool managerManagePurchase = false;
  bool managerManageUser = false;
  bool managerViewOutlets = false;
  bool managerViewReport = false;


  switchManagerOutlet(bool isActive) async {
    managerPerm['ManageOutlet'] = isActive;

    await DatabaseMethods.updatePermDetails(managerPerm);
    setState(() {
      staffManageOutlet = isActive;
    });

  }


  switchManagerPurchase (bool isActive) async {
    managerPerm['ManagePurchase'] = isActive;

    await DatabaseMethods.updatePermDetails(managerPerm);
    setState(() {
      staffManagePurchase = isActive;
    });

  }


  switchManagerUser (bool isActive) async {
    managerPerm['ManageUser'] = isActive;

    await DatabaseMethods.updatePermDetails(managerPerm);
    setState(() {
      staffManageUser = isActive;
    });

  }


  switchManagerViewOutlet(bool isActive) async {
    managerPerm['ViewOtherOutlets'] = isActive;

    await DatabaseMethods.updatePermDetails(managerPerm);
    setState(() {
      staffViewOutlets = isActive;
    });

  }


  switchManagerReport(bool isActive) async {
    managerPerm['ViewReport'] = isActive;

    await DatabaseMethods.updatePermDetails(managerPerm);
    setState(() {
      staffViewReport = isActive;
    });

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





  @override 
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: 
      WillPopScope(onWillPop: () async {return false;},
        child: 
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:
          FutureBuilder(
            future: loadPerms(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                if(!loaded){

                return Center(
                  child: 
                  LoadingAnimationWidget.stretchedDots(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  ),
                );
                }
              }
              else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              return

        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: 
            Column(
              children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: 

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 1,
                      color: Theme.of(context).colorScheme.secondary,
                      child:
                      Container(
                        width: (sWidth * 0.9),
                        height: (sHeight * 0.08),
                        child:
                        Padding(
                          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: 
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child:
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: (){
                                    // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                  },
                                  child:
                                Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child:
                                        createText(
                                          'Dark Mode',
                                          fontSize: n2s,
                                          fontWeight: h3w,
                                          textColor: Theme.of(context).colorScheme.onSecondary,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        ),
                                      ],
                                    ),
                                  ]
                                ),
                                ),
                              ),


                              // VerticalDivider(
                              //   width: 0,
                              //   thickness: 1,
                              //   color: Colors.grey.withOpacity(0.3),
                              // ),

                              Expanded(
                                flex: 3,
                                child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: 
                                  [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        createSwitch(
                                          inactiveThumbColor: Colors.white,
                                          activeColor: Colors.white,
                                          activeTrackColor: Colors.greenAccent,
                                          value: darkmode,
                                          onChanged: (value){
                                            switchDarkMode(value);
                                          }
                                        ),
                                      ],
                                    )
                                  ]
                                ),
                              ),




                            ],
                          ),
                        )
                      ),
                    ),


                    )
                    ],
                  ),


                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child:
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),

                  ),

                  Visibility(
                    visible: (sessionUser['Role'] == 'Admin')?true:false,
                    child: 
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: 
                      Column(
                        children: [

                          Row(
                            children: [

                            createText(
                              'Staff Permissions',
                              textColor: Theme.of(context).colorScheme.onBackground,
                              ml: 20,
                              mb: 20,
                            )

                            ],

                          ),



                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: 

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              child:
                              Container(
                                width: (sWidth * 0.9),
                                height: (sHeight * 0.08),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'Manage Outlet',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // VerticalDivider(
                                      //   width: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),

                                      Expanded(
                                        flex: 3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: staffManageOutlet,
                                                  onChanged: (value){
                                                    switchStaffOutlet(value);
                                                  }
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                      ),




                                    ],
                                  ),
                                )
                              ),
                            ),


                            )
                            ],
                          ),



                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: 

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              child:
                              Container(
                                width: (sWidth * 0.9),
                                height: (sHeight * 0.08),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'Manage Purchase',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // VerticalDivider(
                                      //   width: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),

                                      Expanded(
                                        flex: 3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: staffManagePurchase,
                                                  onChanged: (value){
                                                    switchStaffPurchase(value);
                                                  }
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                      ),




                                    ],
                                  ),
                                )
                              ),
                            ),


                            )
                            ],
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: 

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              child:
                              Container(
                                width: (sWidth * 0.9),
                                height: (sHeight * 0.08),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'Manage User',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // VerticalDivider(
                                      //   width: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),

                                      Expanded(
                                        flex: 3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: staffManageUser,
                                                  onChanged: (value){
                                                    switchStaffUser(value);
                                                  }
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                      ),




                                    ],
                                  ),
                                )
                              ),
                            ),


                            )
                            ],
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: 

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              child:
                              Container(
                                width: (sWidth * 0.9),
                                height: (sHeight * 0.08),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'View Other Outlets',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // VerticalDivider(
                                      //   width: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),

                                      Expanded(
                                        flex: 3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: staffViewOutlets,
                                                  onChanged: (value){
                                                    switchStaffViewOutlet(value);
                                                  }
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                      ),




                                    ],
                                  ),
                                )
                              ),
                            ),


                            )
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: 

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              child:
                              Container(
                                width: (sWidth * 0.9),
                                height: (sHeight * 0.08),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'View Report',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // VerticalDivider(
                                      //   width: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),

                                      Expanded(
                                        flex: 3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: staffViewReport,
                                                  onChanged: (value){
                                                    switchStaffReport(value);
                                                  }
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                      ),




                                    ],
                                  ),
                                )
                              ),
                            ),


                            )
                            ],
                          ),

                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey.withOpacity(0.3),
                          ),

                          Row(
                            children: [

                            createText(
                              'Manager Permissions',
                              textColor: Theme.of(context).colorScheme.onBackground,
                              ml: 20,
                              mt: 20,
                              mb: 20,
                            )

                            ],

                          ),



                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: 

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              child:
                              Container(
                                width: (sWidth * 0.9),
                                height: (sHeight * 0.08),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'Manage Outlet',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // VerticalDivider(
                                      //   width: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),

                                      Expanded(
                                        flex: 3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: managerManageOutlet,
                                                  onChanged: (value){
                                                    switchManagerOutlet(value);
                                                  }
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                      ),




                                    ],
                                  ),
                                )
                              ),
                            ),


                            )
                            ],
                          ),



                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: 

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              child:
                              Container(
                                width: (sWidth * 0.9),
                                height: (sHeight * 0.08),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'Manage Purchase',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // VerticalDivider(
                                      //   width: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),

                                      Expanded(
                                        flex: 3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: managerManagePurchase,
                                                  onChanged: (value){
                                                    switchManagerPurchase(value);
                                                  }
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                      ),




                                    ],
                                  ),
                                )
                              ),
                            ),


                            )
                            ],
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: 

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              child:
                              Container(
                                width: (sWidth * 0.9),
                                height: (sHeight * 0.08),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'Manage User',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // VerticalDivider(
                                      //   width: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),

                                      Expanded(
                                        flex: 3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: managerManageUser,
                                                  onChanged: (value){
                                                    switchManagerUser(value);
                                                  }
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                      ),




                                    ],
                                  ),
                                )
                              ),
                            ),


                            )
                            ],
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: 

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              child:
                              Container(
                                width: (sWidth * 0.9),
                                height: (sHeight * 0.08),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'View Other Outlets',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // VerticalDivider(
                                      //   width: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),

                                      Expanded(
                                        flex: 3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: managerViewOutlets,
                                                  onChanged: (value){
                                                    switchManagerViewOutlet(value);
                                                  }
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                      ),




                                    ],
                                  ),
                                )
                              ),
                            ),


                            )
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: 

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 1,
                              color: Theme.of(context).colorScheme.secondary,
                              child:
                              Container(
                                width: (sWidth * 0.9),
                                height: (sHeight * 0.08),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'View Report',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // VerticalDivider(
                                      //   width: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey.withOpacity(0.3),
                                      // ),

                                      Expanded(
                                        flex: 3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: managerViewReport,
                                                  onChanged: (value){
                                                    switchManagerReport(value);
                                                  }
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                      ),




                                    ],
                                  ),
                                )
                              ),
                            ),


                            )
                            ],
                          ),





                        ],
                      )
                    )
                  )

                  


                // Expanded(
                //   child: 
                // ),

              ],
            ),
        );
            }
          )
        ),
      ),
      


      // Padding(
      //   padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
      //   child: 
      //   FloatingActionButton(
      //     backgroundColor: Theme.of(context).colorScheme.secondary,
      //     onPressed: (){},
      //     child: Icon(
      //       Icons.add_rounded,
      //       size: 25,
      //       color: Theme.of(context).colorScheme.onSecondary,
      //       ),
      //   ),
      // )
    );
  }
}