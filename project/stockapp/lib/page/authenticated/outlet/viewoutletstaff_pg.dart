
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stockapp/page/authenticated/outlet/editoutletmenu_pg.dart';
import 'package:stockapp/page/authenticated/outlet/outletaddstaff_pg.dart';
import 'package:stockapp/page/authenticated/outlet/setstaffrole_pg.dart';
import 'package:stockapp/page/authenticated/user/userfulldetails_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/util/custom_widgets.dart';

// external packages
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ViewOutletStaffPage extends StatefulWidget {
  final Map<String, dynamic> outletDetails; 

  const ViewOutletStaffPage({super.key, required this.outletDetails});

  @override
  State<ViewOutletStaffPage> createState() => _ViewOutletStaffPageState();
}

class _ViewOutletStaffPageState extends State<ViewOutletStaffPage> {

  late Stream<QuerySnapshot> _staffStream;

  @override
  void initState(){
    super.initState();
    _staffStream = DatabaseMethods.getStaffSnapshot(widget.outletDetails['OutletID']);
  }


  String getUserFirstLastName(Map<String, dynamic>user){
    if(user['Email'] == sessionUser['Email']){
      return user['FirstName'] + ' ' + user['LastName'] + " (You)";
    }
    else{
      return user['FirstName'] + ' ' + user['LastName'];
    }
  }

  void clearStaff() async {
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

    BuildContext oriContext = context;

    String alertMsg = '';

    alertMsg = await DatabaseMethods.clearStaff(widget.outletDetails['OutletID']);


    if(alertMsg.isEmpty){
      // when register success, bring user to dashboard

      // ignore: use_build_context_synchronously
      DatabaseMethods.updateOutletStatus(false, widget.outletDetails['OutletID']);

      Navigator.pop(oriContext);

      updateSuccess(oriContext);
    }
    else{
      // else show dialog message
      // ignore: use_build_context_synchronously
      Navigator.pop(oriContext);
      updateFail(oriContext, alertMsg);
    }

  }


  updateSuccess(BuildContext oriContext){

    showAlertDialog(
      title: "Staff Cleared",
      message: "All staff has been successfully removed from the outlet",
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

  confirmRemove(BuildContext oriContext){

    showAlertDialog(
      title: "Confirm Clear?",
      message: "Are you sure you want to remove all staff?\n\nOutlet will be set to inactive",
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
        Navigator.of(context).pop(),
        clearStaff(),
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
    return 
    Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: 
          IconButton(
            padding: EdgeInsets.fromLTRB(sWidth * 0.1 , 0, 0, 0),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: ()=> navigateTo(context, widget, EditOutletMenuPage(editOutletID: widget.outletDetails['OutletID'],), animationType : 'scrollLeft'),
          ),
        actions: [
          IconButton(
            padding: EdgeInsets.fromLTRB(0, 0, sWidth * 0.1 , 0),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(
              Icons.remove_circle_outline_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: (){
              confirmRemove(context);
            }
          ),
        ],
        elevation: 0,
        title:
          Text(
            "STAFF LIST",
            style: TextStyle(
              letterSpacing: 5,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: 
      WillPopScope(onWillPop: () async {return false;},
        child: 
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: 


            Stack(
              children: [
                // Expanded(
                //   child: 
                    StreamBuilder<QuerySnapshot>(
                    stream: _staffStream,
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Center(
                          child: Text("Failed to load staff list: ${snapshot.error}"),
                        );
                      }

                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: 
                          LoadingAnimationWidget.stretchedDots(
                            color: Theme.of(context).colorScheme.primary,
                            size: 50,
                          ),
                        );
                      }

                      List<QueryDocumentSnapshot> staffs = snapshot.data!.docs;

                      if(staffs.isEmpty){
                        return
                        Center(
                          child:
                          createText(
                            'List Empty',
                            fontSize: n1s,
                            textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                        );
                      }


                      return
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: staffs.length,
                        padding: EdgeInsets.fromLTRB(0, 25, 0, 50),
                        itemBuilder: (context, index){
                          var staff= staffs[index].data() as Map<String, dynamic>;
                          print('bye');
                          return 
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
                                width: (sWidth * 0.7),
                                height: (sHeight * 0.12),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: 
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child:
                                        InkWell(
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                



                                                createText(
                                                  staff['FirstName'],
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                ),
                                                createText(
                                                  ' ${staff['LastName']}',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                ),



                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                createText(
                                                  staff['Role'],
                                                  fontSize: n3s,
                                                  fontWeight: FontWeight.w300,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  mt: 5,
                                                  mb: 10,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle_rounded,
                                                  size: 12,
                                                  color: getStatusColor(staff['Status']),
                                                  ),
                                                createText(
                                                  staff['Status'],
                                                  fontSize: n3s,
                                                  fontWeight: h4w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  ml: 10,
                                                ),
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 2,
                                        child:
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserFullDetailsPage(userDetails: staff,)));
                                          },
                                          child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:  
                                              [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.info_outline_rounded,
                                                    size: 30,
                                                    ),

                                                  // color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                                                  color: Colors.grey.withOpacity(0.8),
                                                  // color: Theme.of(context).colorScheme.onSecondary,
                                                  onPressed: (){
                                                    // null;
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => UserFullDetailsPage(userDetails: staff,)));
                                                  },
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 2,
                                        child:
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserFullDetailsPage(userDetails: staff,)));
                                          },
                                          child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:  
                                              [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.settings_accessibility_outlined,
                                                    size: 30,
                                                    ),

                                                  color: Colors.grey.withOpacity(0.7),
                                                  // color: Theme.of(context).colorScheme.onSecondary,
                                                  onPressed: (){
                                                    // null;
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SetStaffRolePage(editUserMap: staff, editOutletMap: widget.outletDetails,)));
                                                  },
                                                ),
                                              ],
                                            )
                                          ]
                                        ),
                                        ),
                                      ),


                                    ],
                                  ),
                                )
                              ),
                            ),
                          );
                        }
                      );


                    }

                  ),
                // ),
              ],
            ),
        ),
      ),
      floatingActionButton: 
        FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          heroTag: null,
          child: const Icon(Icons.person_add_alt_1_rounded),
          onPressed: () {
            navigateTo(context, widget, OutletAddStaffPage(outletMap: widget.outletDetails), animationType: "scrollRight");
          },
        ),
      

    );
  }
}