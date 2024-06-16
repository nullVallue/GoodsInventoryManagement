


// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/autocounter/acpurchaseitemmenu_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class ViewPurchaseDetailsPage extends StatefulWidget {
  final Map<String, dynamic> pmap;
  const ViewPurchaseDetailsPage({super.key, required this.pmap,});
  

  @override
  State<ViewPurchaseDetailsPage> createState() => _ViewPurchaseDetailsPageState();
}

class _ViewPurchaseDetailsPageState extends State<ViewPurchaseDetailsPage>{

  late Map<String, dynamic> pmap;

  List<Map<String, dynamic>> itemList = [];

  
  @override
  void initState(){
    super.initState();
    pmap = widget.pmap;
  }

  Future<void> loadItems() async {

    if(itemList.isEmpty){

      List<Map<String, dynamic>> tempitemlist = await DatabaseMethods.getCrespondingPurchaseItem(pmap['PurchaseID']);

      if(tempitemlist.isNotEmpty){


        for(int i = 0; i < tempitemlist.length; i++){

          Map<String, dynamic> productsuppliermap = await DatabaseMethods.getProductSupplierByIDAsMap(tempitemlist[i]['ProductSupplierID']); 


          Map<String, dynamic> productmap = await DatabaseMethods.getProductByIDAsMap(productsuppliermap['ProductID']); 

          Map<String, dynamic> suppliermap = await DatabaseMethods.getSupplierMapById(productsuppliermap['SupplierID']); 


          Map<String, dynamic> addmap = {
            'ProductName' : productmap['ProductName'],
            'ProductSupplierID' : tempitemlist[i]['ProductSupplierID'],
            'PurchaseID' : tempitemlist[i]['PurchaseID'],
            'PurchaseItemID' : tempitemlist[i]['PurchaseItemID'],
            'SupplierName' : suppliermap['SupplierName'],
            'Quantity' : tempitemlist[i]['Quantity'],
            'Counted' : tempitemlist[i]['Counted'],
            'TotalPrice' : (tempitemlist[i]['Quantity'] * productmap['Price']).toDouble(),
          };

          itemList.add(addmap);

        }

      }
    }
    


  }  



