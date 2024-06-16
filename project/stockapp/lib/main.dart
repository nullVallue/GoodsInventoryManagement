// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockapp/page/authenticated/landing_pg.dart';
import 'package:stockapp/theme/theme_con.dart';
import 'package:stockapp/theme/theme_manager.dart';
import 'package:stockapp/database/database.dart';
import 'package:stockapp/dev/playground.dart';

// import firebase packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockapp/util/constants.dart';
import 'firebase_options.dart';


// import pages
import 'package:stockapp/page/authenticated/dashboard_pg.dart';
import 'package:stockapp/page/annonymous/login_pg.dart';
import 'package:stockapp/page/annonymous/signup_pg.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setCurrentUser();  

  SharedPreferences prefs = await SharedPreferences.getInstance();


  if(prefs.getBool('isDark') != null){
    themeManager.toggleTheme(prefs.getBool('isDark')??false);
  }



  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

Future<void> setPermissions(String role) async {
  if(role == 'reset'){
    userPermissions = {
      'ManageOutlet' : false,
      'ManagePurchase' : false,
      'ManageUser' : false,
      'ViewOtherOutlets' : false,
      'ViewReport' : false,
    };
  }
  else{
    userPermissions = await DatabaseMethods.getRolePermissionAsMap(role);
  }
}

Map<String, dynamic> userPermissions = {
  'ManageOutlet' : false,
  'ManagePurchase' : false,
  'ManageUser' : false,
  'ViewOtherOutlets' : false,
  'ViewReport' : false,
};

Map<String, dynamic> sessionUser = {
      'AddressLine1' : 'DATA NOT LOADED',
      'AddressLine2' : 'DATA NOT LOADED',
      'City' : 'DATA NOT LOADED',
      'Email' : 'DATA NOT LOADED',
      'FirstName' : 'DATA NOT LOADED',
      'LastLoggedIn' : DateTime(0, 1, 1, 0, 0, 0, 0),
      'LastName' : 'DATA NOT LOADED',
      'OutletID' : 0,
      'Password' : 'DATA NOT LOADED',
      'PhoneNo' : 'DATA NOT LOADED',
      'Postcode' : 00000,
      'Role' : 'DATA NOT LOADED',
      'State' : 'DATA NOT LOADED',
      'Status' : 'DATA NOT LOADED',
      'UserID' : 0,
      'ImageURL' : '',
      'Keywords' : [],
};


final String yoloURL = Constant.yoloApiUrl;

Future<bool> setCurrentUser() async {
  User? user = Auth().currentUser;
  print(user);

  
  if(user != null){
    String userEmail = user.email??'';
    QuerySnapshot query = await DatabaseMethods.getUserByEmailQuery(userEmail);
    sessionUser = query.docs.first.data() as Map<String, dynamic>;
    sessionUser['UserID'] = query.docs.first.id;
    await setPermissions(sessionUser['Role']);
    return true;
  }
  else{
    print("User not found");
    return false;
  }
}

// setDark(isDark){
//   _themeManager.toggleTheme(isDark);
// }

ThemeManager themeManager = ThemeManager();

// initialise screen width and height so it can be accessed globally
double sHeight = 0;
double sWidth = 0;

Map<String, dynamic> currentUser = {};


class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState(){
    super.initState();
    themeManager.addListener(themeListener);
  }


  @override
  void dispose(){
    super.dispose();
    themeManager.removeListener(themeListener);
  }


  themeListener(){
    if(mounted){
      setState(() {
        
      });
    }
  }

  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    sHeight = MediaQuery.of(context).size.height;
    sWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: SessionWrapper(),
      // home: Playground(),
      debugShowCheckedModeBanner: false,
      title: 'Authenticate',
      // theme: darkTheme,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      // themeMode: ThemeMode.system,
    );
  }
}

class SessionWrapper extends StatefulWidget{
  const SessionWrapper({super.key});

  @override
  State<SessionWrapper> createState() => _SessionWrapperState();
}

class _SessionWrapperState extends State<SessionWrapper>{

  User? user = Auth().currentUser;
  
  late Stream<DocumentSnapshot> _currentUserStream;

  @override
  void initState(){
    super.initState();
    _currentUserStream = DatabaseMethods.getUserByIdStream(sessionUser['UserID'].toString());


  }



  @override
  Widget build(BuildContext context) {
    //check session here
    // return Playground();
    // return user != null ? LandingPage() : LoginPage();
      return StreamBuilder<DocumentSnapshot>(
      stream: _currentUserStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is being fetched, you can return a loading indicator or placeholder.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error in fetching the data, you can handle it here.
          return Text('Error: ${snapshot.error}');
        } else {
          // If data is successfully fetched, update the sessionUser and return the appropriate widget.
          // sessionUser = _currentUserStream.data() as Map<String,dynamic>;
          // sessionUser = snapshot.data!.data() as Map<String, dynamic>;

          sessionUser = snapshot.data?.data() as Map<String, dynamic>? ?? sessionUser;
          return user != null ? LandingPage() : LoginPage();
        }
      },
    );
  }
}

