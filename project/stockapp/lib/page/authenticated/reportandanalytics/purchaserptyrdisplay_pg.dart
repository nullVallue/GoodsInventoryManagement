// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/autocounter/acpurchaseitemmenu_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';

class PurchaseReportYrDisplayPage extends StatefulWidget {
  final int outletid;
  final int year;
  const PurchaseReportYrDisplayPage({super.key, required this.outletid, required this.year});
  

  @override
  State<PurchaseReportYrDisplayPage> createState() => _PurchaseReportYrDisplayPageState();
}

class _PurchaseReportYrDisplayPageState extends State<PurchaseReportYrDisplayPage>{

  List<Map<String, dynamic>> itemList = [];

  double total = 0;
  Map<String, double> pieMap = {};

  
  @override
  void initState(){
    super.initState();
  }

  Future<void> loadItems() async {


    if(itemList.isEmpty){

      List<Map<String, dynamic>> stockMvmtMapList = await DatabaseMethods.getStockMvmtOfOutletPAsMapList(widget.outletid);

      if(stockMvmtMapList.isNotEmpty){


        for(int i = 0; i < stockMvmtMapList.length; i++){

          if(stockMvmtMapList[i]['MovementTimestamp'].toDate().year == widget.year){
            bool found = false;
            int foundIndex = 0;

            for(int j = 0; j < itemList.length; j++){
              if(itemList[j].containsValue(stockMvmtMapList[i]['ProductName'])){
                found = true;
                foundIndex = j;
              }
            }

            if(found){
              itemList[foundIndex]['Quantity'] += stockMvmtMapList[i]['Quantity'];
            }
            else{
              itemList.add(stockMvmtMapList[i]);
            }
          }

        }

      }

      if(itemList.isEmpty){
        Map<String, dynamic> addMap = {
          'ProductName' : 'No Results',
          'Quantity' : 0,
          'Price' : 0,
          'Total' : 0,
        };

        itemList.add(addMap);
        pieMap = {
          'No Results' : 0,
        };
      }
      else{
        // add product price for each 
        for(int i = 0; i < itemList.length; i++){
          Map<String, dynamic> product = await DatabaseMethods.getProductMapByName(itemList[i]['ProductName']);

          itemList[i]['Price'] = product['Price'];
          itemList[i]['Total'] = (itemList[i]['Price'] * itemList[i]['Quantity']).toDouble();

          total += itemList[i]['Total'];

        }

        for(int i =0; i < itemList.length; i++){
          pieMap[itemList[i]['ProductName']] = itemList[i]['Total'].toDouble();
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
              navigateTo(context, widget, LandingPage(pageIndex: 7,), animationType: 'scrollLeft');
            }
          ),
        elevation: 0,
        title:
          Text(
            "Purchase Report",
            style: TextStyle(
              letterSpacing: 2,
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
                              '${widget.year} Purchase Report',
                              fontSize: h4s,
                              fontWeight: h2w,
                              textColor: Theme.of(context).colorScheme.onBackground,
                              ),
                          ],
                        ),
                    ),





                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 10), // set top and bottom padding
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createText(
                              'Outlet ID : ${widget.outletid}',
                              fontSize: n2s,
                              fontWeight: sub4w,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ],
                        ),
                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 10), // set top and bottom padding
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createText(
                              'Total : RM ${total.toStringAsFixed(2)}',
                              fontSize: n2s,
                              fontWeight: sub4w,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ],
                        ),
                    ),




                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 10), // set top and bottom padding
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createText(
                              'Generated : ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                              fontSize: n2s,
                              fontWeight: sub4w,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                              mb: 20,
                            ),
                          ],
                        ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(0,0,0,20),
                      child:
                      Row(
                        children: [

                          PieChart(
                            chartRadius: 150,
                            chartLegendSpacing: 50,
                            dataMap: pieMap,
                            chartValuesOptions: ChartValuesOptions(
                              decimalPlaces: 0,
                              showChartValues: true,
                              showChartValueBackground: false,
                            ),
                            legendOptions: LegendOptions(
                              showLegendsInRow: false,
                              showLegends: true,
                              legendPosition: LegendPosition.right,
                            ),
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
                              width: sWidth * 0.1,
                              child: 
                              createText(
                                'Qty',
                                fontWeight: h1w,
                                fontSize: sub4s,
                                textColor: Theme.of(context).colorScheme.onPrimary,  
                              )
                              ,
                            )
                          ),


                          DataColumn(
                            label: Container(
                              width: sWidth * 0.25,
                              child: 
                              createText(
                                'Unti Price',
                                fontWeight: h1w,
                                fontSize: sub4s,
                                textColor: Theme.of(context).colorScheme.onPrimary,  
                              )
                              ,
                            )
                          ),



                          DataColumn(
                            label: Container(
                              width: sWidth * 0.25,
                              child: 
                              createText(
                                'Total',
                                fontWeight: h1w,
                                fontSize: sub4s,
                                textColor: Theme.of(context).colorScheme.onPrimary,  
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
                                      )
                                )
                              ),


                              DataCell(
                                Container(
                                  width: sWidth* 0.1,
                                  child:


                                      createText(
                                        itemList[index]['Quantity'].toString(),
                                        fontWeight: sub3w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        textColor: Theme.of(context).colorScheme.onBackground,
                                        overflow: TextOverflow.visible,
                                      )
                                )
                              ),



                              DataCell(
                                Container(
                                  width: sWidth* 0.25,
                                  child:


                                      createText(
                                        'RM ${itemList[index]['Price'].toStringAsFixed(2)}',
                                        fontWeight: sub3w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        textColor: Theme.of(context).colorScheme.onBackground,
                                        overflow: TextOverflow.visible,
                                      )
                                )
                              ),


                              DataCell(
                                Container(
                                  width: sWidth* 0.25,
                                  child:

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      createText(
                                        'RM ${itemList[index]['Total'].toStringAsFixed(2)}',
                                        fontWeight: sub3w,
                                        softWrap: true,
                                        fontSize: sub4s,
                                        textColor: Theme.of(context).colorScheme.onBackground,
                                        overflow: TextOverflow.visible,
                                      )
                                    ]
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
                                  width: sWidth* 0.1,
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
                                  width: sWidth* 0.25,
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
                                  width: sWidth* 0.25,
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      createText(
                                        'RM ${total.toStringAsFixed(2)}',
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