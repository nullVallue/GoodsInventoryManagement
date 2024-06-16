

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class UserFullDetailsPage extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  const UserFullDetailsPage({super.key, required this.userDetails});
  

  @override
  State<UserFullDetailsPage> createState() => _UserFullDetailsPageState();
}

class _UserFullDetailsPageState extends State<UserFullDetailsPage>{

  late Map<String, dynamic> userDetails;
  
  @override
  void initState(){
    super.initState();
    userDetails = widget.userDetails;
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
// section 1
                    Container(
                      height: (0.2*sHeight),
                      child:
                      Row(
                        children: <Widget>[
                        BackButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                        ]
                      ),
                    ),



// section 2
                    Container(
                      // height: (0.6*sHeight),                
                      child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      

                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20), // set top and bottom padding
                      child: 
                      (userDetails['ImageURL']!='')?
                      ProfilePicture(
                        name: '${userDetails['FirstName']} ${userDetails['LastName']}',
                        radius: 70,
                        fontsize: 25,
                        img: userDetails['ImageURL'],
                        // random: true,
                      )
                      :
                      ProfilePicture(
                        name: '${userDetails['FirstName']} ${userDetails['LastName']}',
                        radius: 70,
                        fontsize: 25,
                        // random: true,
                      ),

                    ),




                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5), // set top and bottom padding
                  child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        createText(
                          userDetails['FirstName'],
                          fontSize: h3s,
                          fontWeight: h2w,
                          textColor: Theme.of(context).colorScheme.onBackground,
                          ),
                        createText(
                          ' ' + userDetails['LastName'],
                          fontSize: h3s,
                          fontWeight: h2w,
                          textColor: Theme.of(context).colorScheme.onBackground,
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
                        Icon(
                          Icons.circle_rounded,
                          size: 12,
                          color: getStatusColor(userDetails['Status']),
                          ),
                        createText(
                          userDetails['Status'],
                          fontSize: n3s,
                          fontWeight: h4w,
                          textColor: Theme.of(context).colorScheme.onSecondary,
                          ml: 10,
                        ),
                      ],
                    ),
                ),


                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20), // set top and bottom padding
                  child: 
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 1,
                    color: Theme.of(context).colorScheme.secondary,
                    child:
                    Container(
                      width: (sWidth * 0.8),
                      child:
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                        child: 
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                createText(
                                  'Full User Details',
                                  fontSize: n1s,
                          textColor: Theme.of(context).colorScheme.onBackground,
                                  fontWeight: h1w,
                                  mb: 20,
                                )
                              ],
                            ),


                            // outlet row
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: 

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              createText(
                                                'Outlet',
                                                fontSize: sub3s,
                                                fontWeight: h1w,
                          textColor: Theme.of(context).colorScheme.onBackground,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                    Expanded(
                                      flex: 6,
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child:
                                                (userDetails['OutletID']== 1000)?
                                                createText('Unassigned',
                          textColor: Theme.of(context).colorScheme.onBackground,
                                                ):
                                                createText(
                                                  userDetails['OutletID'].toString(),
                          textColor: Theme.of(context).colorScheme.onBackground,
                                                  )
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            

                            // role row
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              createText(
                                                'Role',
                                                fontSize: sub3s,
                          textColor: Theme.of(context).colorScheme.onBackground,
                                                fontWeight: h1w,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                    Expanded(
                                      flex: 6,
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child:
                                                createText(userDetails['Role'],
                          textColor: Theme.of(context).colorScheme.onBackground,
                                                )
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // email row
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: 
                                // email row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              createText(
                                                'E-mail',
                                                fontSize: sub3s,
                          textColor: Theme.of(context).colorScheme.onBackground,
                                                fontWeight: h1w,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                    Expanded(
                                      flex: 6,
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child:
                                                createText(userDetails['Email'],
                          textColor: Theme.of(context).colorScheme.onBackground,
                                                )
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                            // phone row
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              createText(
                                                'Phone',
                          textColor: Theme.of(context).colorScheme.onBackground,
                                                fontSize: sub3s,
                                                fontWeight: h1w,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                    Expanded(
                                      flex: 6,
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: 
                                                createText(
                                                  userDetails['PhoneNo'],
                                              textColor: Theme.of(context).colorScheme.onBackground,
                                                  )
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),



                            // address row
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              createText(
                                                'Address',
                                                fontSize: sub3s,
                          textColor: Theme.of(context).colorScheme.onBackground,
                                                fontWeight: h1w,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                    Expanded(
                                      flex: 6,
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child:
                                              Text(
                                                '${userDetails['AddressLine1']}, \n${userDetails['AddressLine2']}, \n${userDetails['Postcode']},\n${userDetails['State']}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context).colorScheme.onBackground,
                                                ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),



                          ],
                        ),

                      ),

                    ),
                  ),
                ),

    // email label and textfield

        ////////////////////////////////////////////////////////////////////////////////////////////////////////

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
        ),
    );
  }
}