
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaselist_pg.dart';
import 'package:stockapp/page/authenticated/purchase/viewpurchasedetails_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/util/custom_widgets.dart';

// external packages
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class StockRequestPage extends StatefulWidget {
  const StockRequestPage({super.key});

  @override
  State<StockRequestPage> createState() => _StockRequestPageState();
}

class _StockRequestPageState extends State<StockRequestPage> {

  late Stream<QuerySnapshot> _requestStream;

  late int currentOutletId;

  List<Map<String, dynamic>> outletmaplist = [];  

  // List<String> outletList = [];
  // String? _dropdownValue;

  @override
  void initState(){
    super.initState();
    _requestStream = DatabaseMethods.getRequestSnapshot();
    currentOutletId = sessionUser['OutletID'];
    // _dropdownValue = sessionUser['OutletID'].toString();
  }

  Future<void> loadRequests() async {
    outletmaplist = await DatabaseMethods.getOutletListMap();
  }

  String getOutletNameById(int outletid){
    String returnStr = '';
    for(int i = 0; i < outletmaplist.length; i++){
      if(outletmaplist[i]['OutletID'] == outletid){
        returnStr = outletmaplist[i]['OutletName'];
      }
    }

    return returnStr;
  }

  void sendItem(Map<String, dynamic> requestMap) async {
    showLoadingDialog(
      title: "Processing",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );
    
    BuildContext oriContext = context;

    String invSenderAlertMsg = '';
    String invRecieveAlertMsg = '';

    // check if quantity enough, else give fail alert
    Map<String, dynamic> invRecord = await DatabaseMethods.getOutletInvAsMapByProductName(requestMap['ProductName'], requestMap['ToOutletID']);

    // Map<String, dynamic> invRecordRecieve = await DatabaseMethods.getOutletInvAsMapByProductName(requestMap['ProductName'], requestMap['FromOutletID']);

    if(invRecord.isNotEmpty){
      if(invRecord['Quantity'] < requestMap['Quantity']){
        // quantity insufficient
        createFail(oriContext, 'Send Failed', 'Insufficient Quantity in Stock');
      }
      else{
        // success

        // deduct qty
        invRecord['Quantity'] = invRecord['Quantity'] - requestMap['Quantity'];

        invSenderAlertMsg = await DatabaseMethods.updateInvDetails(invRecord);

        if(invSenderAlertMsg == ''){

          // add qty
          // invRecordRecieve['Quantity'] = invRecordRecieve['Quantity'] + requestMap['Quantity'];
          // invRecieveAlertMsg = await DatabaseMethods.updateInvDetails(invRecordRecieve);

          if(invRecieveAlertMsg == ''){

            // update update map
            // update status
            Map<String, dynamic> updateReqMap = requestMap;

            updateReqMap['Status'] = 'Sent';

            DatabaseMethods.updateRequestDetails(updateReqMap);        

            Navigator.pop(oriContext);
            createSuccess(oriContext, 'Successfully Sent', 'Item has been sent to Outlet : ${requestMap['FromOutletID']}');

          }
          else{
            Navigator.pop(oriContext);
            createFail(oriContext, 'Send Failed', invRecieveAlertMsg);
          }

        }
        else{
      Navigator.pop(oriContext);
          createFail(oriContext, 'Send Failed', invSenderAlertMsg);
        }


      }
    }
    else{
      Navigator.pop(oriContext);
      // failed to retrieve inv record
      createFail(oriContext, 'Send Failed', 'Failed to get relevant inventory record');
    }


  }

  void declineRequest(Map<String, dynamic> requestMap){

    BuildContext oriContext = context;

    // set status to declined 
    Map<String, dynamic> updateReqMap = requestMap;

    updateReqMap['Status'] = 'Declined';

    DatabaseMethods.updateRequestDetails(updateReqMap);        


    createFail(oriContext, 'Declined', 'Item requrest from Outlet : ${requestMap['FromOutletID']}, has been declined');

  }


