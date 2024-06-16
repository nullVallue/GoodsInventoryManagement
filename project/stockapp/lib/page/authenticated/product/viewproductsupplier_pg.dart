// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stockapp/page/authenticated/product/editaddsupplier_pg.dart';
import 'package:stockapp/page/authenticated/product/editproductmenu_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/util/custom_widgets.dart';

// external packages
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class ViewProductSupplierPage extends StatefulWidget {
  final Map<String, dynamic> productMap;
  const ViewProductSupplierPage({super.key, required this.productMap});

  @override
  State<ViewProductSupplierPage> createState() => _ViewProductSupplierPageState();
}

class _ViewProductSupplierPageState extends State<ViewProductSupplierPage> {

  late Stream<QuerySnapshot> _currentSupplierStream;

  int supplierCount = 0;

  @override
  void initState(){
    super.initState();
    _currentSupplierStream = DatabaseMethods.getSupplierSnapshot();
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

  Future<bool> isProductSupplier(int supplierId) async {
    return await DatabaseMethods.checkIsProductSupplier(widget.productMap['ProductID'], supplierId);
  }


  removeFail(BuildContext oriContext){
    
    showAlertDialog(
      title: "Remove failed",
      message: 'Must have at least 1 supplier for each product',
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
      btnBradius: 15,
      btnOnPressed: () => {
        Navigator.of(context).pop(),

      },
      // btnOnPressed: () => navigateTo(context, widget, SignUpPage(), animationType: "ScrollLeft"),
      btnBgColor: Theme.of(context).colorScheme.error,
      btnTextColor: Theme.of(context).colorScheme.onError,
      );

      
  }

  removeSupplier(int supplierId)async{
    if((supplierCount - 1) < 1){
      removeFail(context);
    }
    else{
      await DatabaseMethods.removeProductSupplier(supplierId, widget.productMap['ProductID']);
      setState(() {
        _currentSupplierStream = DatabaseMethods.getSupplierSnapshot();
      });
    }
  }

  @override 
  Widget build(BuildContext build){
    return Scaffold(
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
            onPressed: ()=> navigateTo(context, widget, EditProductMenuPage(editProductID: widget.productMap['ProductID'],), animationType : 'scrollLeft'),
          ),
        elevation: 0,
        title:
          Text(
            "SUPPLIER LIST",
            style: TextStyle(
              letterSpacing: 3,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
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
                    stream: _currentSupplierStream,
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Center(
                          child: Text("Failed to load suppliers : ${snapshot.error}"),
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

                      List<QueryDocumentSnapshot> suppliers = snapshot.data!.docs;

                      Future<List<QueryDocumentSnapshot>> getFilteredSuppliers() async {
                        List<QueryDocumentSnapshot> filteredSuppliers = [];

                        for (var supplierDoc in suppliers) {
                          var supplier = supplierDoc.data() as Map<String, dynamic>;
                          bool isProductSupplierResult = await isProductSupplier(supplier['SupplierID']);
                          if (isProductSupplierResult) {
                            filteredSuppliers.add(supplierDoc);
                          }
                        }

                        return filteredSuppliers;
                      }


                      return
                      FutureBuilder(
                      future: getFilteredSuppliers(),
                      builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      List<QueryDocumentSnapshot> filteredSuppliers = snapshot.data ?? [];

                      supplierCount = filteredSuppliers.length;

                      return
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: suppliers.length,
                        padding: EdgeInsets.fromLTRB(0, 25, 0, 50),
                        itemBuilder: (context, index){
                          if(index >= filteredSuppliers.length){
                            Container();
                          }
                          else{
                          var supplier= filteredSuppliers[index].data() as Map<String, dynamic>;
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
                                height: (sHeight * 0.10),
                                child:

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [


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
                                                  supplier['SupplierName'],
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
                                                  supplier['SupplierEmail'],
                                                  fontSize: n3s,
                                                  fontWeight: FontWeight.w300,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                  mt: 5,
                                                ),
                                                ),
                                              ],
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
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: 
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.person_remove_alt_1_rounded),
                                                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                                                  onPressed: (){
                                                    removeSupplier(supplier['SupplierID']);
                                                  },
                                                  iconSize: 20,
                                                ),


                                              ],
                                            ),

                                          ]
                                        ),
                                      ),


                                    ],
                                  ),
                                )
                                  ]
                              )




                              ),
                            ),
                          );
                        }// ELSE PADDING HERE
                        }
                        );
                        //////////////////////////////////////////////////////////////////
                      }
                      );







                    }

                  ),
                // ),





              ],
            ),
        ),
      ),





      floatingActionButton: 

        FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          heroTag: null,
          child: const Icon(Icons.add_rounded),
          onPressed: () {
            navigateTo(context, widget, EditAddSupplierPage(productMap: widget.productMap), animationType: "scrollRight");
          },
        ),

    );
  }
}