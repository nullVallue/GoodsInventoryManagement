// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stockapp/page/authenticated/inventory/addinv_pg.dart';
import 'package:stockapp/page/authenticated/inventory/editinv_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/util/custom_widgets.dart';

// external packages
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class InvManagementPage extends StatefulWidget {
  const InvManagementPage({super.key});

  @override
  State<InvManagementPage> createState() => _InvManagementPageState();
}

class _InvManagementPageState extends State<InvManagementPage> {

  late Stream<QuerySnapshot> _invStream;
  TextEditingController searchController = TextEditingController();

  bool descending = false; 
  String currentStatusFilter = '';
  String currentStateFilter= '';
  String currentSearchTerm = '';
  bool filterOn = false;
  bool sortOn = false;

  late int currentOutletId;

  List<String> outletList = [];
  String? _dropdownValue;

  String currentOutletName = '';

  @override
  void initState(){
    super.initState();
    _invStream = DatabaseMethods.getInvSnapshot();
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

  addQty(Map<String, dynamic> invMap, bool isAdd){

    int qty = invMap['Quantity'];

    if(isAdd){
      qty++;
      invMap['Quantity'] = qty;
    }
    else{
      if(invMap['Quantity'] == 0){
        return;
      }
      else{
        qty--;
        invMap['Quantity'] = qty;
      }
    }

    DatabaseMethods.updateInvDetails(invMap);

  }

  resetSortFilter(){
    setState(() {
      sortOn = false;
      filterOn = false;
      currentStatusFilter = '';
      currentStateFilter = '';
      _invStream = DatabaseMethods.getInvSnapshot();
    });
  }

  searchHandler(){

    // DatabaseMethods.test();

    if(!filterOn){
      setState(() {
        _invStream = DatabaseMethods.getInvSearchSnapshot(
        searchTerm: currentSearchTerm,
        descending: descending,
        );
      });
    }
    else{
      setState(() {
        _invStream = DatabaseMethods.getInvSearchSnapshot(
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
    // 0 active
    // 1 inactive 
    // 2 Kedah 

    List<String> filterList = [
      'Unhidden', //0
      'Hidden', //1
      'All', //2
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
            showSnackBar(context, "Sort Quantity Ascending");
          },
          child: ListTile(
            title: 
            createText(
              'Sorting Quantity in Ascending',
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
            showSnackBar(context, "Sort Quantity Descending");
          },
          child: ListTile(
            title: 
            createText(
              'Sorting Quantity in Descending',
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
            showSnackBar(context, "Show Unhidden");
          },
          child: ListTile(
            title: 
            createText(
              'Showing Unhidden (Default)',
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
            showSnackBar(context, "Show Hidden");
          },
          child: ListTile(
            title: 
            createText(
              'Showing Hidden',
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
            showSnackBar(context, "Show All");
          },
          child: ListTile(
            title: 
            createText(
              'Show All',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),


        
      ]
    );
  }

  void hideAllZero(int outletid) async{
    await DatabaseMethods.hideAllZero(outletid);
    setState(() {
      
      _invStream = DatabaseMethods.getInvSnapshot();
    });
  }


  hideAllDialog(BuildContext oriContext, int outletid){


    showAlertDialog(
      title: "Hide Unused Products?",
      message: "Do you want to set all products with quantity of 0 to hidden?",
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
        hideAllZero(outletid),
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
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: 
            Stack(
              children: [
                // Expanded(
                //   child: 
                    StreamBuilder<QuerySnapshot>(
                    stream: _invStream,
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Center(
                          child: Text("Failed to load inventory record : ${snapshot.error}"),
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

                      List<QueryDocumentSnapshot> invs = snapshot.data!.docs;



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
                        itemCount: invs.length,
                        padding: EdgeInsets.fromLTRB(0, 125, 0, 50),
                        itemBuilder: (context, index){
                          var inv = invs[index].data() as Map<String, dynamic>;
                          // if(inv['OutletID'] != sessionUser['OutletID'] && sessionUser['Role'] == 'Staff'){
                          if(inv['OutletID'] != currentOutletId){
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
                                        flex: 6,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            navigateTo(context, widget, EditInvPage(editInvMap: inv,));
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
                                                  inv['ProductName'],
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
                                                  'Qty ${inv['Quantity']}',
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
                                                Expanded(
                                                  child:
                                                createText(
                                                  'Tallied : ${timestampToStr(inv['LastTallied'], 'dd/MM/yyyy')}',
                                                  fontSize: n3s,
                                                  fontWeight: h4w,
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


                                      Expanded(
                                        flex: 3,
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
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:  
                                              [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.arrow_forward_ios_rounded,
                                                    size: 25,
                                                    ),

                                                  color: Colors.grey.withOpacity(0.7),
                                                  onPressed: (){
                                            navigateTo(context, widget, EditInvPage(editInvMap: inv,));
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
                                                IconButton(
                                                  icon: Icon(Icons.add_rounded),
                                                  onPressed: (){
                                                    addQty(inv, true);
                                                  },
                                                  iconSize: 20,
                                                ),


                                              ],
                                            ),



                                          Divider(
                                            height: 0,
                                            thickness: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                          ),


                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.remove_rounded),
                                                  onPressed: (){
                                                    addQty(inv, false);
                                                  },
                                                  iconSize: 20,
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
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background.withAlpha(0)],
                  //     stops: [0.92, 1]
                  //   ),
                  // ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
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
                navigateTo(context, widget, AddInventoryPage(outletid: currentOutletId), animationType: "scrollRight");
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



            FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              heroTag: null,
              child: const Icon(Icons.visibility_off_rounded),
              onPressed: () {
                hideAllDialog(context, currentOutletId);
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