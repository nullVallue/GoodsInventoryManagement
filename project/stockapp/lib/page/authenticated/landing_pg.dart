// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
// page packages
import 'package:stockapp/page/authenticated/dashboard_pg.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/page/authenticated/inventory/invmanage_pg.dart';
import 'package:stockapp/page/authenticated/outlet/outletmanage_pg.dart';
import 'package:stockapp/page/authenticated/product/productmanage_pg.dart';
import 'package:stockapp/page/authenticated/profile/editprofilemenu_pg.dart';
import 'package:stockapp/page/authenticated/purchase/purchasemanage_pg.dart';
import 'package:stockapp/page/authenticated/reportandanalytics/reportmenu_pg.dart';
import 'package:stockapp/page/authenticated/settings_pg.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockmvmtmanage_pg.dart';
import 'package:stockapp/page/authenticated/stockmovement/stockpagectrl_pg.dart';

// util packages
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/page/authenticated/user/usermanage_pg.dart';
import 'package:stockapp/util/custom_widgets.dart';

// db packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockapp/database/database.dart';

// external packages
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

// Landing Page
// ======================================================================

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, this.pageIndex = 0, this.stockIndex = 0});
  final int pageIndex;
  final int stockIndex;
  

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  
  late int currentPageIndex;
  
  late PageController pageController;

  final User? user = Auth().currentUser;

  int stockIndex = 0;

  signOut() async {

    BuildContext currentContext = context;
    showLoadingDialog(
      title: "Signing Out",
      context: context,
      bgColor: Theme.of(context).colorScheme.background,
      titleColor: Theme.of(context).colorScheme.onBackground,
      msgColor: Theme.of(context).colorScheme.onTertiaryContainer,
      loadingColor: Theme.of(context).colorScheme.primary,
      bradius: 15,
      dismissable: false,
    );


    await DatabaseMethods.createAuthLogMap(sessionUser, 'Logout');

    await Security.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(currentContext).pop();
    navigateTo(currentContext, widget, SessionWrapper(), animationType: 'scrollLeft');
  }

  @override
  void initState(){
    super.initState();
    currentPageIndex = widget.pageIndex;
    pageController = PageController(initialPage: currentPageIndex);
  }

  List<Widget> getPages(){
    return
    [
      DashboardPage(),
      ProductManagementPage(),
      StockPageControllerPage(initialIndex: widget.stockIndex),
      InvManagementPage(),
      UserManagementPage(),
      PurchaseManagementPage(),
      OutletManagementPage(),
      ReportMenuPage(),
      SettingsPage(),
    ];
  }
  

  Widget getPageTitles(BuildContext context, int index){
    List<Widget> pageTitles = [
      Text(
        "DASHBOARD",
        style: TextStyle(
          letterSpacing: 5,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      Text(
        "PRODUCT",
        style: TextStyle(
          letterSpacing: 5,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      Text(
        "STOCK MOVEMENT",
        style: TextStyle(
          letterSpacing: 5,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      Text(
        "INVENTORY",
        style: TextStyle(
          letterSpacing: 5,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      Text(
        "USER MANAGEMENT",
        style: TextStyle(
          letterSpacing: 2,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      Text(
        "PURCHASE",
        style: TextStyle(
          letterSpacing: 5,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      Text(
        "OUTLET MANAGEMENT",
        style: TextStyle(
          letterSpacing: 2,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      Text(
        "REPORTS & ANALYTICS",
        style: TextStyle(
          letterSpacing: 2,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      Text(
        "SETTINGS",
        style: TextStyle(
          letterSpacing: 5,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    ];

    return pageTitles[index];
    
  }
  
  
  final List<BarItem> barlist = [
    BarItem( // dashboard
      filledIcon: Icons.home, 
      outlinedIcon: Icons.home_outlined,
    ),
    BarItem( // product
      filledIcon: Icons.auto_awesome_mosaic_rounded,
      outlinedIcon: Icons.auto_awesome_mosaic_outlined,
    ),
    BarItem( // Auto counter 
      filledIcon: Icons.move_down_rounded,
      outlinedIcon: Icons.move_down_outlined,
    ),
    BarItem( // Inventory 
      filledIcon: Icons.inventory_2_rounded,
      outlinedIcon: Icons.inventory_2_outlined,
    ),
  ];
  
  @override
  Widget build(BuildContext build) {
  
  
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        leading: 
          Builder(
            builder: (BuildContext context){
              return
              IconButton(
              icon: Icon(Icons.menu_rounded),
              iconSize: 25,
              onPressed: () => Scaffold.of(context).openDrawer(),
              );
          },),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: getPageTitles(context, currentPageIndex),
        elevation: 0,
        ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: getPages(),
      ),
      drawer:  
        ClipRRect(
          borderRadius: BorderRadius.horizontal(
          right: Radius.circular(20.0),
          ), // Adjust as needed
        child:
        Drawer(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: 
        Column(
          
          children: [

            Container(
              height: (sHeight * 0.8),
              child: 
              
        ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        navigateTo(context, widget, EditProfileMenuPage(), animationType: 'scrollRight');
                      },
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (sessionUser['ImageURL']!='')?
                          ProfilePicture(
                            name: '${sessionUser['FirstName']} ${sessionUser['LastName']}',
                            radius: 30,
                            fontsize: 25,
                            img: sessionUser['ImageURL'],
                            // random: true,
                          )
                          :
                          ProfilePicture(
                            name: '${sessionUser['FirstName']} ${sessionUser['LastName']}',
                            radius: 30,
                            fontsize: 25,
                            // random: true,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        navigateTo(context, widget, EditProfileMenuPage(), animationType: 'scrollRight');
                      },
                      child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child:
                          createText(
                            sessionUser['FirstName'],
                            fontSize: h3s,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            overflow: TextOverflow.ellipsis,
                            mt: 10,
                          ),                        
                        ),
                      ],
                    ),
                    ),
                    InkWell(
                      onTap: (){
                        navigateTo(context, widget, EditProfileMenuPage(), animationType: 'scrollRight');
                      },
                      child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child:
                        createText(
                          sessionUser['Role'],
                          fontSize: n3s,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          mt: 10,
                        ),                        
                        )
                      ],
                    ),
                    ),
                  ],
                ),
              ),
            ),

            Visibility(
              visible: userPermissions['ManageUser'],
              child:
            ListTile(
              leading: Icon(
                Icons.person_rounded,
                color: Theme.of(context).colorScheme.onTertiary,
                ),
              title: 
              createText(
                "User Management",
                textColor: Theme.of(context).colorScheme.onTertiary,
                fontSize: 17,
                fontWeight: h3w,
              ),
              onTap: (){
                Navigator.of(context).pop();
                setState(() {
                  currentPageIndex = 4;
                });
              pageController.jumpToPage(currentPageIndex);
              },
              contentPadding: EdgeInsets.fromLTRB(30, 10, 20, 5),
            ),
            ),
            
            
            Visibility(
              visible: userPermissions['ManagePurchase'],
              child:
            ListTile(
              leading: Icon(
                Icons.attach_money_rounded,
                color: Theme.of(context).colorScheme.onTertiary,
                ),
              title: 
              createText(
                "Purchase",
                textColor: Theme.of(context).colorScheme.onTertiary,
                fontSize: 17,
                fontWeight: h3w,
              ),
              onTap: (){
                Navigator.of(context).pop();
                setState(() {
                  currentPageIndex = 5;
                });
              pageController.jumpToPage(currentPageIndex);
              },
              contentPadding: EdgeInsets.fromLTRB(30, 5, 20, 5),
            ),
            ),
            
            
            Visibility(
              visible: userPermissions['ManageOutlet'],
              child:
            ListTile(
              leading: Icon(
                Icons.store_mall_directory_rounded,
                color: Theme.of(context).colorScheme.onTertiary,
                ),
              title: 
              createText(
                "Outlet Management",
                textColor: Theme.of(context).colorScheme.onTertiary,
                fontSize: 17,
                fontWeight: h3w,
              ),
              onTap: (){
                Navigator.of(context).pop();
                setState(() {
                  currentPageIndex = 6;
                });
              pageController.jumpToPage(currentPageIndex);
              },
              contentPadding: EdgeInsets.fromLTRB(30, 5, 20, 5),
            ),
            ),
            
            

            Visibility(
              visible: userPermissions['ViewReport'],
              child:
            ListTile(
              leading: Icon(
                Icons.bar_chart_rounded,
                color: Theme.of(context).colorScheme.onTertiary,
                ),
              title: 
              createText(
                "Reports & Analytics",
                textColor: Theme.of(context).colorScheme.onTertiary,
                fontSize: 17,
                fontWeight: h3w,
              ),
              onTap: (){
                Navigator.of(context).pop();
                setState(() {
                  currentPageIndex = 7;
                });
              pageController.jumpToPage(currentPageIndex);
              },
              contentPadding: EdgeInsets.fromLTRB(30, 5, 20, 5),
            ),
            )
            
            
          ],
        ),
        ),
        
        Spacer(),

        Padding(
          padding: EdgeInsets.fromLTRB(0,0,0,0),
          child:
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onTertiary,
              ),
            title: 
            createText(
              "Settings",
              textColor: Theme.of(context).colorScheme.onTertiary,
              fontSize: 17,
              fontWeight: h3w,
            ),
            onTap: (){
              Navigator.of(context).pop();
              setState(() {
                currentPageIndex = 8;
              });
              pageController.jumpToPage(currentPageIndex);
            },
            contentPadding: EdgeInsets.fromLTRB(30, 5, 20, 5),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0,0,0,30),
          child:
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
              color: Theme.of(context).colorScheme.onTertiary,
              ),
            title: 
            createText(
              "Sign Out",
              textColor: Theme.of(context).colorScheme.onTertiary,
              fontSize: 17,
              fontWeight: h3w,
            ),
            onTap: (){
              signOut();
            },
            contentPadding: EdgeInsets.fromLTRB(30, 5, 20, 5),
          ),
        ),

        
        ],          
        ),

        ),
          ),
      bottomNavigationBar: 
        // radius for btm nav bar
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: 
          WaterDropNavBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            waterDropColor: Theme.of(context).colorScheme.background,
            // waterDropColor: Colors.transparent,
            bottomPadding: 45,
            onItemSelected: (index) {
              int fromIndex = currentPageIndex;
              setState(() {
                currentPageIndex = index;
              });
              if(fromIndex > 3){
                pageController.jumpToPage(currentPageIndex);
              }
              else{
                pageController.animateToPage(
                currentPageIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
              }
            },
            selectedIndex: currentPageIndex,
            barItems: barlist,

          ),
        ) // decorated box
    );
  }
}
//=======================================================================================