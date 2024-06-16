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

class StockMvmtManagementPage extends StatefulWidget {
  const StockMvmtManagementPage({super.key});

  @override
  State<StockMvmtManagementPage> createState() => _StockMvmtManagementPageState();
}

class _StockMvmtManagementPageState extends State<StockMvmtManagementPage> {

  late Stream<QuerySnapshot> _stockStream;
  TextEditingController searchController = TextEditingController();

  bool descending = true; 
  String currentStatusFilter = '';
  String currentSearchTerm = '';
  bool filterOn = false;
  bool sortOn = false;

  late int currentOutletId;

  String currentOutletName = '';

  List<String> outletList = [];
  String? _dropdownValue;

  @override
  void initState(){
    super.initState();
    _stockStream = DatabaseMethods.getStockMvmtSnapshot();
    currentOutletId = sessionUser['OutletID'];
    _dropdownValue = sessionUser['OutletID'].toString();
  }


  Future<void> loadOutletName() async {
    currentOutletName = await DatabaseMethods.getOutletNameById(currentOutletId);
  }

  Future<void> loadOutletList() async {

    loadOutletName();

    List<String> temp = await DatabaseMethods.getAllOutletAsList();
    if(temp.isEmpty){
      temp.add('Empty');
    }

    if(mounted){
      setState(() {
        outletList = temp;
      });
    }

  }

  resetSortFilter(){
    setState(() {
      sortOn = false;
      filterOn = false;
      currentStatusFilter = '';
      _stockStream = DatabaseMethods.getStockMvmtSnapshot();
    });
  }

  searchHandler(){

    // DatabaseMethods.test();

    if(!filterOn){
      setState(() {
        _stockStream = DatabaseMethods.getMvmtSearchSnapshot(
        searchTerm: currentSearchTerm,
        descending: descending,
        );
      });
    }
    else{
      setState(() {
        _stockStream = DatabaseMethods.getMvmtSearchSnapshot(
        searchTerm: currentSearchTerm,
        statusFilter: currentStatusFilter,
        descending: descending,
        );
      });
    }


  }


  searchText(String searchTerm){
    setState(() {
      currentSearchTerm = searchTerm;
    });
    searchHandler();
  }


  sortUser(bool isDesc){
    // 1 = ascending 
    // 2 = descending 
    setState((){
      descending = isDesc;
    });
    searchHandler();
  }

  filter(int type){
    // 0 Purchase 
    // 1 Outlet 
    // 2 Stock In 
    // 3 Stock Out 

    List<String> filterList = [
      'Purchase', //0
      'Outlet', //1
      'Stock In', //2
      'Stock Out', //3
      ];

    currentStatusFilter = filterList[type];   

    searchHandler();
  }


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

