
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaseitem_pg.dart';
import 'package:stockapp/page/authenticated/purchase/editpurchaseitem_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/util/custom_widgets.dart';

class AddPurchaseListPage extends StatefulWidget {
  final List<Map<String, dynamic>> itemmaplist; 
  final int outletid; 

  const AddPurchaseListPage({super.key, required this.itemmaplist, required this.outletid});

  @override
  State<AddPurchaseListPage> createState() => _AddPurchaseListPageState();
}

class _AddPurchaseListPageState extends State<AddPurchaseListPage> {

  late List<Map<String, dynamic>> itemmaplist;

  @override
  void initState(){
    super.initState();
    itemmaplist = widget.itemmaplist;
  }

  addpurchase() async {

    // DatabaseMethods.test();
    // return;

    showLoadingDialog(
      title: "Adding Record",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );


    BuildContext originalContext = context;
    String pAlertMsg = '';
    String piAlertMsg = '';

    Map<String, dynamic> purchasemap = {
      'OutletID' : widget.outletid,
      'PurchaseID' : 0,
      'PurchaseTimestamp' : DateTime.now(),
      'Status' : 'Pending',
      'TotalPrice' : double.parse(getGrandTotal()),
      'UserID' : sessionUser['UserID'],
    };

    pAlertMsg = await DatabaseMethods.addPurchaseDetails(purchasemap);

    if(pAlertMsg == ''){
      int purchaseid = int.parse(await DatabaseMethods.getLatestPurchaseID());
      
      for(int i = 0; i < widget.itemmaplist.length; i++){


        Map<String, dynamic> item = {
          'PurchaseItemID' : 0,
          'ProductSupplierID' : widget.itemmaplist[i]['ProductSupplierID'],
          'PurchaseID' : purchaseid,
          'Quantity' : widget.itemmaplist[i]['Quantity'],
          'Counted' : false,
        };

        piAlertMsg = await DatabaseMethods.addPurchaseItemDetails(item);

        if(piAlertMsg != ''){
          break;
        }
      }
    }


    Navigator.pop(originalContext);
    
    if(pAlertMsg.isEmpty && piAlertMsg.isEmpty){
      // when register success, bring user to dashboard

      // ignore: use_build_context_synchronously
      createSuccess(originalContext);
    }
    else{
      if(pAlertMsg.isEmpty){
        createFail(originalContext, piAlertMsg);
      }
      else if(piAlertMsg.isEmpty){
        createFail(originalContext, pAlertMsg);

      }
      // else show dialog message
      // ignore: use_build_context_synchronously
    }

  }

  createSuccess(BuildContext oriContext){

    showAlertDialog(
      title: "Added New Order",
      message: "Your Order Has Been Created",
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
        navigateTo(oriContext, widget, LandingPage(pageIndex: 5,), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
    );
  }

  createFail(BuildContext oriContext, String errMsg){

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
        navigateTo(oriContext, widget, LandingPage(pageIndex: 5,), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
    );
  }

  clearAllItems(){
    setState(() {
      
      itemmaplist = [];
    });
  }

  confirmRemove(BuildContext oriContext){

    showAlertDialog(
      title: "Confirm Clear?",
      message: "Are you sure you want to remove all items?",
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
        clearAllItems(),
        Navigator.of(context).pop(),
        // clearStaff(),
        // navigateTo(oriContext, widget, LandingPage(pageIndex: 4,), animationType: "scrollLeft"),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SignUpPage()),
        // ),

      },
    );
  }

  String getGrandTotal(){
    double total = 0;
    if(itemmaplist.isNotEmpty){
      for(int i = 0; i < itemmaplist.length; i ++){
        total += itemmaplist[i]['TotalPrice'].toDouble();
      }  
    }
    return total.toStringAsFixed(2);
  }