  @override
  Widget build(BuildContext build){
    return Scaffold(
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
            onPressed: (){
              navigateTo(context, widget, LandingPage(pageIndex: 5,), animationType: 'scrollLeft');
            }
          ),
        elevation: 0,
        title:
          Text(
            "Purchase Details",
            style: TextStyle(
              letterSpacing: 3,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body:

        FutureBuilder(
          future: loadItems(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              if(itemList.isEmpty){
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
                physics: const BouncingScrollPhysics(),
                child:
                Padding(
                  // padding: EdgeInsets.fromLTRB((sWidth * 0.1), 0, (sWidth * 0.1), 0),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Center(
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[





    // section 2
                        Container(
                          // height: (0.6*sHeight),                
                          child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:<Widget>[
                          


                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 0, 5), // set top and bottom padding
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createText(
                              'ID : ${pmap['PurchaseID']}',
                              fontSize: h4s,
                              fontWeight: h2w,
                              textColor: Theme.of(context).colorScheme.onBackground,
                              ),
                          ],
                        ),
                    ),



                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0), // set top and bottom padding
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createText(
                              'Outlet ID : ${pmap['OutletID']}',
                              fontSize: n2s,
                              fontWeight: sub4w,
                              textColor: Theme.of(context).colorScheme.onBackground,
                              ),
                          ],
                        ),
                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0), // set top and bottom padding
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createText(
                              'Status : ${pmap['Status']}',
                              fontSize: n2s,
                              fontWeight: sub4w,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ],
                        ),
                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0), // set top and bottom padding
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createText(
                              'Date : ${timestampToStr(pmap['PurchaseTimestamp'], 'dd MMMM yyyy, HH:mm')}',
                              fontSize: n2s,
                              fontWeight: sub4w,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ],
                        ),
                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 50), // set top and bottom padding
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createText(
                              'Total : RM ${pmap['TotalPrice'].toStringAsFixed(2)}',
                              fontSize: n2s,
                              fontWeight: n1w,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ],
                        ),
                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0), // set top and bottom padding
                      child: 
                      Container(
                        width: sWidth,
                        child:

                      DataTable(
                        showBottomBorder: true,
                        headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states){
                            return Theme.of(context).colorScheme.primary;
                            }
                          ),
                        columnSpacing: 1,
                        horizontalMargin: 10,
                        columns: [
                          DataColumn(
                            label: Container(
                              width: sWidth * 0.3,
                              child: 
                              createText(
                                'Product',
                                fontWeight: h1w,
                                fontSize: sub4s,
                                textColor: Theme.of(context).colorScheme.onPrimary,  
                              )
                              ,
                            )
                          ),


                          DataColumn(
                            label: Container(
                              width: sWidth * 0.3,
                              child: 
                              createText(
                                'Supplier',
                                fontWeight: h1w,
                                fontSize: sub4s,
                                textColor: Theme.of(context).colorScheme.onPrimary,  
                              )
                              ,
                            )
                          ),


                          DataColumn(
                            label: Container(
                              width: sWidth * 0.1,
                              child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  createText(
                                    'Qty',
                                    fontWeight: h1w,
                                    fontSize: sub4s,
                                    textColor: Theme.of(context).colorScheme.onPrimary,  
                                  )
                                ]
                              )
                              ,
                            )
                          ),


                          DataColumn(
                            label: Container(
                              width: sWidth * 0.2,
                              child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  createText(
                                    'Total (RM)',
                                    fontWeight: h1w,
                                    fontSize: sub4s,
                                    textColor: Theme.of(context).colorScheme.onPrimary,  
                                  )
                                ]
                                )
                              ,
                            )
                          ),

                        ],


                        rows: [
                        ...List.generate(
                          itemList.length,
                          (index) {
                          return
                          DataRow(
                            cells: [

                              DataCell(
                                onTap: (){
                                  if(itemList[index]['Counted']){
                                    null;
                                  }
                                  else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ACPurchaseItemMenuPage(purchaseItemMap: itemList[index], pmap: pmap)));
                                    // navigateTo(context, widget, ACPurchaseItemMenuPage(purchaseItemMap: itemList[index], pmap: pmap), animationType: 'scrollRight');
                                  }

                                },
                                Container(
                                  width: sWidth* 0.3,
                                  child:


                                      createText(
                                        itemList[index]['ProductName'],
                                        fontWeight: sub3w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        textColor: Theme.of(context).colorScheme.onBackground,
                                        overflow: TextOverflow.visible,
                                        textDecoration: (itemList[index]['Counted'])?TextDecoration.lineThrough:TextDecoration.none,
                                      )
                                )
                              ),


                              DataCell(
                                onTap: (){
                                  if(itemList[index]['Counted']){
                                    null;
                                  }
                                  else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ACPurchaseItemMenuPage(purchaseItemMap: itemList[index], pmap: pmap)));
                                    // navigateTo(context, widget, ACPurchaseItemMenuPage(purchaseItemMap: itemList[index], pmap: pmap), animationType: 'scrollRight');
                                  }

                                },
                                Container(
                                  width: sWidth* 0.3,
                                  child:


                                      createText(
                                        itemList[index]['SupplierName'],
                                        fontWeight: sub3w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        textColor: Theme.of(context).colorScheme.onBackground,
                                        overflow: TextOverflow.visible,
                                        textDecoration: (itemList[index]['Counted'])?TextDecoration.lineThrough:TextDecoration.none,
                                      )
                                )
                              ),


                              DataCell(
                                onTap: (){
                                  if(itemList[index]['Counted']){
                                    null;
                                  }
                                  else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ACPurchaseItemMenuPage(purchaseItemMap: itemList[index], pmap: pmap)));
                                    // navigateTo(context, widget, ACPurchaseItemMenuPage(purchaseItemMap: itemList[index], pmap: pmap), animationType: 'scrollRight');
                                  }

                                },
                                Container(
                                  width: sWidth* 0.1,
                                  child:

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      createText(
                                        itemList[index]['Quantity'].toString(),
                                        fontWeight: sub3w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        textColor: Theme.of(context).colorScheme.onBackground,
                                        overflow: TextOverflow.visible,
                                        textDecoration: (itemList[index]['Counted'])?TextDecoration.lineThrough:TextDecoration.none,
                                      )
                                    ]
                                  )
                                )
                              ),


                              DataCell(
                                onTap: (){
                                  if(itemList[index]['Counted']){
                                    null;
                                  }
                                  else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ACPurchaseItemMenuPage(purchaseItemMap: itemList[index], pmap: pmap)));
                                    // navigateTo(context, widget, ACPurchaseItemMenuPage(purchaseItemMap: itemList[index], pmap: pmap), animationType: 'scrollRight');
                                  }

                                },
                                Container(
                                  width: sWidth* 0.2,
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      createText(
                                        itemList[index]['TotalPrice'].toStringAsFixed(2),
                                        fontWeight: sub3w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        textColor: Theme.of(context).colorScheme.onBackground,
                                        overflow: TextOverflow.visible,
                                        textDecoration: (itemList[index]['Counted'])?TextDecoration.lineThrough:TextDecoration.none,
                                      )
                                    ],
                                  )

                                )
                              ),

                            ]
                          );

                          } 
                        ),


                          DataRow(
                            cells: [

                              DataCell(
                                Container(
                                  width: sWidth* 0.3,
                                  child:


                                      createText(
                                        '',
                                        fontWeight: sub3w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        overflow: TextOverflow.visible,
                                      )
                                )
                              ),


                              DataCell(
                                Container(
                                  width: sWidth* 0.3,
                                  child:


                                      createText(
                                        '',
                                        fontWeight: sub3w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        overflow: TextOverflow.visible,
                                      )
                                )
                              ),


                              DataCell(
                                Container(
                                  width: sWidth* 0.1,
                                  child:

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      createText(
                                        'Total',
                                        fontWeight: h1w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        textColor: Theme.of(context).colorScheme.onBackground,
                                        overflow: TextOverflow.visible,
                                      )
                                    ]
                                  )
                                )
                              ),


                              DataCell(
                                Container(
                                  width: sWidth* 0.2,
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      createText(
                                        pmap['TotalPrice'].toStringAsFixed(2),
                                        fontWeight: sub3w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        textColor: Theme.of(context).colorScheme.onBackground,
                                        overflow: TextOverflow.visible,
                                      )
                                    ],
                                  )

                                )
                              ),

                            ]
                          )


                        ]






                      ),
                      )
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
            );
            }


        ),

    );
  }
}