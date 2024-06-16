// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stockapp/page/authenticated/outlet/addoutlet_pg.dart';
import 'package:stockapp/page/authenticated/outlet/editoutletmenu_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/util/custom_widgets.dart';

// external packages
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class OutletManagementPage extends StatefulWidget {
  const OutletManagementPage({super.key});

  @override
  State<OutletManagementPage> createState() => _OutletManagementPageState();
}

class _OutletManagementPageState extends State<OutletManagementPage> {

  late Stream<QuerySnapshot> _outletStream;
  TextEditingController searchController = TextEditingController();

  bool descending = false; 
  String currentStatusFilter = '';
  String currentStateFilter= '';
  String currentSearchTerm = '';
  bool filterOn = false;
  bool sortOn = false;

  @override
  void initState(){
    super.initState();
    _outletStream = DatabaseMethods.getOutletSnapshot();
  }

  resetSortFilter(){
    setState(() {
      sortOn = false;
      filterOn = false;
      currentStatusFilter = '';
      currentStateFilter = '';
      _outletStream = DatabaseMethods.getOutletSnapshot();
    });
  }

  searchHandler(){
    if(!filterOn){
      setState(() {
        _outletStream = DatabaseMethods.getOutletSearchSnapshot(
        searchTerm: currentSearchTerm,
        stateFilter: (currentStateFilter=='')?null:currentStateFilter,
        descending: descending,
        );
      });
    }
    else{
      setState(() {
        _outletStream = DatabaseMethods.getOutletSearchSnapshot(
        searchTerm: currentSearchTerm,
        statusFilter: currentStatusFilter,
        stateFilter: (currentStateFilter=='')?null:currentStateFilter,
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
    // 0 active
    // 1 inactive 
    // 2 Kedah 
    // 3 Kelantan
    // 4 Sabah
    // 5 Pahang
    // 6 Sarawakk 
    // 7 Perak
    // 8 Selangor 
    // 9 N. Sembilan 
    // 10 Terrenganu 
    // 12 Johor
    // 12 P. Pinang
    // 13 Perlis 
    // 14 Melaka
    // 15 W.P.Kuala Lumpur 

    List<String> filterList = [
      'Active', //0
      'Inactive', //1
      'Kedah', //2
      'Kelantan', //3
      'Sabah',//4
      'Pahang',//5
      'Sarawak',//6
      'Perak',//7
      'Selangor',//8
      'N. Sembilan',//9
      'Terrenganu',//10
      'Johor',//11
      'P. Pinang',//12
      'Perlis',//13
      'Melaka',//14
      'W.P.Kuala Lumpur',//15
      ];

    if(type < 2){
      currentStatusFilter = filterList[type];   
      currentStateFilter = '';
    }
    else if(type < 16){
      currentStateFilter = filterList[type];
      currentStatusFilter = '';   
    }
    else{
      currentStateFilter = '';
      currentStatusFilter = '';   
    }

    searchHandler();
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

  switchStatus(bool isActive, int oid) async {
    if(isActive){
      if(!await DatabaseMethods.checkHasStaff(oid)){
        switchFail(context);
        return;
      }
    }
    DatabaseMethods.updateOutletStatus(isActive, oid);
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
            showSnackBar(context, "Sort ascending");
          },
          child: ListTile(
            title: 
            createText(
              'Ascending',
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
            showSnackBar(context, "Sort descending");
          },
          child: ListTile(
            title: 
            createText(
              'Descending',
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
            showSnackBar(context, "Filter Active");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Active',
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
            showSnackBar(context, "Filter Inactive");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Inactive',
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
            showSnackBar(context, "Filter Kedah Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Kedah',
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
            showSnackBar(context, "Filter Kelantan Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Kelantan',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),



        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(4);
            showSnackBar(context, "Filter Sabah Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Sabah',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),



        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(5);
            showSnackBar(context, "Filter Pahang Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Pahang',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),



        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(6);
            showSnackBar(context, "Filter Sarawak Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Sarawak',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),


        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(7);
            showSnackBar(context, "Filter Perak Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Perak',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),



        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(8);
            showSnackBar(context, "Filter Selangor Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Selangor',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),


        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(9);
            showSnackBar(context, "Filter N. Sembilan Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter N. Sembilan',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),


        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(10);
            showSnackBar(context, "Filter Terrenganu Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Terrenganu',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),


        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(11);
            showSnackBar(context, "Filter Johor Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Johor',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),



        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(12);
            showSnackBar(context, "Filter P. Pinang Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter P. Pinang',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),



        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(13);
            showSnackBar(context, "Filter Perlis Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Perlis',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),


        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(14);
            showSnackBar(context, "Filter Melaka Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Melaka',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),


        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filter(15);
            showSnackBar(context, "Filter W.P.Kuala Lumpur Outlets");
          },
          child: ListTile(
            title: 
            createText(
              'Filter W.P.Kuala Lumpur',
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
                    stream: _outletStream,
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Center(
                          child: Text("Failed to load outlets : ${snapshot.error}"),
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

                      List<QueryDocumentSnapshot> outlets = snapshot.data!.docs;

                      return
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: outlets.length,
                        padding: EdgeInsets.fromLTRB(0, 85, 0, 50),
                        itemBuilder: (context, index){
                          var outlet = outlets[index].data() as Map<String, dynamic>;
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
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
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
                                                  outlet['OutletName'],
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
                                                  outlet['City'],
                                                  fontSize: n3s,
                                                  fontWeight: FontWeight.w300,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                  mt: 5,
                                                  mb: 10,
                                                ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle_rounded,
                                                  size: 12,
                                                  color: getStatusColor(outlet['Status']),
                                                  ),
                                                Expanded(
                                                  child:
                                                createText(
                                                  outlet['Status'],
                                                  fontSize: n3s,
                                                  fontWeight: h4w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                  ml: 10,
                                                ),
                                                ),
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
                                            navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
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
                                                    Icons.arrow_forward_ios_rounded,
                                                    size: 25,
                                                    ),

                                                  color: Colors.grey.withOpacity(0.7),
                                                  // color: Theme.of(context).colorScheme.onSecondary,
                                                  onPressed: (){
                                                    // null;
                                            navigateTo(context, widget, EditOutletMenuPage(editOutletID: outlet['OutletID'],));
                                                  },
                                                ),
                                              ],
                                            )
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
                                                  value: (outlet['Status'] == 'Active')?true:false,
                                                  onChanged: (value){
                                                    switchStatus(value, outlet['OutletID']);
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
                          );
                        }
                        );


                    }

                  ),
                // ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background.withAlpha(0)],
                      stops: [0.92, 1]
                    ),
                  ),
                  child:
                  createTextField(
                    textColor: Theme.of(context).colorScheme.onBackground,
                    hintText: "Search Outlet",
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
                navigateTo(context, widget, AddOutletPage(), animationType: "scrollRight");
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
            // PopupMenuButton(
            //   icon: Icon(Icons.filter_alt_rounded, color: Theme.of(context).colorScheme.onSecondary),
            //   color: Theme.of(context).colorScheme.secondary,
            //   itemBuilder: (context) => <PopupMenuEntry>[
            //     PopupMenuItem(
            //       value: 'test',
            //       child: Text('test'),
            //     )
            //   ]
            // )
          ],
        ),
      )
      


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