  orderConfirmWindow(BuildContext oriContext){
    
    showAlertDialog(
      title: "Confirm Create Order?",
      message: "You will not be able to cancel order after confirmation",
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
        addpurchase(),

      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
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
            onPressed: ()=> navigateTo(context, widget, LandingPage(pageIndex: 5,), animationType : 'scrollLeft'),
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
            "ORDER LIST",
            style: TextStyle(
              letterSpacing: 3,
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

                (itemmaplist.isEmpty)?

                Center(
                  child:
                  createText(
                    'List Empty',
                    fontSize: n1s,
                    textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                )



                :



                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: itemmaplist.length,
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 50),
                  itemBuilder: (context, index){
                    var item = itemmaplist[index];
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
                                  flex: 3,
                                  child:


                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: (){
                                      navigateTo(context, widget, 
                                      EditPurchaseItemPage(
                                        outletid: widget.outletid, 
                                        itemmaplist: widget.itemmaplist,
                                        selectedIndex: index,
                                        ), 
                                        animationType : 'scrollRight');
                                    },
                                    child:

                                  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child:
                                                    SizedBox(
                                                      // height: sWidth * 0.50,
                                                      width: sHeight * 0.08,
                                                      height: sHeight * 0.08,
                                                      child:
                                                      (item['ProductImgPath'] != '')?
                                                        Image.network(item['ProductImgPath']!, fit: BoxFit.cover)
                                                      :
                                                      Center(
                                                        child:
                                                        Icon(
                                                          Icons.hide_image_outlined,
                                                          size: 30,
                                                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                                                          ),
                                                      )
                                                    ),
                                                )

                                              ],

                                            )



                                    ]
                                  ),
                                  ),
                                ),

                                Expanded(
                                  flex: 4,
                                  child:
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: (){
                                      navigateTo(context, widget, 
                                      EditPurchaseItemPage(
                                        outletid: widget.outletid, 
                                        itemmaplist: widget.itemmaplist,
                                        selectedIndex: index,
                                        ), 
                                        animationType : 'scrollRight');
                                    },
                                    child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [



                                      Padding(
                                        padding : EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child:
                                              createText(
                                                item['ProductName'],
                                                fontSize: n2s,
                                                fontWeight: h3w,
                                                textColor: Theme.of(context).colorScheme.onSecondary,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding : EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            createText(
                                              'Qty ${item['Quantity'].toString()}',
                                              fontSize: 12,
                                              fontWeight: h4w,
                                              textColor: Theme.of(context).colorScheme.onSecondary,
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding : EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            createText(
                                              'RM ${item['Price'].toStringAsFixed(2)}',
                                              fontSize: n3s,
                                              fontWeight: h4w,
                                              textColor: Theme.of(context).colorScheme.onSecondary,
                                            ),
                                          ],
                                        ),
                                      ),



                                    ]

                                  ),
                                  ),
                                ),

                                VerticalDivider(
                                  width: 0,
                                  thickness: 1,
                                  color: Colors.grey.withOpacity(0.3),
                                ),

                                Expanded(
                                  flex: 3,
                                  child:
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: (){
                                      navigateTo(context, widget, 
                                      EditPurchaseItemPage(
                                        outletid: widget.outletid, 
                                        itemmaplist: widget.itemmaplist,
                                        selectedIndex: index,
                                        ), 
                                        animationType : 'scrollRight');
                                    },
                                    child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [


                                      Padding(
                                        padding : EdgeInsets.fromLTRB(20, 5, 0, 0),
                                        child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          createText(
                                            'Total',
                                            fontSize: n3s,
                                            fontWeight: h4w,
                                            textColor: Theme.of(context).colorScheme.onSecondary,
                                          ),
                                        ],
                                      ),
                                      ),


                                      Padding(
                                        padding : EdgeInsets.fromLTRB(20, 5, 0, 0),
                                        child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child:
                                            createText(
                                              '${(item['TotalPrice']).toStringAsFixed(2)}',
                                              fontSize: n2s,
                                              fontWeight: h1w,
                                              textColor: Theme.of(context).colorScheme.onSecondary,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      ),



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
                )






                // ),
              ],
            ),
        ),
      ),


//floating add button 

      floatingActionButton: 
        FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          heroTag: null,
          child: const Icon(Icons.format_list_bulleted_add),
          onPressed: () {
            navigateTo(context, widget, AddPurchaseItemPage(outletid: widget.outletid, itemmaplist: itemmaplist), animationType: "scrollRight");
          },
        ),


      // bottom navigation bar
        bottomNavigationBar: 
        (itemmaplist.isEmpty)?
        SizedBox.shrink()
        :
        BottomAppBar(
              elevation: 3,
              color: Theme.of(context).colorScheme.secondary,
              child: Container(
                height: sHeight * 0.12,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

        ////////////////////////////////////////////////////////////////
        ///




                Container(
                  width: sWidth * 0.65,
                  child: 

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 50, 10),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child:
                              createText(
                                'Grand Total',
                                fontSize: sub4s,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: sub1w,
                                textColor: Theme.of(context).colorScheme.onSecondary,

                              ),

                            )
                          ],
                        ),


                      ),


                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 50, 0),
                        child:

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child:
                              createText(
                                'RM ${getGrandTotal()}',
                                fontSize: h4s,
                                fontWeight: h1w,
                                overflow: TextOverflow.ellipsis,
                                textColor: Theme.of(context).colorScheme.onSecondary,

                              ),

                            )
                          ],
                        ),


                      ),
                    ],
                  ),
                ),

        ////////////////////////////////////////////////////////////////
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
        // next button
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, (sWidth * 0), 0, (sWidth * 0.0)), // set top and bottom padding
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                                  createButton(
                                  text: "Order",
                                  fontSize: 18, 
                                  fontWeight: n2w,
                                  bgColor: Theme.of(context).colorScheme.primary, 
                                  textColor: Theme.of(context).colorScheme.onPrimary, 
                                  letterSpacing: l2Space, 
                                  px: 30,
                                  py: 15, 
                                  bradius: 15,
                                  onPressed: () => {
                                    orderConfirmWindow(context)
                                  },
                                  ),                               

                            ],
                          ),
                      ),


                    ],
                  ),

        ////////////////////////////////////////////////////////////////





                  ],
                ),
              ),
            ),


      

    );
  }
}