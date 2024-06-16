
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stockapp/page/authenticated/product/addproduct_pg.dart';
import 'package:stockapp/page/authenticated/product/editproductmenu_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/util/custom_widgets.dart';


// external packages
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {

  late Stream<QuerySnapshot> _productStream;
  TextEditingController searchController = TextEditingController();

  bool descending = false; 
  String currentStatusFilter = '';
  String currentSearchTerm = '';
  bool filterOn = false;
  bool sortOn = false;

  @override
  void initState(){
    super.initState();
    _productStream = DatabaseMethods.getProductSnapshot();
  }

  resetSortFilter(){
    setState(() {
      sortOn = false;
      filterOn = false;
      currentStatusFilter = '';
      _productStream = DatabaseMethods.getProductSnapshot();
    });
  }

  searchHandler(){


  // DatabaseMethods.test();

    if(!filterOn){
      setState(() {
        _productStream = DatabaseMethods.getProductSearchSnapshot(
        searchTerm: currentSearchTerm,
        descending: descending,
        );
      });
    }
    else{
      setState(() {
        _productStream = DatabaseMethods.getProductSearchSnapshot(
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


  sort(bool isDesc){
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

    List<String> filterList = [
      'Active', //0
      'Inactive', //1
    ];

    currentStatusFilter = filterList[type];

    searchHandler();
  }

  switchStatus(bool isActive, int pid){
    DatabaseMethods.updateProductStatus(isActive, pid);
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
            sort(false);
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
            sort(true);
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
                    stream: _productStream,
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Center(
                          child: Text("Failed to load product : ${snapshot.error}"),
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

                      List<QueryDocumentSnapshot> products = snapshot.data!.docs;

                      return
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: products.length,
                        padding: EdgeInsets.fromLTRB(0, 85, 0, 50),
                        itemBuilder: (context, index){
                          var product = products[index].data() as Map<String, dynamic>;
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child:
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 25, 0),
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
                                            navigateTo(context, widget, EditProductMenuPage(editProductID: product['ProductID'],));
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
                                                      (product['ProductImgPath'] != '')?
                                                        Image.network(product['ProductImgPath']!, fit: BoxFit.cover)
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
                                        flex: 5,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            navigateTo(context, widget, EditProductMenuPage(editProductID: product['ProductID'],));
                                          },
                                          child:
                                        Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Padding(
                                              padding : EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: 
                                                  createText(
                                                    product['ProductName'],
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
                                              padding : EdgeInsets.fromLTRB(10, 5, 0, 0),
                                              child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                createText(
                                                  'RM ${product['Price'].toStringAsFixed(2)}',
                                                  fontSize: n3s,
                                                  fontWeight: h4w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                ),
                                              ],
                                            ),
                                            ),


                                            Padding(
                                              padding : EdgeInsets.fromLTRB(10, 10, 0, 0),
                                              child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle_rounded,
                                                  size: 12,
                                                  color: getStatusColor(product['Status']),
                                                  ),
                                                createText(
                                                  product['Status'],
                                                  fontSize: n3s,
                                                  fontWeight: h4w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  ml: 10,
                                                ),
                                              ],
                                            ),
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      Expanded(
                                        flex: 2,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            navigateTo(context, widget, EditProductMenuPage(editProductID: product['ProductID'],));
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
                                            navigateTo(context, widget, EditProductMenuPage(editProductID: product['ProductID'],));
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
                                                  value: (product['Status'] == 'Active')?true:false,
                                                  onChanged: (value){
                                                    switchStatus(value, product['ProductID']);
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
                    hintText: "Search Product",
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
                navigateTo(context, widget, AddProductPage(), animationType: "scrollRight");
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