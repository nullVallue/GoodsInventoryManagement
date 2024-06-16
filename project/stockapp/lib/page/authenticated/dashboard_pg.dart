// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/autocounter/acpurchaseitemmenu_pg.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/util/custom_widgets.dart';
import 'package:pie_chart/pie_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key,});
  

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>{


  Map<String, double> invPieMap = {};

  double currentSpending = -1;
  double currentLoss = -1;
  int requestno = 0;
  
  @override
  void initState(){
    super.initState();
  }

  Future<void> loadItems() async {

    // load user permissions

    print(userPermissions['ManageUser']);

    // load inventory pie //////////////////////////////

    if(invPieMap.isEmpty){

      List<Map<String, dynamic>> invList = await DatabaseMethods.getOutletInvAsMapList(sessionUser['OutletID']);

      invList.sort((a, b) => b['Quantity'].compareTo(a['Quantity']));


      Map<String, double> tempInvPieMap = {};
      int limit = 4;
      for(int i = 0; i < invList.length; i++){
        if(i > limit){
          break;
        }
        else{
          tempInvPieMap[invList[i]['ProductName']] = invList[i]['Quantity'].toDouble();
        }
      }

      invPieMap = tempInvPieMap;

    }
    // //////////////////////////////////////////////////////////////////////////////////////////

    // load total spending //////////////////////////////
    if(currentSpending == -1){

      List<Map<String, dynamic>> stockMvmtMapList = await DatabaseMethods.getStockMvmtOfOutletPAsMapList(sessionUser['OutletID']);

      List<Map<String, dynamic>> itemList = [];

      if(stockMvmtMapList.isNotEmpty){

        for(int i = 0; i < stockMvmtMapList.length; i++){

          if(stockMvmtMapList[i]['MovementTimestamp'].toDate().month == DateTime.now().month){
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
          'Quantity' : 'No Results',
        };

        itemList.add(addMap);
      }
      else{
        currentSpending = 0;
        // add product price for each 
        for(int i = 0; i < itemList.length; i++){
          Map<String, dynamic> product = await DatabaseMethods.getProductMapByName(itemList[i]['ProductName']);

          itemList[i]['Price'] = product['Price'];
          itemList[i]['Total'] = (itemList[i]['Price'] * itemList[i]['Quantity']).toDouble();

          currentSpending += itemList[i]['Total'];

        }
      }
    }

    // //////////////////////////////////////////////////////////////////////////////////////////


    // load total loss //////////////////////////////
    if(currentLoss == -1){


      List<Map<String, dynamic>> itemList = [];

      List<Map<String, dynamic>> lossList = await DatabaseMethods.getLossOfOutletAsListMap(sessionUser['OutletID']);

      if(lossList.isNotEmpty){


        for(int i = 0; i < lossList.length; i++){

          if(lossList[i]['LossTimestamp'].toDate().month == DateTime.now().month){
            bool found = false;
            int foundIndex = 0;

            for(int j = 0; j < itemList.length; j++){
              if(itemList[j].containsValue(lossList[i]['ProductName'])){
                found = true;
                foundIndex = j;
              }
            }

            if(found){
              itemList[foundIndex]['LossQty'] += lossList[i]['LossQty'];
            }
            else{
              itemList.add(lossList[i]);
            }
          }

        }

      }

      if(itemList.isEmpty){
        Map<String, dynamic> addMap = {
          'ProductName' : 'No Results',
          'LossQty' : 'No Results',
        };

        itemList.add(addMap);
      }
      else{
        // add product price for each 
        for(int i = 0; i < itemList.length; i++){
          Map<String, dynamic> product = await DatabaseMethods.getProductMapByName(itemList[i]['ProductName']);

          itemList[i]['Price'] = product['Price'];
          itemList[i]['Total'] = (itemList[i]['Price'] * itemList[i]['LossQty']).toDouble();

          currentLoss += itemList[i]['Total'];

        }
      }


    }


    // //////////////////////////////////////////////////////////////////////////////////////////

    // /load no of rquest/////////////////////////////////////////////////////////////////////

    requestno = await DatabaseMethods.getNumberOfRequests(sessionUser['OutletID']);


  }  



  @override
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:

        FutureBuilder(
          future: loadItems(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: 
                  LoadingAnimationWidget.stretchedDots(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  ),
              );
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
                      padding: EdgeInsets.fromLTRB(20, 30, 0, 5), // set top and bottom padding
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createText(
                              '${DateFormat('EEEE').format(DateTime.now())}',
                              fontSize: h3s,
                              fontWeight: h2w,
                              letterSpacing: 1,
                              textColor: Theme.of(context).colorScheme.onBackground,
                              ),
                          ],
                        ),
                    ),





                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 30), // set top and bottom padding
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createText(
                              '${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                              fontSize: h3s,
                              fontWeight: FontWeight.w300,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ],
                        ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10), // set top and bottom padding
                      child:

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Column(
                            children: [

                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 1,
                                color: Theme.of(context).colorScheme.secondary,
                                child:
                                Container(
                                  width: (sWidth * 0.45),
                                  height: (sWidth * 0.45),
                                  child: 
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                                    child: 
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            createText(
                                              'RM',
                                              textColor: Theme.of(context).colorScheme.onBackground,
                                              fontSize: 40,
                                              fontWeight: h1w,
                                              letterSpacing: 2,
                                              mb: 10,
                                            )

                                          ],
                                        ),


                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            createText(
                                              (currentSpending < 0)?'0.00':currentSpending.toStringAsFixed(2),
                                              textColor: Theme.of(context).colorScheme.onBackground,
                                              fontSize: h3s,
                                            )

                                          ],
                                        ),


                                      ],
                                    ),
                                  )
                                )
                              ),

                              createText(
                                'Current Expense',
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                fontSize: n3s,
                                mt: 5,
                              ),

                            ],
                          ),

                          Column(

                            children: [

                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 1,
                                color: Theme.of(context).colorScheme.secondary,
                                child:
                                Container(
                                  width: (sWidth * 0.45),
                                  height: (sWidth * 0.45),
                                  child: 
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                                    child: 
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            createText(
                                              'Requests',
                                              textColor: Theme.of(context).colorScheme.onBackground,
                                              fontSize: h3s,
                                              fontWeight: h1w,
                                              letterSpacing: 2,
                                              mb: 10,
                                            )

                                          ],
                                        ),


                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            createText(
                                              requestno.toString(),
                                              textColor: Theme.of(context).colorScheme.onBackground,
                                              fontSize: 60,
                                              fontWeight: h1w,
                                              mt: 12,
                                            )

                                          ],
                                        ),

                                      ],
                                    ),
                                  )
                                )
                              ),


                              createText(
                                'Requests',
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                fontSize: n3s,
                                mt: 5,
                              ),

                            ],
                          ),

                        ],
                      )






                    ),



                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10), // set top and bottom padding
                      child:

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Column(
                            children: [

                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 1,
                                color: Theme.of(context).colorScheme.secondary,
                                child:
                                Container(
                                  width: (sWidth * 0.925),
                                  height: (sWidth * 0.45),
                                  child: 
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                    child: 
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        PieChart(
                                          chartRadius: 150,
                                          chartLegendSpacing: 50,
                                          dataMap: invPieMap,
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
                                        Row(
                                          children: [

                                          ],

                                        ),
                                      ],
                                    ),
                                  )
                                )
                              ),

                              createText(
                                'Top Inventory Stocks',
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                fontSize: n3s,
                                mt: 5,
                              ),

                            ],
                          ),


                        ],
                      )






                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10), // set top and bottom padding
                      child:

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Column(
                            children: [

                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 1,
                                color: Theme.of(context).colorScheme.secondary,
                                child:
                                Container(
                                  width: (sWidth * 0.45),
                                  height: (sWidth * 0.45),
                                  child: 
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                                    child: 
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            createText(
                                              'RM',
                                              textColor: Theme.of(context).colorScheme.onBackground,
                                              fontSize: 40,
                                              fontWeight: h1w,
                                              letterSpacing: 2,
                                              mb: 10,
                                            )

                                          ],
                                        ),


                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            createText(
                                              (currentLoss< 0)?'0.00':'-${currentLoss.toStringAsFixed(2)}',
                                              textColor: Theme.of(context).colorScheme.error,
                                              fontSize: h3s,
                                            )

                                          ],
                                        ),


                                      ],
                                    ),
                                  )
                                )
                              ),

                              createText(
                                'Current Loss',
                                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                fontSize: n3s,
                                mt: 5,
                              ),

                            ],
                          ),


                        ],
                      )






                    ),

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