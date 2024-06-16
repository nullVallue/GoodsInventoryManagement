
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stockapp/page/authenticated/purchase/addpurchaselist_pg.dart';
import 'package:stockapp/page/authenticated/purchase/viewpurchasedetails_pg.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockmvmtmanage_pg.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockmyrequest_pg.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockrequest_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/util/custom_widgets.dart';

// external packages
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class StockPageControllerPage extends StatefulWidget {
  final initialIndex; 
  const StockPageControllerPage({super.key, required this.initialIndex});

  @override
  State<StockPageControllerPage> createState() => _StockPageControllerPageState();
}

class _StockPageControllerPageState extends State<StockPageControllerPage> with SingleTickerProviderStateMixin {

  late TabController tabController;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialIndex);
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

  List<Widget> tabPages = [
    StockMvmtManagementPage(),
    StockRequestPage(),
    StockMyRequestPage(),
  ];

  List<Tab> getTabList(){
    return

    [
      Tab(
      child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            createText(
              'History',
              fontSize: sub4s,
              textAlign: TextAlign.center,
              textColor: Theme.of(context).colorScheme.onBackground
            ),
          ],
        )
      ),

      Tab(
      child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            createText(
              'Requests',
              fontSize: sub4s,
              textAlign: TextAlign.center,
              textColor: Theme.of(context).colorScheme.onBackground
            ),
          ],
        )
      ),

      Tab(
      child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            createText(
              'My Requests',
              fontSize: sub4s,
              textAlign: TextAlign.center,
              textColor: Theme.of(context).colorScheme.onBackground
            ),
          ],
        )
      ),
    ];
  }


  @override 
  Widget build(BuildContext build){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: 
        AppBar(
          elevation: 0,
          title: null,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          bottom: 
          TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            controller: tabController,
            labelColor: Theme.of(context).colorScheme.onBackground,
            unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
            tabs: getTabList(),
          ),
        ),
      ),

      body: 
      WillPopScope(onWillPop: () async {return false;},
        child: 
        TabBarView(
          controller: tabController,
          children: tabPages,
        ),
      ),




    );
  }


}