  confirmSend(BuildContext oriContext, Map<String, dynamic> requestMap){
    
    showAlertDialog(
      title: 'Confirm Send?',
      message: 'Are you sure you want to send products to the corresponding outlet?',
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
      btnBgColor: Theme.of(context).colorScheme.errorContainer,
      btnTextColor: Theme.of(context).colorScheme.onError,
      btnOnPressed: () => {
        Navigator.of(context).pop(),
        sendItem(requestMap),

      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
      );

      
  }


  confirmDecline(BuildContext oriContext, Map<String, dynamic> requestMap){
    
    showAlertDialog(
      title: 'Confirm Decline?',
      message: 'Are you sure you want to decline the request?',
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      bradius: 15,

      // button params
      
      btnText : "Decline",
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
        declineRequest(requestMap),

      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
      );

      
  }

  createSuccess(BuildContext oriContext, String title, String message){
    
    showAlertDialog(
      title: title,
      message: message,
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

      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
      );

      
  }



  createFail(BuildContext oriContext, String title, String message){
    
    showAlertDialog(
      title: title,
      message: message,
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      bradius: 15,

      // button params
      
      btnText : "Back",
      btnFontSize: n2s,
      btnFontWeight: n2w,
      btnPx: 30,
      btnPy: 15,
      btnMb: 5,
      btnMr: 5,
      btnBradius: 15,
      btnOnPressed: () => {
        Navigator.of(context).pop(),

      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
      btnBgColor: Theme.of(context).colorScheme.error,
      btnTextColor: Theme.of(context).colorScheme.onError,
      );

      
  }


  // Future<void> loadOutletList() async {
  //   List<String> temp = await DatabaseMethods.getAllOutletAsList();
  //   if(temp.isEmpty){
  //     temp.add('Empty');
  //   }

  //   if(mounted){
  //     setState(() {
  //       outletList = temp;
  //     });
  //   }

  // }

  



  showSnackBar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.zero)
        ),
        content: createText(
          message,
          textColor: Theme.of(context).colorScheme.onBackground,
        ),
        duration: Duration(milliseconds: 2000),
      ),
    );
  }


  @override 
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                    stream: _requestStream,
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Center(
                          child: Text("Failed to load requests : ${snapshot.error}"),
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


                      List<QueryDocumentSnapshot> requests = snapshot.data!.docs;

                      bool emptyForOutlet = false;
                      List templist = [];

                      for(int i = 0; i < requests.length; i++){
                        var temp = requests[i].data() as Map<String, dynamic>;
                        if(temp['ToOutletID'] == currentOutletId){
                          templist.add(temp);
                        }
                      }

                      if(templist.isEmpty){
                        emptyForOutlet = true;
                      }

                      if(emptyForOutlet){
                        return
                        Center(
                          child:
                          createText(
                            'No New Requests',
                            fontSize: n1s,
                            textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                        );
                      }

                      return
                      FutureBuilder(
                        future: loadRequests(),
                        builder: (context, fsnapshot){
                        if (fsnapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: 
                              LoadingAnimationWidget.stretchedDots(
                                color: Theme.of(context).colorScheme.primary,
                                size: 50,
                              ),
                            );
                        } else if (fsnapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        }




                      return
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: requests.length,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 50),
                        itemBuilder: (context, index){
                          var request = requests[index].data() as Map<String, dynamic>;
                          if(request['ToOutletID'] != currentOutletId){
                            return Container();
                          }
                          else{
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



// start 
                                      Expanded(
                                        flex: 9,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, ViewPurchaseDetailsPage(pmap: purchase), animationType: 'scrollRight');
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
                                                  '${request['ProductName']}',
                                                  fontSize: n2s,
                                                  fontWeight: h3w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'Qty ${request['Quantity']}',
                                                  fontSize: n3s,
                                                  fontWeight: FontWeight.w300,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                  mt: 5,
                                                  mb: 5,
                                                ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child:
                                                createText(
                                                  'From : ${getOutletNameById(request['FromOutletID'])}',
                                                  fontSize: n3s,
                                                  fontWeight: h4w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                )
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      Expanded(
                                        flex: 3,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            // navigateTo(context, widget, ViewPurchaseDetailsPage(pmap: purchase), animationType: 'scrollRight');
                                          },
                                          child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:  
                                              [
                                                createButton(
                                                text: "Send",
                                                fontSize: 12, 
                                                fontWeight: n2w,
                                                bgColor: Theme.of(context).colorScheme.errorContainer, 
                                                textColor: Theme.of(context).colorScheme.onError, 
                                                letterSpacing: 0.5, 
                                                px: 10,
                                                py: 5,
                                                bradius: 10,
                                                onPressed: () => {
                                                  confirmSend(context, request),
                                                },
                                                ),
                                              ],
                                            ),


                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:  
                                              [
                                                createButton(
                                                text: "Decline",
                                                fontSize: 12, 
                                                fontWeight: n2w,
                                                bgColor: Theme.of(context).colorScheme.error, 
                                                textColor: Theme.of(context).colorScheme.onError, 
                                                letterSpacing: 0.5, 
                                                px: 10,
                                                py: 5,
                                                bradius: 10,
                                                onPressed: () => {
                                                  confirmDecline(context, request),
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
                        }
                      );
/// //// / / // / / // / . ////////////////////////        

                        }
                      );




                    }

                  ),
                // ),

                // Container(
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background.withAlpha(0)],
                //       stops: [0.92, 1]
                //     ),
                //   ),
                //   child:
                //   Row(
                    
                //     children:[

                //     Expanded(
                //       flex: (sessionUser['Role'] == 'Staff')?10:7,
                //       // flex: 7,
                //       child:
                //       createTextField(
                //         textColor: Theme.of(context).colorScheme.onBackground,
                //         hintText: "Search Record",
                //         bradius: 20,
                //         mt: 15,
                //         mb: 15,
                //         mr: 15,
                //         ml: 15,
                //         controller: searchController,
                //         inputAction: TextInputAction.search,
                //         onChanged: (value){
                //           searchText(value.toLowerCase());
                //         },
                //       ),
                //     ),

                //     (sessionUser['Role'] == 'Staff')?
                //     SizedBox.shrink() 
                //     :
                //     Expanded(
                //       flex: 3,
                //       child:
                //       createFormDropdownMenu(
                //       hintText: "Outlet",
                //       labelText: "Outlet",
                //       bradius: 15,
                //       mt: 15,
                //       mb: 15,
                //       mr: 15,
                //       fontSize: 16,
                //       fontWeight: n2w,
                //       textColor: Theme.of(context).colorScheme.onBackground,
                //       dropdownValue: _dropdownValue.toString(),
                //       dropdownItems: outletList,
                //       onChanged: (value){
                //         setState((){
                //           _dropdownValue = value;
                //           currentOutletId = int.parse(value??'0');
                //         });
                //       },
                //       validator: (value){
                //         if(value == null || value.isEmpty){
                //           return "Please select a staff";
                //         }
                //         else if(value == 'No Staff Available'){
                //           return "No Staff Available";
                //         }
                //         return null;
                //       }
                //       ),
                //     ),
                      

                //     ]

                //   ),
                // ),






              ],
            ),
        ),
      ),

    );
  }
}