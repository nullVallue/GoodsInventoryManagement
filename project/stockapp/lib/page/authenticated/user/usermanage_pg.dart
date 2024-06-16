// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:stockapp/page/authenticated/profile/editprofilemenu_pg.dart';
import 'package:stockapp/page/authenticated/user/adduser_pg.dart';
import 'package:stockapp/page/authenticated/user/editusermenu_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/main.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/util/custom_widgets.dart';

// external packages
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {

  late Stream<QuerySnapshot> _userStream;
  TextEditingController searchController = TextEditingController();

  bool descending = false; 
  String currentStatusFilter = '';
  String currentRoleFilter= '';
  String currentSearchTerm = '';
  bool filterOn = false;
  bool sortOn = false;

  @override
  void initState(){
    super.initState();
    _userStream = DatabaseMethods.getUserSnapshot();
  }

  resetSortFilter(){
    setState(() {
      sortOn = false;
      filterOn = false;
      currentStatusFilter = '';
      currentRoleFilter = '';
      _userStream = DatabaseMethods.getUserSnapshot();
    });
  }

  searchHandler(){

    if(!filterOn){
      setState(() {
        _userStream = DatabaseMethods.getUserSearchSnapshot(
        searchTerm: currentSearchTerm,
        roleFilter: (currentRoleFilter=='')?null:currentRoleFilter,
        descending: descending,
        );
      });
    }
    else{

      setState(() {
        _userStream = DatabaseMethods.getUserSearchSnapshot(
        searchTerm: currentSearchTerm,
        statusFilter: currentStatusFilter,
        roleFilter: (currentRoleFilter=='')?null:currentRoleFilter,
        descending: descending,
        );
      });
    }

    // print('Search Term ' + currentSearchTerm);
    // print('Status ' +  currentStatusFilter);
    // print('role ' + currentRoleFilter);
    // print('Des');
    // print(descending);

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

  filterUser(int type){
    // 0 active
    // 1 inactive 
    // 2 pending 
    // 3 staff 
    // 4 manager 
    // 5 admin 
    switch(type){
      case 0:
        setState((){
          currentStatusFilter = 'Active';
          currentRoleFilter = '';
        });
        break;
      case 1:
        setState((){
          currentStatusFilter = 'Inactive';
          currentRoleFilter = '';
        });
        break;
      case 2:
        setState((){
          currentStatusFilter = 'Pending';
          currentRoleFilter = '';
        });
        break;
      case 3:
        setState((){
          currentStatusFilter = '';
          currentRoleFilter = 'Staff';
        });
        break;
      case 4:
        setState((){
          currentRoleFilter = 'Manager';
          currentStatusFilter = '';
        });
        break;
      case 5:
        setState((){
          currentRoleFilter = 'Admin';
          currentStatusFilter = '';
        });
        break;
      default:
        setState((){
          currentStatusFilter = '';
          currentRoleFilter = '';
        });
        break;
    }

    searchHandler();
  }

  switchStatus(bool isActive, String email){
    DatabaseMethods.updateUserStatus(isActive, email);
  }

  String getUserFirstLastName(Map<String, dynamic>user){
    if(user['Email'] == sessionUser['Email']){
      return user['FirstName'] + ' ' + user['LastName'] + " (You)";
    }
    else{
      return user['FirstName'] + ' ' + user['LastName'];
    }
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
            filterUser(0);
            showSnackBar(context, "Filter Active Users");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Active Users',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          )
        ),
        
        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filterUser(1);
            showSnackBar(context, "Filter Inactive Users");
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
            filterUser(2);
            showSnackBar(context, "Filter Pending Users");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Pending',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),


        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filterUser(3);
            showSnackBar(context, "Filter Staff Users");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Staff',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),



        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filterUser(4);
            showSnackBar(context, "Filter Manager Users");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Manager',
              textColor: Theme.of(context).colorScheme.onSecondary
            ),
          ),
        ),



        PopupMenuItem(
          onTap: (){
            setState((){
              filterOn = true;
            });
            filterUser(5);
            showSnackBar(context, "Filter Admin Users");
          },
          child: ListTile(
            title: 
            createText(
              'Filter Admin',
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
                    stream: _userStream,
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Center(
                          child: Text("Failed to load users : ${snapshot.error}"),
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

                      List<QueryDocumentSnapshot> users = snapshot.data!.docs;

                      return
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: users.length,
                        padding: EdgeInsets.fromLTRB(0, 85, 0, 50),
                        itemBuilder: (context, index){
                          var user = users[index].data() as Map<String, dynamic>;
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
                                        flex: 3,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            (user['Email'] != sessionUser['Email'])?
                                            navigateTo(context, widget, EditUserMenuPage(editUserEmail: user['Email']))
                                            :
                                            navigateTo(context, widget, EditProfileMenuPage(), animationType: 'scrollRight');
                                          },
                                          child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: 
                                              (user['ImageURL'] != '')? 
                                              [

                                              ProfilePicture(
                                                name: '${user['FirstName']} ${user['LastName']}',
                                                radius: 25,
                                                fontsize: 25,
                                                img: user['ImageURL'],
                                                // random: true,
                                    )
                                              ]: 
                                              [
                                              ProfilePicture(
                                                name: '${user['FirstName']} ${user['LastName']}',
                                                radius: 25,
                                                fontsize: 25,
                                                // random: true,
                                              ),

                                              ],
                                            )
                                          ]
                                        ),
                                        ),
                                      ),


                                      Expanded(
                                        flex: (user['Email'] == sessionUser['Email'] || user['UserID'] == 1000)?8:5,
                                        child:
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            (user['Email'] != sessionUser['Email'])?
                                            navigateTo(context, widget, EditUserMenuPage(editUserEmail: user['Email']))
                                            :
                                            navigateTo(context, widget, EditProfileMenuPage(), animationType: 'scrollRight');
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
                                                    getUserFirstLastName(user),
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
                                                  user['Email'],
                                                  fontSize: n3s,
                                                  fontWeight: FontWeight.w300,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                    overflow: TextOverflow.ellipsis,
                                                  mt: 5,
                                                  mb: 10,
                                                ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle_rounded,
                                                  size: 12,
                                                  color: getStatusColor(user['Status']),
                                                  ),
                                                Expanded(
                                                  child:
                                                createText(
                                                  user['Status'],
                                                  fontSize: n3s,
                                                  fontWeight: h4w,
                                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                                  overflow: TextOverflow.ellipsis,
                                                  ml: 10,
                                                ),
                                                )
                                              ],
                                            ),
                                          ]
                                        ),
                                        ),
                                      ),


                                      // Expanded(
                                      //   flex: 3,
                                      //   child:
                                      //   InkWell(
                                      //     splashColor: Colors.transparent,
                                      //     highlightColor: Colors.transparent,
                                      //     onTap: (){
                                      //       (user['Email'] != sessionUser['Email'])?
                                      //       navigateTo(context, widget, EditUserMenuPage(editUserEmail: user['Email'])):print('Current User');
                                      //     },
                                      //     child:
                                      //   Column(
                                      //     mainAxisAlignment: MainAxisAlignment.center,
                                      //     children: [
                                      //       Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         children: (user['Email'] == sessionUser['Email'])? []: 
                                      //         [
                                      //           IconButton(
                                      //             icon: Icon(
                                      //               Icons.arrow_forward_ios_rounded,
                                      //               size: 25,
                                      //               ),

                                      //             color: Colors.grey.withOpacity(0.7),
                                      //             // color: Theme.of(context).colorScheme.onSecondary,
                                      //             onPressed: (){
                                      //               // null;
                                      //               navigateTo(context, widget, EditUserMenuPage(editUserEmail: user['Email']));
                                      //             },
                                      //           ),
                                      //         ],
                                      //       )
                                      //     ]
                                      //   ),
                                      //   ),
                                      // ),

                                      (user['Email'] == sessionUser['Email'] || user['UserID'] == 1000)? Container():VerticalDivider(
                                        width: 0,
                                        thickness: 1,
                                        color: Colors.grey.withOpacity(0.3),
                                      ),

                                      Expanded(
                                        flex: (user['Email'] == sessionUser['Email'] || user['UserID'] == 1000)?0:3,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: (user['Email'] == sessionUser['Email'])? []:
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                createSwitch(
                                                  inactiveThumbColor: Colors.white,
                                                  activeColor: Colors.white,
                                                  activeTrackColor: Colors.greenAccent,
                                                  value: (user['Status'] == 'Active')?true:false,
                                                  onChanged: (value){
                                                    switchStatus(value, user['Email']);
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
                    hintText: "Search User",
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
                navigateTo(context, widget, AddUserPage(), animationType: "scrollRight");
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