  // sort pop up list
  showSortPopupMenu(BuildContext context) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(10, 280), ancestor: overlay) ,
        button.localToGlobal(button.size.bottomRight(Offset(10, 0)), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );    

    await showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      position: position,
      color: Theme.of(context).colorScheme.secondary,
      elevation: 1,
      items: <PopupMenuEntry>[

        PopupMenuItem(
          onTap: (){
            setState((){
              sortOn = true;
            });
            sortUser(false);
            showSnackBar(context, "Sort By Date Earliest To Latest");
          },
          child: ListTile(
            title: 
            createText(
              'Sort Date : Earliest to Latest',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          )
        ),


        PopupMenuItem(
          onTap: (){
            setState((){
              sortOn = true;
            });
            sortUser(true);
            showSnackBar(context, "Sort By Date Latest To Earliest");
          },
          child: ListTile(
            title: 
            createText(
              'Sort Date : Latest to Earliest',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),



      ]
    );
  }

  // filter pop up list
  showFilterPopupMenu(BuildContext context) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(10, 200), ancestor: overlay) ,
        button.localToGlobal(button.size.bottomRight(Offset(10, 0)), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );    

    await showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      position: position,
      color: Theme.of(context).colorScheme.secondary,
      elevation: 1,
      items: <PopupMenuEntry>[
        
        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(0);
            showSnackBar(context, "Showing Purchase Movement");
          },
          child: ListTile(
            title: 
            createText(
              'Show Purchase Movements',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          )
        ),
        
        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(1);
            showSnackBar(context, "Showing Outlet Movement");
          },
          child: ListTile(
            title: 
            createText(
              'Show Outlet Movement',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),

        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(2);
            showSnackBar(context, "Showing Stock Ins");
          },
          child: ListTile(
            title: 
            createText(
              'Show Stock In',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),


        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(3);
            showSnackBar(context, "Showing Stock Outs");
          },
          child: ListTile(
            title: 
            createText(
              'Show Stock Out',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),


        
      ]
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
                    stream: _stockStream,
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Center(
                          child: Text("Failed to load movement records : ${snapshot.error}"),
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


                      List<QueryDocumentSnapshot> stocks = snapshot.data!.docs;



                      return
                      FutureBuilder(
                        future: loadOutletList(),
                        builder: (context, fsnapshot){
                        if (fsnapshot.connectionState == ConnectionState.waiting) {
                          if(outletList.isEmpty){
                            return Center(
                              child: 
                              LoadingAnimationWidget.stretchedDots(
                                color: Theme.of(context).colorScheme.primary,
                                size: 50,
                              ),
                            );
                          }
                        } else if (fsnapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        }




                      return
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: stocks.length,
                        padding: EdgeInsets.fromLTRB(0, 125, 0, 50),
                        itemBuilder: (context, index){
                          var stock = stocks[index].data() as Map<String, dynamic>;
                          if(stock['OutletID'] != currentOutletId){
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
                                                  '${stock['ProductName']} x ${stock['Quantity']}',
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
                                                  '${timestampToStr(stock['MovementTimestamp'], 'dd/MM/yyyy, HH:mm')}',
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
                                                  '${(stock['isIn'])?'Stock In':'Stock Out'} (${stock['Type']})',
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
                                            //     IconButton(
                                            //       icon: Icon(
                                            //         Icons.arrow_forward_ios_rounded,
                                            //         size: 25,
                                            //         ),

                                            //       color: Colors.grey.withOpacity(0.7),
                                            //       onPressed: (){
                                            // // navigateTo(context, widget, ViewPurchaseDetailsPage(pmap: purchase), animationType: 'scrollRight');
                                            //       },
                                            //     ),
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


                Padding(
                  padding: EdgeInsets.fromLTRB(0, 92, 0, 0),
                  child:


                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background.withAlpha(0)],
                        stops: [0.92, 1]
                      ),
                    ),
                    height: 35,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[

                        createText(
                          currentOutletName,
                          textColor: Theme.of(context).colorScheme.onTertiaryContainer
                        ),


                      ]

                    ),
                  ),


                ),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background.withAlpha(0)],
                  //     stops: [0.92, 1]
                  //   ),
                  // ),
                  child:
                  Row(
                    
                    children:[

                    Expanded(
                      flex: (!userPermissions['ViewOtherOutlets'])?10:7,
                      // flex: 7,
                      child:
                      createTextField(
                        textColor: Theme.of(context).colorScheme.onBackground,
                        hintText: "Search Record",
                        bradius: 20,
                        mt: 15,
                        mb: 15,
                        mr: 15,
                        ml: 15,
                        controller: searchController,
                        inputAction: TextInputAction.search,
                        onChanged: (value){
                          searchText(value.toLowerCase());
                        },
                      ),
                    ),

                    (!userPermissions['ViewOtherOutlets'])?
                    SizedBox.shrink() 
                    :
                    Expanded(
                      flex: 3,
                      child:
                      createFormDropdownMenu(
                      hintText: "Outlet",
                      labelText: "Outlet",
                      bradius: 15,
                      mt: 15,
                      mb: 15,
                      mr: 15,
                      fontSize: 16,
                      fontWeight: n2w,
                      textColor: Theme.of(context).colorScheme.onBackground,
                      dropdownValue: _dropdownValue.toString(),
                      dropdownItems: outletList,
                      onChanged: (value){
                        setState((){
                          _dropdownValue = value;
                          currentOutletId = int.parse(value??'0');
                        });
                      },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please select a staff";
                        }
                        else if(value == 'No Staff Available'){
                          return "No Staff Available";
                        }
                        return null;
                      }
                      ),
                    ),
                      

                    ]

                  ),
                ),






              ],
            ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: 
      Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: 
        ExpandableFab(
          type: ExpandableFabType.up,
          duration: Duration(milliseconds: 200),
          distance: 80,
          overlayStyle: ExpandableFabOverlayStyle(
            blur: 10,
          ),
          childrenOffset: Offset(0, 0),

          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.menu_rounded),
            fabSize: ExpandableFabSize.regular,
            foregroundColor: Theme.of(context).colorScheme.tertiary,
            backgroundColor: Theme.of(context).colorScheme.onTertiary,
            shape: const CircleBorder(),
          ),

          closeButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.close_rounded),
            fabSize: ExpandableFabSize.regular,
            foregroundColor: Theme.of(context).colorScheme.onTertiary,
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            shape: const CircleBorder(),
          ),
          children: [


            FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              heroTag: null,
              child: const Icon(Icons.add_rounded),
              onPressed: () {
                // navigateTo(context, widget, AddPurchaseListPage(outletid: currentOutletId,itemmaplist: []), animationType: "scrollRight");
              },
            ),


            FloatingActionButton(
              backgroundColor: sortOn?Theme.of(context).colorScheme.primary:Theme.of(context).colorScheme.secondary,
              foregroundColor: sortOn?Theme.of(context).colorScheme.onPrimary:Theme.of(context).colorScheme.onSecondary,
              heroTag: null,
              child: const Icon(Icons.sort_rounded),
              onPressed: () {
                showSortPopupMenu(context);
              },
            ),




            FloatingActionButton(
              backgroundColor: filterOn?Theme.of(context).colorScheme.primary:Theme.of(context).colorScheme.secondary,
              foregroundColor: filterOn?Theme.of(context).colorScheme.onPrimary:Theme.of(context).colorScheme.onSecondary,
              heroTag: null,
              child: const Icon(Icons.filter_alt_rounded),
              onPressed: () {
                showFilterPopupMenu(context);
              },
            ),



            (sortOn || filterOn)?FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              foregroundColor: Theme.of(context).colorScheme.onTertiary,
              heroTag: null,
              child: const Icon(Icons.filter_alt_off_rounded),
              onPressed: () {
                resetSortFilter();
              },
            ):Container(),



          ],
        ),
      )

    );
  }
}