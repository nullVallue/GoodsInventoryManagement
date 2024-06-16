import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockapp/main.dart';


final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

List<String> removeDuplicates(List<String> list) {
  List<String> result = [];
  Set<String> seenElements = Set<String>();

  for (String element in list) {
    if (!seenElements.contains(element)) {
      seenElements.add(element);
      result.add(element);
    }
  }


  return result;
}


List<String> generateSubstrings(List<String> inputList) {
  String str = '';
  List<String> result = [];

  for(int i = 0; i < inputList.length; i++){
    str += inputList[i];
    if(i != inputList.length - 1){
      str += ' ';
    }
  }

  for (int i = 1; i <= str.length; i++) {
    result.add(str.substring(0, i));
  }

  return result;
}

List<String> generateKeywords(List<String> inputList) {
  List<List<String>> permutations = getPermutations(inputList);
  List<String> result = [];

  for(int i = 0; i < permutations.length; i++){
    List<String> temp = generateSubstrings(permutations[i]);
    for(int j = 0; j < temp.length; j++){
      result.add(temp[j].toLowerCase());
    }
  }

  result = removeDuplicates(result);
  result.add('');

  return result;
}

List<List<String>> getPermutations(List<String> items) {
  List<List<String>> result = [];
  _generatePermutations(items, 0, result);
  return result;
}

void _generatePermutations(List<String> items, int index, List<List<String>> result) {
  if (index == items.length - 1) {
    result.add(List.from(items));
    return;
  }

  for (int i = index; i < items.length; i++) {
    _swap(items, index, i);
    _generatePermutations(items, index + 1, result);
    _swap(items, index, i); // Backtrack to the original state
  }
}

void _swap(List<String> items, int i, int j) {
  String temp = items[i];
  items[i] = items[j];
  items[j] = temp;
}


class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // firebase auth handle sign in 
  Future<void> authSignIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password
      );
  }
  
  // firebase auth handle sign up 
  Future<void> authSignUp({
    required String email,
    required String password,
    required FirebaseApp tempApp,
  }) async {
    await FirebaseAuth.instanceFor(app: tempApp).createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    await FirebaseAuth.instanceFor(app: tempApp).signOut();
  }
  
  // firebase auth handle sign out
  Future<void> authSignOut() async{
    await _firebaseAuth.signOut();

  }

  Future<String> resetPassword(String email) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email); 
    }
    catch(e){
      return '${e}';
    }

    return '';
  }

}

class Security{
  static signOut() async {
    await Auth().authSignOut();
    await setPermissions('reset');

  }
  
  static Future<int> signIn({required String email, required String password}) async{
    try{
      await Auth().authSignIn(email: email, password: password);
    }
    on FirebaseAuthException catch(e){
      print("Unable to Sign In : $e");
      return 1; // return 1 if invalid creds
    }


    QuerySnapshot query= await db.collection('User').where('Email', isEqualTo: email).get();
    Map<String, dynamic> userMap = query.docs.first.data() as Map<String, dynamic>;

    if(userMap['Status'] != 'Active'){
      signOut();
      return 2; // return 2 if account has not been activated
    }

    if(userMap['UserID'] != 1000){

      if(!Auth().currentUser!.emailVerified){

        Auth().currentUser?.sendEmailVerification();

        signOut();
        return 3;
      };

    }


    sessionUser = userMap;

    DatabaseMethods.createAuthLogMap(userMap, 'Login');

    await setPermissions(sessionUser['Role']);
    
    return 0; // return 0 if success
  }





}

class DatabaseMethods{


  // auth log methods

  static Future<void> createAuthLogMap(Map<String, dynamic> userMap, String action) async {



    Map<String, dynamic> authLogMap = {
      'Action' : action,
      'Timestamp' : DateTime.now(),
      'UserID' : userMap['UserID'],
    };

    authLogMap['Keywords'] = generateKeywords([userMap['FirstName'], userMap['LastName'], userMap['Email'], userMap['UserID'].toString()]);

    print(await addAuthLogDetails(authLogMap));

  }

  static Future<String> getLatestAuthLogID() async{
    try{
      
      QuerySnapshot query = await db.collection("AuthLog").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        // int userid = query.docs.first['UserID'];
        String id = query.docs.first.id;
        return id;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest Auth ID : $e');
      return '';
    }

  }

  static Future<String> addAuthLogDetails(Map<String, dynamic> addmap) async {
    String newAuthLogIdStr = await getLatestAuthLogID();
    if(newAuthLogIdStr.isEmpty || newAuthLogIdStr == ''){
      print("Failed to get latest Auth Log ID");
      print(newAuthLogIdStr);
      return "System Error : Failed to get latest Auth Log ID";
    }
    else{
      int newAuthLogId = int.parse(newAuthLogIdStr);
      newAuthLogId++;

      addmap['AuthLogID'] = newAuthLogId;

      try{
        await db.collection("AuthLog").doc(newAuthLogId.toString()).set(addmap);
      }
      catch(e){
        print('Error adding Auth Log record to database : $e');
        return "Error : $e";
      }
    }
    return '';

  }





// user methods
  static Stream<QuerySnapshot> getUserSnapshot() {
    // test();
    return db.collection('User').orderBy('Status', descending: true).snapshots();
  }


  static Future<List<String>> getOutletList() async {
    List<String> outletList = [];
    try{
      QuerySnapshot query = await db.collection('Outlet').get();

      query.docs.forEach((DocumentSnapshot document){
        int outletID = document['OutletID'] as int;
        String outletIDstr = outletID.toString();
        outletList.add(outletIDstr);
      });
    }
    catch(e){
      print('Error getting OutletIDs : $e');
    }

    return outletList;
  }

  static Future<List<Map<String,dynamic>>> getOutletAsMapList() async {
    List<Map<String,dynamic>> outletList = [];
    try{
      QuerySnapshot query = await db.collection('Outlet').get();

      query.docs.forEach((DocumentSnapshot document){
        Map<String, dynamic> outletmap = document.data() as Map<String, dynamic>;
        outletList.add(outletmap);
      });
    }
    catch(e){
      print('Error getting OutletIDs : $e');
    }

    return outletList;
  }


  static Stream<QuerySnapshot> getUserSearchSnapshot({String searchTerm = '', String? statusFilter, String? roleFilter, bool? descending}) {
    final result;

    if(statusFilter != null && statusFilter != ''){
      print('1');
      // if status filter is on 
      if(roleFilter != null && roleFilter != ''){
        // if role filter is also on
        if(descending != null && descending){
          // if descending is on
          result = db.collection('User')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: statusFilter)
          .where('Role', isEqualTo: roleFilter)
          .orderBy('FirstName', descending: true).snapshots();
        }
        else{
          // if descending is off 
          result = db.collection('User')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: statusFilter)
          .where('Role', isEqualTo: roleFilter)
          .orderBy('FirstName').snapshots();
        }
      }
      else{
        // if only status filter is on 
        if(descending != null && descending){
          // if descending is on
          result = db.collection('User')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: statusFilter)
          .orderBy('FirstName', descending: true).snapshots();
        }
        else{
          // if descending is off 
          result = db.collection('User')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: statusFilter)
          .orderBy('FirstName').snapshots();
        }
      }
    }
    else{
      print('2');
      if(roleFilter != null && roleFilter != ''){
        // if role filter is on 
        if(statusFilter != null && statusFilter != ''){
          // if status filter is also on
          if(descending != null && descending){
            // if descending is on
            result = db.collection('User')
            .where('Keywords', arrayContains: searchTerm.toLowerCase())
            .where('Status', isEqualTo: statusFilter)
            .where('Role', isEqualTo: roleFilter)
            .orderBy('FirstName', descending: true).snapshots();
          }
          else{
            // if descending is off 
            result = db.collection('User')
            .where('Keywords', arrayContains: searchTerm.toLowerCase())
            .where('Status', isEqualTo: statusFilter)
            .where('Role', isEqualTo: roleFilter)
            .orderBy('FirstName').snapshots();
          }
        }
        else{
          // if only status filter is on 
          if(descending != null && descending){
            // if descending is on
            result = db.collection('User')
            .where('Keywords', arrayContains: searchTerm.toLowerCase())
            .where('Role', isEqualTo: roleFilter)
            .orderBy('FirstName', descending: true).snapshots();
          }
          else{
            // if descending is off 
            result = db.collection('User')
            .where('Keywords', arrayContains: searchTerm.toLowerCase())
            .where('Role', isEqualTo: roleFilter)
            .orderBy('FirstName').snapshots();
          }
        }
      }
      else{
        // if both filters are off
        if(descending != null && descending){
          // if descending is on
          result = db.collection('User')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('FirstName', descending: true).snapshots();
        }
        else if(descending != null && !descending){
          // if descending is off 
          result = db.collection('User')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('FirstName').snapshots();
        }
        else{
          result = db.collection('User')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('Status', descending: true).snapshots();
        }
      }
    }



    return result;
    // return Stream.empty();
  }


  static Future<QuerySnapshot> getUserByEmailQuery(String email) async {
    QuerySnapshot querySnapshot = await db.collection('User').where('Email', isEqualTo: email).get();
    return querySnapshot;
  }

  static Future<Map<String, dynamic>> getUserByIDAsMap(int userid) async{
    QuerySnapshot query= await db.collection('User').where('UserID', isEqualTo: userid).get();

    if(query.docs.isNotEmpty){
      return query.docs.first.data() as Map<String, dynamic>;
    }
    else{
      return {};
    }
  }

  static Future<Map<String, dynamic>> getUserByEmailAsMap(String email) async {
    QuerySnapshot query = await getUserByEmailQuery(email);

    if(query.docs.isNotEmpty){
      // Map test = query.docs.first.data() as Map<String, dynamic>;
      // String test2 = query.docs.first['State'];
      // print('\n\n\n');
      // print(test2);
      return query.docs.first.data() as Map<String, dynamic>;
    }
    else{
      return {};
    }
  }

  static Stream<DocumentSnapshot> getUserByIdStream(String uid) {
    return db.collection('User').doc(uid).snapshots();
  }

  static Future<String> addUserDetails(Map<String, dynamic> userDetailsMap) async {
    String newUserIdStr = await getLatestUserID();
    if(newUserIdStr.isEmpty || newUserIdStr == ''){
      print("Failed to get latest UserID");
      print(newUserIdStr);
      return "System Error : Failed to get latest User ID";
    }
    else{
      int newUserId = int.parse(newUserIdStr);
      newUserId++;
      FirebaseApp tempApp = await Firebase.initializeApp(name: 'tempApp', options: Firebase.app().options);
      try{
        await Auth().authSignUp(
          email: userDetailsMap['Email'], 
          password: userDetailsMap['Password'],
          tempApp: tempApp,
        );
      }
      on FirebaseAuthException catch(e){
        print('Unable to Sign Up : $e');
        await tempApp.delete();
        return "Sign Up Failed : \n\nEmail already exists, please try another email";
      }

      userDetailsMap['UserID'] = newUserId;

      await tempApp.delete();

      userDetailsMap.remove('Password');

      userDetailsMap['Keywords'] = generateKeywords([userDetailsMap['FirstName'], userDetailsMap['LastName'], userDetailsMap['Email']]);

      try{
        await db.collection("User").doc(newUserId.toString()).set(userDetailsMap);
      }
      catch(e){
        print('Error adding user to database : $e');
        return "Error : $e";
      }
    }
    print(Auth().currentUser);
    return '';

  }

  static Future<String> updateUserDetails(Map<String, dynamic> updateMap) async {
    if(updateMap['UserID'] == null){
      return 'Error: updateMap is Null';
    }
    
    int userId = updateMap['UserID'];

    try{
      updateMap['Keywords'] = generateKeywords([updateMap['FirstName'], updateMap['LastName'], updateMap['Email']]);
      await db.collection('User').doc(userId.toString()).update(updateMap);
    }
    catch(e){
      print('Error editing data : $e');
      return "Error : $e";
    }

    return '';
  }
  
  static Future<String> getLatestUserID() async{
    try{
      
      QuerySnapshot query = await db.collection("User").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        // int userid = query.docs.first['UserID'];
        String userid = query.docs.first.id;
        return userid;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest user ID : $e');
      return '';
    }
  }
  
  static Future<void> updateUserStatus(bool isActive, String email) async {
    Map<String, dynamic> map = await getUserByEmailAsMap(email);

    if(isActive){
      map['Status'] = 'Active';
    }
    else{
      map['Status'] = 'Inactive';
    }

    updateUserDetails(map);
  }

  static uploadUserImg(){

  }

////////////////////////////////////////////////////////////

// outlet methods

  static Stream<QuerySnapshot> getStaffSnapshot(int outletID) {
    return db.collection('User').where('OutletID', isEqualTo: outletID).orderBy('Role').snapshots();
  }

  static Future<bool> checkHasStaff(int outletID) async {
    QuerySnapshot query = await db.collection('User').where('OutletID', isEqualTo: outletID).orderBy('Role').get();

    return query.docs.isNotEmpty;
  }


  static Future<String> getOutletNameById(int id) async {
    String name = '';
    try{
      QuerySnapshot query = await db.collection('Outlet').where('OutletID', isEqualTo: id).get();

      name = query.docs.first['OutletName'] as String;

    }
    catch(e){
      print('Error getting Outlet Name : $e');
    }

    return name;
  }


  static Future<int> getOutletIdByNameAsInt(String name) async {
    int id = 0;
    try{
      QuerySnapshot query = await db.collection('Outlet').where('OutletName', isEqualTo: name).get();

      id = query.docs.first['OutletID'] as int;

    }
    catch(e){
      print('Error getting Outlet ID: $e');
    }

    return id;
  }


  static Future<List<Map<String, dynamic>>> getOutletListMap() async {
    List<Map<String, dynamic>> outletList = [];
    try{
      QuerySnapshot query = await db.collection('Outlet').get();

      query.docs.forEach((DocumentSnapshot document){
        Map<String, dynamic>outletMap = document.data() as Map<String, dynamic>;
        outletList.add(outletMap);
      });
    }
    catch(e){
      print('Error getting Outlet List : $e');
    }

    return outletList;
  }

// get all users that are unassigned
  static Future<List<String>> getAllUserNoOutletAsList() async {
    List<String> userList = [];
    try{
      QuerySnapshot query = await db.collection('User').where('OutletID', isEqualTo: 1000).get();

      query.docs.forEach((DocumentSnapshot document){
        String userEmail = document['Email'] as String;
        userList.add(userEmail);
      });
    }
    catch(e){
      print('Error getting OutletIDs : $e');
    }

    return userList;
  }


  static Future<List<String>> getAllOutletAsList() async {
    List<String> outletList = [];
    try{
      QuerySnapshot query = await db.collection('Outlet').orderBy('OutletID').get();

      query.docs.forEach((DocumentSnapshot document){
        int outletId = document['OutletID'] as int;
        String outletIdStr = outletId.toString();
        outletList.add(outletIdStr);
      });
    }
    catch(e){
      print('Error getting Users : $e');
    }

    return outletList;
  }


  static Future<List<String>> getAllUserAsList() async {
    List<String> userList = [];
    try{
      QuerySnapshot query = await db.collection('User').get();

      query.docs.forEach((DocumentSnapshot document){
        String userEmail = document['Email'] as String;
        userList.add(userEmail);
      });
    }
    catch(e){
      print('Error getting Users : $e');
    }

    return userList;
  }

  static Stream<QuerySnapshot> getOutletSnapshot() {
    return db.collection('Outlet').orderBy('Status').snapshots();
  }

  static Future<Map<String, dynamic>> getOutletByIDAsMap(int outletID) async {
    QuerySnapshot query = await db.collection('Outlet').where('OutletID', isEqualTo: outletID).get();

    if(query.docs.isNotEmpty){
      // Map test = query.docs.first.data() as Map<String, dynamic>;
      // String test2 = query.docs.first['State'];
      // print('\n\n\n');
      // print(test2);
      return query.docs.first.data() as Map<String, dynamic>;
    }
    else{
      return {};
    }
  }

  static Future<void> updateOutletStatus(bool isActive, int outletID) async {
    Map<String, dynamic> map = await getOutletByIDAsMap(outletID);

    if(isActive){
      map['Status'] = 'Active';
    }
    else{
      map['Status'] = 'Inactive';
    }

    updateOutletDetails(map);
  }


  static Future<String> updateOutletDetails(Map<String, dynamic> updateMap) async {
    if(updateMap['OutletID'] == null){
      return 'Error: updateMap is Null';
    }
    
    int outletId = updateMap['OutletID'];

    try{
      updateMap['Keywords'] = generateKeywords([updateMap['OutletName'], updateMap['City']]);
      await db.collection('Outlet').doc(outletId.toString()).update(updateMap);
    }
    catch(e){
      print('Error editing data : $e');
      return "Error : $e";
    }

    return '';
  }



  static Future<List<String>> getManagerList() async {
    List<String> managerList = [];
    try{
      QuerySnapshot query = await db.collection('User').where('Role', isEqualTo: 'Manager').get();

      query.docs.forEach((DocumentSnapshot document){
        String managerEmail = document['Email'] as String;
        managerList.add(managerEmail);
      });
    }
    catch(e){
      print('Error getting Manager List : $e');
    }

    return managerList;
  }

  static Future<bool> checkManagerHolding(int userID) async {
    try{
      QuerySnapshot query = await db.collection('Outlet').where('UserID', isEqualTo: userID).get();

      if(query.docs.isNotEmpty){
        return true;
      }
    }
    catch(e){
      print('Error getting OutletIDs : $e');
      return true;
    }

    return false;
  }

  static Future<String> getLatestOutletID() async{
    try{
      
      QuerySnapshot query = await db.collection("Outlet").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        // int userid = query.docs.first['UserID'];
        String outletid = query.docs.first.id;
        return outletid;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest Outlet ID : $e');
      return '';
    }
  }

  static Future<String> addOutletDetails(Map<String, dynamic> outletDetailsMap) async {
    String newOutletIdStr = await getLatestOutletID();
    if(newOutletIdStr.isEmpty || newOutletIdStr == ''){
      print("Failed to get latest OutletID");
      return "System Error : Failed to get latest OutletID";
    }
    else{

      int newOutletId = int.parse(newOutletIdStr);
      newOutletId++;

      outletDetailsMap['OutletID'] = newOutletId;

      outletDetailsMap['Keywords'] = generateKeywords([outletDetailsMap['OutletName'], outletDetailsMap['City']],);

      try{
        // set user outlet
        QuerySnapshot userQuery = await db.collection('User').where('UserID', isEqualTo: outletDetailsMap['UserID']).get();

        db.collection('User').doc(userQuery.docs.first.id).update({'OutletID' : outletDetailsMap['OutletID']});

        await db.collection("Outlet").doc(newOutletId.toString()).set(outletDetailsMap);
      }
      catch(e){
        print('Error adding user to database : $e');
        return "Error : $e";
      }
    }
    return '';
  }


  static Stream<QuerySnapshot> getOutletSearchSnapshot({String searchTerm = '', String? statusFilter, String? stateFilter, bool? descending}) {
    final result;

    if(statusFilter != null && statusFilter != ''){
      // if status filter is on 
      if(stateFilter != null && stateFilter != ''){
        // if role filter is also on
        if(descending != null && descending){
          // if descending is on
          result = db.collection('Outlet')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: statusFilter)
          .where('State', isEqualTo: stateFilter)
          .orderBy('OutletName', descending: true).snapshots();
        }
        else{
          // if descending is off 
          result = db.collection('Outlet')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: statusFilter)
          .where('State', isEqualTo: stateFilter)
          .orderBy('OutletName').snapshots();
        }
      }
      else{
        // if only status filter is on 
        if(descending != null && descending){
          // if descending is on
          result = db.collection('Outlet')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: statusFilter)
          .orderBy('OutletName', descending: true).snapshots();
        }
        else{
          // if descending is off 
          result = db.collection('Outlet')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: statusFilter)
          .orderBy('OutletName').snapshots();
        }
      }
    }
    else{
      if(stateFilter != null && stateFilter != ''){
        // if role filter is on 
        if(statusFilter != null && statusFilter != ''){
          // if status filter is also on
          if(descending != null && descending){
            // if descending is on
            result = db.collection('Outlet')
            .where('Keywords', arrayContains: searchTerm.toLowerCase())
            .where('Status', isEqualTo: statusFilter)
            .where('State', isEqualTo: stateFilter)
            .orderBy('OutletName', descending: true).snapshots();
          }
          else{
            // if descending is off 
            result = db.collection('Outlet')
            .where('Keywords', arrayContains: searchTerm.toLowerCase())
            .where('Status', isEqualTo: statusFilter)
            .where('State', isEqualTo: stateFilter)
            .orderBy('OutletName').snapshots();
          }
        }
        else{
          // if only status filter is on 
          if(descending != null && descending){
            // if descending is on
            result = db.collection('Outlet')
            .where('Keywords', arrayContains: searchTerm.toLowerCase())
            .where('State', isEqualTo: stateFilter)
            .orderBy('OutletName', descending: true).snapshots();
          }
          else{
            // if descending is off 
            result = db.collection('Outlet')
            .where('Keywords', arrayContains: searchTerm.toLowerCase())
            .where('State', isEqualTo: stateFilter)
            .orderBy('OutletName').snapshots();
          }
        }
      }
      else{
        // if both filters are off
        if(descending != null && descending){
          // if descending is on
          result = db.collection('Outlet')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('OutletName', descending: true).snapshots();
        }
        else if(descending != null && !descending){
          // if descending is off 
          result = db.collection('Outlet')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('OutletName').snapshots();
        }
        else{
          result = db.collection('Outlet')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('OutletName', descending: true).snapshots();
        }
      }
    }





    return result;
    // return Stream.empty();
  }

  static Future<String> clearStaff(int outletID) async {

    try{
      QuerySnapshot query = await db.collection('User').where('OutletID', isEqualTo: outletID).get();

      for(QueryDocumentSnapshot doc in query.docs){
        await db.collection('User').doc(doc.id).update({'OutletID': 1000});
      }
    }catch(e){
      print('Error : ${e}');
      return 'Error : ${e}';
    }

    return '';

  }

  /////////////////////////////////////////////////////////////

// product methods

  static Stream<QuerySnapshot> getProductSnapshot() {
    return db.collection('Product').orderBy('ProductName').snapshots();
  }


  static Future<Map<String, dynamic>> getProductByIDAsMap(int productID) async {
    QuerySnapshot query = await db.collection('Product').where('ProductID', isEqualTo: productID).get();

    if(query.docs.isNotEmpty){
      return query.docs.first.data() as Map<String, dynamic>;
    }
    else{
      return {};
    }
  }

  // static test() async{
  //       String statusFilter = '';
  //       String searchTerm = '';

  //       db.collection('Product')
  //       .where('Keywords', arrayContains: searchTerm.toLowerCase())
  //       .where('Status', isEqualTo: statusFilter)
  //       .orderBy('ProductName', descending: true).get();
  //       db.collection('Product')
  //       .where('Keywords', arrayContains: searchTerm.toLowerCase())
  //       .where('Status', isEqualTo: statusFilter)
  //       .orderBy('ProuctName').get();
  // }

  static Stream<QuerySnapshot> getProductSearchSnapshot({String searchTerm = '', String? statusFilter,  bool? descending}) {
    final result;

    if(statusFilter != null && statusFilter != ''){
      // if status filter is on 

      if(descending != null && descending){
        // if descending is on
        result = db.collection('Product')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .where('Status', isEqualTo: statusFilter)
        .orderBy('ProductName', descending: true).snapshots();
      }
      else{
        // if descending is off 
        result = db.collection('Product')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .where('Status', isEqualTo: statusFilter)
        .orderBy('ProductName').snapshots();
      }

    


    }
    else{


      // if both filters are off
      if(descending != null && descending){
        // if descending is on
        result = db.collection('Product')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .orderBy('ProductName', descending: true).snapshots();
      }
      else if(descending != null && !descending){
        // if descending is off 
        result = db.collection('Product')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .orderBy('ProductName').snapshots();
      }
      else{
        result = db.collection('Product')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .orderBy('ProductName', descending: true).snapshots();
      }


    }


    return result;
    // return Stream.empty();
  }



  static Future<String> getLatestProductSupplierID() async{
    try{
      
      QuerySnapshot query = await db.collection("ProductSupplier").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        String psid = query.docs.first.id;
        return psid;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest Product ID : $e');
      return '';
    }
  }

  static Future<String> getLatestProductID() async{
    try{
      
      QuerySnapshot query = await db.collection("Product").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        String productid = query.docs.first.id;
        return productid;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest Product ID : $e');
      return '';
    }
  }


  static Future<bool> checkHasProductName(String productName) async {
    QuerySnapshot query = await db.collection('Product').where('ProductName', isEqualTo: productName).get();

    return query.docs.isNotEmpty;
  }

  static Future<Map<String, dynamic>> getSupplierMapById(int supplierid) async {
    QuerySnapshot query = await db.collection('Supplier').where('SupplierID', isEqualTo: supplierid).get();

    Map<String, dynamic> returnmap = query.docs.first.data() as Map<String, dynamic>;

    if(query.docs.isNotEmpty){
      return returnmap;
    }
    else{
      return {};
    }
    
  }



  static Future<String> addProductDetails(Map<String, dynamic> productDetailsMap, String supplierName, File? imagefile) async {
    String newProductIdStr = await getLatestProductID();
    String newProductSupplierIdStr = await getLatestProductSupplierID();
    int supplierId = 0;

    QuerySnapshot supplierQuery = await getSupplierByNameQuery(supplierName);

    try{
      supplierId = supplierQuery.docs.first['SupplierID'] as int;
    }
    catch(e){
      print(e);
      return 'Error: ${e}';
    }


    if(newProductIdStr.isEmpty || newProductIdStr == ''){
      print("Failed to get latest ProductID");
      return "System Error : Failed to get latest Product ID";
    }
    else if(newProductSupplierIdStr.isEmpty || newProductSupplierIdStr == ''){
      print("Failed to get latest ProductSupplierID");
      return "System Error : Failed to get latest Product Supplier ID";
    }
    else{
      if(await checkHasProductName(productDetailsMap['ProductName'])){
        return "Error : Product name already exists";
      }

      int newProductId = int.parse(newProductIdStr);
      newProductId++;

      int newProductSupplierId = int.parse(newProductSupplierIdStr);
      newProductSupplierId++;

      productDetailsMap['ProductID'] = newProductId;

      productDetailsMap['Keywords'] = generateKeywords([productDetailsMap['ProductName']],);

      if(imagefile != null){
        String imagePath = await FirebaseStorageMethods.uploadProductImage(imagefile, newProductId.toString());
        productDetailsMap['ProductImgPath'] = imagePath;
      }

      Map<String, dynamic> psmap = {
        'ProductID' : newProductId,
        'SupplierID' : supplierId,
        'ProductSupplierID' : newProductSupplierId,
      };

      try{
        await db.collection("Product").doc(newProductId.toString()).set(productDetailsMap);

        await db.collection('ProductSupplier').doc(newProductSupplierId.toString()).set(psmap);

      }
      catch(e){
        print('Error adding product to database : $e');
        return "Error : $e";
      }
    }
    return '';
  }


  static Future<String> updateProductDetails(Map<String, dynamic> updateMap) async {
    if(updateMap['ProductID'] == null){
      return 'Error: updateMap is Null';
    }
    
    int productId = updateMap['ProductID'];

    try{
      updateMap['Keywords'] = generateKeywords([updateMap['ProductName']]);
      await db.collection('Product').doc(productId.toString()).update(updateMap);
    }
    catch(e){
      print('Error editing data : $e');
      return "Error : $e";
    }

    return '';
  }


  static Future<void> updateProductStatus(bool isActive, int productID) async {
    Map<String, dynamic> map = await getProductByIDAsMap(productID);

    if(isActive){
      map['Status'] = 'Active';
    }
    else{
      map['Status'] = 'Inactive';
    }

    updateProductDetails(map);
  }







////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// inventory record methods
  
  static Stream<QuerySnapshot> getInvSnapshot() {
    return db.collection('InventoryRecord').orderBy('Quantity', descending: true).where('Hidden', isEqualTo: false).snapshots();
  }

  static Future<String> getLatestInvID() async{
    try{
      
      QuerySnapshot query = await db.collection("InventoryRecord").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        // int userid = query.docs.first['UserID'];
        String invid = query.docs.first.id;
        return invid;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest inventory ID : $e');
      return '';
    }
  }




  static Stream<QuerySnapshot> getInvSearchSnapshot({String searchTerm = '', String? statusFilter,  bool? descending}) {
    final result;

    if(statusFilter != null && statusFilter != ''){
      // if status filter is on 

      if(descending != null && descending){
        // if descending is on

        if(statusFilter == 'Unhidden'){
          //show all that are not hidden 
          result = db.collection('InventoryRecord')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Hidden', isEqualTo: false)
          .orderBy('Quantity', descending: true).snapshots();
        }
        else if(statusFilter == 'Hidden'){
          //show all that are hidden 
          result = db.collection('InventoryRecord')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Hidden', isEqualTo: true)
          .orderBy('Quantity', descending: true).snapshots();
        }
        else{
          // show all
          result = db.collection('InventoryRecord')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('Quantity', descending: true).snapshots();
        }


      }
      else{

        if(statusFilter == 'Unhidden'){
          //show all that are not hidden 
          result = db.collection('InventoryRecord')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Hidden', isEqualTo: false)
          .orderBy('Quantity').snapshots();
        }
        else if(statusFilter == 'Hidden'){
          //show all that are hidden 
          result = db.collection('InventoryRecord')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Hidden', isEqualTo: true)
          .orderBy('Quantity').snapshots();
        }
        else{
          // show all
          result = db.collection('InventoryRecord')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('Quantity').snapshots();
        }
        // if descending is off 

      }
    

    }
    else{


      // if both filters are off
      if(descending != null && descending){
        // if descending is on
        result = db.collection('InventoryRecord')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Hidden', isEqualTo: false)
        .orderBy('ProductName', descending: true).snapshots();
      }
      else if(descending != null && !descending){
        // if descending is off 
        result = db.collection('InventoryRecord')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .where('Hidden', isEqualTo: false)
        .orderBy('ProductName').snapshots();
      }
      else{
        result = db.collection('InventoryRecord')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .where('Hidden', isEqualTo: false)
        .orderBy('ProductName', descending: true).snapshots();
      }

    }

    return result;

  }


  static Future<Map<String, dynamic>> getOutletInvAsMapByProductName(String name, int outletid) async {
    Map<String, dynamic> map = {};

    try{
      QuerySnapshot query = await db.collection('InventoryRecord')
      .where('ProductName', isEqualTo: name)
      .where('OutletID', isEqualTo: outletid)
      .get();

      map = query.docs.first.data() as Map<String, dynamic>;

    }
    catch(e){
      print('Error getting Manager List : $e');
    }

    return map;
  }


  static Future<List<Map<String, dynamic>>> getOutletInvAsMapList(int outletid) async {


    QuerySnapshot query = await db.collection("InventoryRecord")
    .where('Hidden', isEqualTo: false)
    .where('OutletID', isEqualTo: outletid)
    .get();

    List<Map<String, dynamic>> invList  = query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();


    return invList;
  }




// hide records that are having a qty of 0
  static Future<String> hideAllZero(int outletid) async {


    QuerySnapshot query = await db.collection("InventoryRecord")
    .where('Quantity', isEqualTo: 0)
    .where('OutletID', isEqualTo: outletid)
    .get();

    QuerySnapshot pQuery = await db.collection('Product').where('Status', isEqualTo: 'Inactive').get();

    // load query as list
    List<Map<String, dynamic>> productList = pQuery.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    List<Map<String, dynamic>> invList  = query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();


    for(int i = 0; i < invList.length; i++){
      bool found = false;

      for(int j = 0; j < productList.length; j++){
        if(invList[i]['ProductID'] == productList[j]['ProductID']){
          found = true;
          invList[i]['Hidden'] = true;
          break;
        }
      }

      if(!found){
        print('hi');
        print(invList[i]);
        invList.removeAt(i);
        i--;
      }
    }

    for(int i = 0; i < invList.length; i++){
      try{
        await db.collection('InventoryRecord').doc(invList[i]['InventoryID'].toString()).update(invList[i]);
      }
      catch(e){
        print('Error editing data at ${invList[i]['InventoryID']} : $e');
        return "Error : $e";
      }
    }

    return '';
  }

  static Future<String> updateInvDetails(Map<String, dynamic> updateMap) async {
    if(updateMap['InventoryID'] == null){
      return 'Error: updateMap is Null';
    }
    
    int invId = updateMap['InventoryID'];

    try{
      updateMap['Keywords'] = generateKeywords([updateMap['ProductName']]);
      await db.collection('InventoryRecord').doc(invId.toString()).update(updateMap);
    }
    catch(e){
      print('Error editing data : $e');
      return "Error : $e";
    }

    return '';
  }


  static Future<String> addInvDetails(Map<String, dynamic> invDetailsMap) async {
    String newInvIdStr = await getLatestInvID();
    if(newInvIdStr.isEmpty || newInvIdStr == ''){
      print("Failed to get latest Inventory ID");
      print(newInvIdStr);
      return "System Error : Failed to get latest Inventory ID";
    }
    else{
      int newInvId = int.parse(newInvIdStr);
      newInvId++;

      invDetailsMap['InventoryID'] = newInvId;

      invDetailsMap['Keywords'] = generateKeywords([invDetailsMap['ProductName']]);

      try{
        await db.collection("InventoryRecord").doc(newInvId.toString()).set(invDetailsMap);
      }
      catch(e){
        print('Error adding user to database : $e');
        return "Error : $e";
      }
    }
    return '';

  }


  static Future<int> getProductIdByNameAsInt(String name) async {
    int id = 0;
    try{
      QuerySnapshot query = await db.collection('Product').where('ProductName', isEqualTo: name).get();

      id = query.docs.first['ProductID'] as int;

    }
    catch(e){
      print('Error getting Product ID: $e');
    }

    return id;
  }



  static Future<Map<String, dynamic>> getProductMapByName(String name) async {
    Map<String, dynamic> returnMap = {};
    // ignore: unnecessary_null_comparison
    if(name != null){
      try{
        QuerySnapshot query = await db.collection('Product').where('ProductName', isEqualTo: name).get();

        returnMap = query.docs.first.data() as Map<String, dynamic>;

      }
      catch(e){
        print('Error getting Manager List : $e');
      }
    }

    return returnMap;
  }



  static Future<List<Map<String, dynamic>>> getProductListMap() async {
    List<Map<String, dynamic>> productList = [];
    try{
      QuerySnapshot query = await db.collection('Product').where('Status', isEqualTo: 'Active').get();

      query.docs.forEach((DocumentSnapshot document){
        Map<String, dynamic>productMap = document.data() as Map<String, dynamic>;
        productList.add(productMap);
      });
    }
    catch(e){
      print('Error getting Manager List : $e');
    }

    return productList;
  }



    // get a list of active products
  static Future<List<String>> getProductList() async {
    List<String> productList = [];
    try{
      QuerySnapshot query = await db.collection('Product').where('Status', isEqualTo: 'Active').get();

      query.docs.forEach((DocumentSnapshot document){
        String productName = document['ProductName'] as String;
        productList.add(productName);
      });
    }
    catch(e){
      print('Error getting Product List : $e');
    }

    return productList;
  }

  static Future<bool> checkHasProduct(String productName, int outletID) async {
    QuerySnapshot query = await db.collection('InventoryRecord')
    .where('OutletID', isEqualTo: outletID)
    .where('ProductName', isEqualTo: productName)
    .get();

    return query.docs.isNotEmpty;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// supplier methods

  static Stream<QuerySnapshot> getSupplierSnapshot() {
    return db.collection('Supplier').snapshots();
  }


  static Future<int> getSupplierIdByName(String name) async {
    QuerySnapshot query = await getSupplierByNameQuery(name);

    int supplierId = 0;

    try{
      supplierId = query.docs.first['SupplierID'] as int;
    }
    catch(e){
      print(e);
      return 0;
    }

    return supplierId;
  }

  static Future<int> getSupplierIdByEmail(String email) async {
    QuerySnapshot query = await getSupplierByEmailQuery(email);

    int supplierId = 0;

    try{
      supplierId = query.docs.first['SupplierID'] as int;
    }
    catch(e){
      print(e);
      return 0;
    }

    return supplierId;
  }


  static Future<List<String>> getSupplierList() async {
    List<String> supplierList = [];
    try{
      QuerySnapshot query = await db.collection('Supplier').get();

      query.docs.forEach((DocumentSnapshot document){
        String supplierEmail = document['SupplierName'] as String;
        supplierList.add(supplierEmail);
      });
    }
    catch(e){
      print('Error getting supplier List : $e');
    }

    return supplierList;
  }


  static Future<Map<String, dynamic>> getProductSupplierByIDAsMap(int psID) async {
    QuerySnapshot query = await db.collection('ProductSupplier').where('ProductSupplierID', isEqualTo: psID).get();

    if(query.docs.isNotEmpty){
      return query.docs.first.data() as Map<String, dynamic>;
    }
    else{
      return {};
    }
  }

  static Future<List<String>> getUnusedSupplierList(int productId) async {
    // gets supplier list that hasn't been used by a product yet
    List<String> supplierList = [];

    QuerySnapshot squery = await db.collection("Supplier").get();

    QuerySnapshot psquery = await db.collection("ProductSupplier").get();


    List<Map<String, dynamic>> smaplist= squery.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    List<Map<String, dynamic>> psmaplist= psquery.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();


    for(int i = 0; i < smaplist.length; i++){
      bool found = false;
      for(int j = 0; j < psmaplist.length; j++){
        if(
        smaplist[i]['SupplierID'] == psmaplist[j]['SupplierID'] && 
        psmaplist[j]['ProductID'] == productId
        ){
          found = true;
          break;
        }
      }

      if(!found){
        supplierList.add(smaplist[i]['SupplierName']);
      }

    }

    return supplierList;
  }

  
  static Future<QuerySnapshot> getSupplierByNameQuery(String name) async {
    QuerySnapshot querySnapshot = await db.collection('Supplier').where('SupplierName', isEqualTo: name).get();
    return querySnapshot;
  }


  static Future<int> getCrespondingProductSupplier(int productid, int supplierid) async {
    QuerySnapshot querySnapshot = await db.collection('ProductSupplier')
    .where('ProductID', isEqualTo: productid)
    .where('SupplierID', isEqualTo: supplierid)
    .get();
    return querySnapshot.docs.first['ProductSupplierID'];
  }


  static Future<QuerySnapshot> getSupplierByEmailQuery(String email) async {
    QuerySnapshot querySnapshot = await db.collection('Supplier').where('SupplierEmail', isEqualTo: email).get();
    return querySnapshot;
  }

  static Future<String> getLatestSupplierID() async{
    try{
      
      QuerySnapshot query = await db.collection("Supplier").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        // int userid = query.docs.first['UserID'];
        String supplierid = query.docs.first.id;
        return supplierid;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest supplier ID : $e');
      return '';
    }
  }



  static Future<bool> checkIsProductSupplier(int productid, int supplierid) async {
    QuerySnapshot query = await db.collection('ProductSupplier')
    .where('ProductID', isEqualTo: productid)
    .where('SupplierID', isEqualTo: supplierid)
    .get();

    return query.docs.isNotEmpty;
  }

  static Future<bool> checkHasSupplierName(String name) async {
    QuerySnapshot query = await db.collection('Supplier').where('SupplierName', isEqualTo: name).get();

    return query.docs.isNotEmpty;
  }


  static Future<bool> checkHasSupplierEmail(String email) async {
    QuerySnapshot query = await db.collection('Supplier').where('SupplierEmail', isEqualTo: email).get();

    return query.docs.isNotEmpty;
  }


  static Future<String> addSupplierDetails(Map<String, dynamic> supplierMap) async {
    String newSupplierIdStr = await getLatestSupplierID();

    if(newSupplierIdStr.isEmpty || newSupplierIdStr == ''){
      print("Failed to get latest SupplierID");
      print(newSupplierIdStr);
      return "System Error : Failed to get latest SupplierID";
    }
    else{

      if(await checkHasSupplierEmail(supplierMap['SupplierEmail'])){
        return "Error : Supplier Email already exists";
      };

      if(await checkHasSupplierName(supplierMap['SupplierName'])){
        return "Error : Supplier name already exists";
      };

      int newSupplierId = int.parse(newSupplierIdStr);
      newSupplierId++;

      supplierMap['SupplierID'] = newSupplierId;

      try{
        await db.collection("Supplier").doc(newSupplierId.toString()).set(supplierMap);
      }
      catch(e){
        print('Error adding user to database : $e');
        return "Error : $e";
      }
    }
    return '';



  }


  static Future<String> addProductSupplierDetails(Map<String, dynamic> psmap) async {
    String newpsidstr = await getLatestProductSupplierID();
    if(newpsidstr.isEmpty || newpsidstr == ''){
      print("Failed to get latest PSID");
      return "System Error : Failed to get latest PSID";
    }
    else{

      int newpsid = int.parse(newpsidstr);
      newpsid++;

      psmap['ProductSupplierID'] = newpsid;

      try{

        await db.collection("ProductSupplier").doc(newpsid.toString()).set(psmap);
      }
      catch(e){
        print('Error adding Product Supplier to database : $e');
        return "Error : $e";
      }
    }
    return '';
  }

  static Future<void> removeProductSupplier(int supplierId, int productId) async {
    QuerySnapshot query = await db.collection('ProductSupplier').where('SupplierID', isEqualTo: supplierId).where('ProductID', isEqualTo: productId).get();

    if(query.docs.isNotEmpty){
      DocumentReference documentReference = db.collection('ProductSupplier').doc(query.docs.first.id);

      await documentReference.delete();
      print('ProductSupplier Successfully Deleted');
    }
    else{
      print('ProductSupplier Deletion failed');
    }

  }


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// purchase methods


  static Stream<QuerySnapshot> getPurchaseSnapshot() {
    
    return db.collection('Purchase').orderBy('PurchaseTimestamp', descending: true).where('Status', isEqualTo: 'Pending').snapshots();
  }


  static Future<bool> checkPurchaseComplete(int purchaseid) async {
    List<Map<String, dynamic>> itemlist = [];
    try{
      QuerySnapshot query = await db.collection('PurchaseItem')
      .where('PurchaseID', isEqualTo: purchaseid)
      .where('Counted', isEqualTo: false)
      .get();

      query.docs.forEach((DocumentSnapshot document){
        Map<String, dynamic>itemMap = document.data() as Map<String, dynamic>;
        itemlist.add(itemMap);
      });
    }
    catch(e){
      print('Error getting Purchase Item List : $e');
    }

    if(itemlist.isEmpty){
      return true;
    }
    else{
      return false;
    }

  }



  static Stream<QuerySnapshot> getPurchaseSearchSnapshot({String searchTerm = '', String? statusFilter,  bool? descending}) {
    final result;

    if(statusFilter != null && statusFilter != ''){
      // if status filter is on 

      if(descending != null && descending){
        // if descending is on

        if(statusFilter == 'Pending'){
          //show all that are not hidden 
          result = db.collection('Purchase')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: 'Pending')
          .orderBy('PurchaseTimestamp', descending: true).snapshots();
        }
        else if(statusFilter == 'Complete'){
          //show all that are hidden 
          result = db.collection('Purchase')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: 'Complete')
          .orderBy('PurchaseTimestamp', descending: true).snapshots();
        }
        else{
          // show all
          result = db.collection('Purchase')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('PurchaseTimestamp', descending: true).snapshots();
        }


      }
      else{
        // descending off

        if(statusFilter == 'Pending'){
          //show all that are not hidden 
          result = db.collection('Purchase')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: 'Pending')
          .orderBy('PurchaseTimestamp').snapshots();
        }
        else if(statusFilter == 'Complete'){
          //show all that are hidden 
          result = db.collection('Purchase')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Status', isEqualTo: 'Complete')
          .orderBy('PurchaseTimestamp').snapshots();
        }
        else{
          // show all
          result = db.collection('Purchase')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('PurchaseTimestamp').snapshots();
        }
        // if descending is off 

      }
    

    }
    else{


      // if both filters are off
      if(descending != null && descending){
        // if descending is on
        result = db.collection('Purchase')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .where('Status', isEqualTo: 'Pending')
        .orderBy('PurchaseTimestamp', descending: true).snapshots();
      }
      else if(descending != null && !descending){
        // if descending is off 
        result = db.collection('Purchase')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .where('Status', isEqualTo: 'Pending')
        .orderBy('PurchaseTimestamp').snapshots();
      }
      else{
        result = db.collection('Purchase')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .where('Status', isEqualTo: 'Pending')
        .orderBy('PurchaseTimestamp', descending: true).snapshots();
      }

    }

    return result;

  }


  static Future<String> getLatestPurchaseID() async{
    try{
      
      QuerySnapshot query = await db.collection("Purchase").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        // int userid = query.docs.first['UserID'];
        String pid = query.docs.first.id;
        return pid;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest Purchase ID : $e');
      return '';
    }
  }


  static Future<String> getLatestPurchaseItemID() async{
    try{
      
      QuerySnapshot query = await db.collection("PurchaseItem").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        // int userid = query.docs.first['UserID'];
        String pid = query.docs.first.id;
        return pid;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest Purchase Item ID : $e');
      return '';
    }
  }

  static Future<String> addPurchaseDetails(Map<String, dynamic> purchaseDetailsMap) async {
    String newPurchaseIdStr = await getLatestPurchaseID();
    if(newPurchaseIdStr.isEmpty || newPurchaseIdStr == ''){
      print("Failed to get latest Purchase ID");
      print(newPurchaseIdStr);
      return "System Error : Failed to get latest Purchase ID";
    }
    else{
      int newPurchaseId = int.parse(newPurchaseIdStr);
      newPurchaseId++;

      purchaseDetailsMap['PurchaseID'] = newPurchaseId;
      purchaseDetailsMap['Keywords'] = generateKeywords([newPurchaseId.toString()],);

      try{
        await db.collection("Purchase").doc(newPurchaseId.toString()).set(purchaseDetailsMap);
      }
      catch(e){
        print('Error adding Purchase to database : $e');
        return "Error : $e";
      }
    }
    return '';

  }



  static Future<String> updatePurchaseDetails(Map<String, dynamic> updateMap) async {
    if(updateMap['PurchaseID'] == null){
      return 'Error: updateMap is Null';
    }
    
    int purchaseID = updateMap['PurchaseID'];

    try{
      await db.collection('Purchase').doc(purchaseID.toString()).update(updateMap);
    }
    catch(e){
      print('Error editing data : $e');
      return "Error : $e";
    }

    return '';
  }



  static Future<List<Map<String,dynamic>>> getOutletPurchaseAsMapList(int outletid) async {
    List<Map<String,dynamic>> list = [];
    try{
      QuerySnapshot query = await db.collection('Purchase')
      .where('OutletID', isEqualTo: outletid)
      .get();

      query.docs.forEach((DocumentSnapshot document){
        Map<String, dynamic> outletmap = document.data() as Map<String, dynamic>;
        list.add(outletmap);
      });
    }
    catch(e){
      print('Error getting purchase list : $e');
    }

    return list;
  }



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// purchaseitem methods

  static Future<List<Map<String, dynamic>>> getCrespondingPurchaseItem(int purchaseid) async {
    List<Map<String, dynamic>> itemlist = [];
    try{
      QuerySnapshot query = await db.collection('PurchaseItem').where('PurchaseID', isEqualTo: purchaseid).get();

      query.docs.forEach((DocumentSnapshot document){
        Map<String, dynamic>itemMap = document.data() as Map<String, dynamic>;
        itemlist.add(itemMap);
      });
    }
    catch(e){
      print('Error getting Manager List : $e');
    }

    return itemlist;
  }


  static Future<String> addPurchaseItemDetails(Map<String, dynamic> piDetailsMap) async {
    String newPiIdStr = await getLatestPurchaseItemID();
    if(newPiIdStr.isEmpty || newPiIdStr == ''){
      print("Failed to get latest Purchase Item ID");
      print(newPiIdStr);
      return "System Error : Failed to get latest Purchase Item ID";
    }
    else{
      int newPiId = int.parse(newPiIdStr);
      newPiId++;

      piDetailsMap['PurchaseItemID'] = newPiId;

      try{
        await db.collection("PurchaseItem").doc(newPiId.toString()).set(piDetailsMap);
      }
      catch(e){
        print('Error adding Purchase Item to database : $e');
        return "Error : $e";
      }
    }
    return '';

  }


  static Future<String> updatePurchaseItemDetails(Map<String, dynamic> updateMap) async {
    if(updateMap['PurchaseItemID'] == null){
      return 'Error: updateMap is Null';
    }
    
    int purchaseItemID = updateMap['PurchaseItemID'];

    print(updateMap);

    try{
      await db.collection('PurchaseItem').doc(purchaseItemID.toString()).update(updateMap);
    }
    catch(e){
      print('Error editing data : $e');
      return "Error : $e";
    }

    return '';
  }





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// stock movement methods



  static Stream<QuerySnapshot> getStockMvmtSnapshot() {
    return db.collection('StockMovement').orderBy('MovementTimestamp', descending: true).snapshots();
  }


  static Future<List<Map<String,dynamic>>> getStockMvmtOfOutletAsMapList(int outletid) async {
    //get stock in
    List<Map<String,dynamic>> list = [];
    try{
      QuerySnapshot query = await db.collection('StockMovement')
      .where('OutletID', isEqualTo: outletid)
      .where('isIn', isEqualTo: true)
      .get();

      query.docs.forEach((DocumentSnapshot document){
        Map<String, dynamic> outletmap = document.data() as Map<String, dynamic>;
        list.add(outletmap);
      });
    }
    catch(e){
      print('Error getting OutletIDs : $e');
    }

    return list;
  }


  static Future<List<Map<String,dynamic>>> getStockMvmtOfOutletPAsMapList(int outletid) async {
    // get purchase in
    List<Map<String,dynamic>> list = [];
    try{
      QuerySnapshot query = await db.collection('StockMovement')
      .where('OutletID', isEqualTo: outletid)
      .where('Type', isEqualTo: 'Purchase')
      .get();

      query.docs.forEach((DocumentSnapshot document){
        Map<String, dynamic> outletmap = document.data() as Map<String, dynamic>;
        list.add(outletmap);
      });
    }
    catch(e){
      print('Error getting OutletIDs : $e');
    }

    return list;
  }



  static Future<String> getLatestStockMvmtID() async{
    try{
      
      QuerySnapshot query = await db.collection("StockMovement").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        // int userid = query.docs.first['UserID'];
        String reqid = query.docs.first.id;
        return reqid;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest Stock Movement ID : $e');
      return '';
    }
  }



  static Future<String> addStockMvmtDetails(Map<String, dynamic> addMap) async {
    String newMvmtIdStr = await getLatestStockMvmtID();
    if(newMvmtIdStr.isEmpty || newMvmtIdStr == ''){
      print("Failed to get latest Stock Movement ID");
      print(newMvmtIdStr);
      return "System Error : Failed to get latest Stock Movement ID";
    }
    else{
      int newMvmtId = int.parse(newMvmtIdStr);
      newMvmtId++;

      addMap['StockMovementID'] = newMvmtId;
      addMap['Keywords'] = generateKeywords([addMap['ProductName']]);

      try{
        await db.collection("StockMovement").doc(newMvmtId.toString()).set(addMap);
      }
      catch(e){
        print('Error adding movement record to database : $e');
        return "Error : $e";
      }
    }
    return '';

  }



  static Stream<QuerySnapshot> getMvmtSearchSnapshot({String searchTerm = '', String? statusFilter,  bool? descending}) {
    final result;

    if(statusFilter != null && statusFilter != ''){
      // if status filter is on 

      if(descending != null && descending){
        // if descending is on

        if(statusFilter == 'Purchase'){
          //show all that are not hidden 
          result = db.collection('StockMovement')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Type', isEqualTo: 'Purchase')
          .orderBy('MovementTimestamp', descending: true).snapshots();
        }
        else if(statusFilter == 'Outlet'){
          //show all that are hidden 
          result = db.collection('StockMovement')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Type', isEqualTo: 'Outlet')
          .orderBy('MovementTimestamp', descending: true).snapshots();
        }
        else if(statusFilter == 'Stock In'){
          //show all that are hidden 
          result = db.collection('StockMovement')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('isIn', isEqualTo: true)
          .orderBy('MovementTimestamp', descending: true).snapshots();
        }
        else if(statusFilter == 'Stock Out'){
          //show all that are hidden 
          result = db.collection('StockMovement')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('isIn', isEqualTo: false)
          .orderBy('MovementTimestamp', descending: true).snapshots();
        }
        else{
          // show all
          result = db.collection('StockMovement')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('MovementTimestamp', descending: true).snapshots();
        }


      }
      else{
        // descending off

        if(statusFilter == 'Purchase'){
          //show all that are not hidden 
          result = db.collection('StockMovement')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Type', isEqualTo: 'Purchase')
          .orderBy('MovementTimestamp').snapshots();
        }
        else if(statusFilter == 'Outlet'){
          //show all that are hidden 
          result = db.collection('StockMovement')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('Type', isEqualTo: 'Outlet')
          .orderBy('MovementTimestamp').snapshots();
        }
        else if(statusFilter == 'Stock In'){
          //show all that are hidden 
          result = db.collection('StockMovement')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('isIn', isEqualTo: true)
          .orderBy('MovementTimestamp').snapshots();
        }
        else if(statusFilter == 'Outlet'){
          //show all that are hidden 
          result = db.collection('StockMovement')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .where('isIn', isEqualTo: false)
          .orderBy('MovementTimestamp').snapshots();
        }
        else{
          // show all
          result = db.collection('StockMovement')
          .where('Keywords', arrayContains: searchTerm.toLowerCase())
          .orderBy('MovementTimestamp').snapshots();
        }
        // if descending is off 

      }
    

    }
    else{


      // if both filters are off
      if(descending != null && descending){
        // if descending is on
        result = db.collection('StockMovement')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .orderBy('MovementTimestamp', descending: true).snapshots();
      }
      else if(descending != null && !descending){
        // if descending is off 
        result = db.collection('StockMovement')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .orderBy('MovementTimestamp').snapshots();
      }
      else{
        result = db.collection('StockMovement')
        .where('Keywords', arrayContains: searchTerm.toLowerCase())
        .orderBy('MovementTimestamp', descending: true).snapshots();
      }

    }

    return result;

  }


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// request stock methods



  static Stream<QuerySnapshot> getRequestSnapshot() {
    return db.collection('RequestStock').where('Status', isEqualTo: 'Pending').snapshots();
  }

  static Stream<QuerySnapshot> getMyRequestSnapshot() {
    return db.collection('RequestStock')
    .where('Hidden', isEqualTo: false)
    .orderBy('Status')
    .snapshots();
  }


  static Future<String> updateRequestDetails(Map<String, dynamic> updateMap) async {
    if(updateMap['RequestStockID'] == null){
      return 'Error: updateMap is Null';
    }
    
    int requestId = updateMap['RequestStockID'];

    try{
      await db.collection('RequestStock').doc(requestId.toString()).update(updateMap);
    }
    catch(e){
      print('Error editing data : $e');
      return "Error : $e";
    }

    return '';
  }

  static Future<int> getNumberOfRequests(int outletid) async {
    QuerySnapshot query = await db.collection('RequestStock')
    .where('Hidden', isEqualTo: false)
    .where('ToOutletID', isEqualTo: outletid)
    .orderBy('Status')
    .get();

    int returnint = query.docs?.length??0;

    return returnint;
  }


  static Future<String> getLatestRequestStockID() async{
    try{
      
      QuerySnapshot query = await db.collection("RequestStock").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        // int userid = query.docs.first['UserID'];
        String reqid = query.docs.first.id;
        return reqid;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest inventory ID : $e');
      return '';
    }
  }


  static Future<String> addRequestDetails(Map<String, dynamic> requestDetailsMap) async {
    String newReqIdStr = await getLatestRequestStockID();
    if(newReqIdStr.isEmpty || newReqIdStr == ''){
      print("Failed to get latest Request Stock ID");
      print(newReqIdStr);
      return "System Error : Failed to get latest Request Stock ID";
    }
    else{
      int newReqId = int.parse(newReqIdStr);
      newReqId++;

      requestDetailsMap['RequestStockID'] = newReqId;

      try{
        await db.collection("RequestStock").doc(newReqId.toString()).set(requestDetailsMap);
      }
      catch(e){
        print('Error adding request to database : $e');
        return "Error : $e";
      }
    }
    return '';

  }


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// loss methods


  static Future<String> getLatestLossID() async{
    try{
      
      QuerySnapshot query = await db.collection("Loss").orderBy(FieldPath.documentId, descending: true).limit(1).get();

      if(query.docs.isNotEmpty){
        // int userid = query.docs.first['UserID'];
        String id = query.docs.first.id;
        return id;
      }
      else{
        return '';
      }
    } catch(e){
      print('Error getting latest loss ID : $e');
      return '';
    }
  }

  static Future<String> addLossDetails(Map<String, dynamic> lossMap) async {
    String newLossIdStr = await getLatestLossID();
    if(newLossIdStr.isEmpty || newLossIdStr == ''){
      print("Failed to get latest Loss ID");
      print(newLossIdStr);
      return "System Error : Failed to get latest Loss ID";
    }
    else{
      int newLossId = int.parse(newLossIdStr);
      newLossId++;

      lossMap['LossID'] = newLossId;

      try{
        await db.collection("Loss").doc(newLossId.toString()).set(lossMap);
      }
      catch(e){
        print('Error adding loss record to database : $e');
        return "Error : $e";
      }
    }
    return '';

  }


  static Future<List<Map<String,dynamic>>> getLossOfOutletAsListMap(int outletid) async {
    //get stock in
    List<Map<String,dynamic>> list = [];
    try{
      QuerySnapshot query = await db.collection('Loss')
      .where('OutletID', isEqualTo: outletid)
      .get();

      query.docs.forEach((DocumentSnapshot document){
        Map<String, dynamic> outletmap = document.data() as Map<String, dynamic>;
        list.add(outletmap);
      });
    }
    catch(e){
      print('Error getting Loss List : $e');
    }

    return list;
  }



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// permission methods


  static Future<Map<String, dynamic>> getRolePermissionAsMap(String role) async{
    QuerySnapshot query= await db.collection('Permissions').where('Role', isEqualTo: role).get();

    if(query.docs.isNotEmpty){
      return query.docs.first.data() as Map<String, dynamic>;
    }
    else{
      return {};
    }
  }


  static Future<String> updatePermDetails(Map<String, dynamic> updateMap) async {
    if(updateMap['PermID'] == null){
      return 'Error: updateMap is Null';
    }
    
    int permid = updateMap['PermID'];

    try{
      await db.collection('Permissions').doc(permid.toString()).update(updateMap);
    }
    catch(e){
      print('Error editing data : $e');
      return "Error : $e";
    }

    return '';
  }


}

class FirebaseStorageMethods{



  static Future<String> uploadUserImage(File file, String fileName) async {
    String downloadURL = '';
    try{
      Reference storageReference = storage.ref().child('user/$fileName/$fileName.jpg');

      UploadTask uploadTask = storageReference.putFile(file);
      
      await uploadTask.whenComplete(() => print('File uploaded successfully'));

      downloadURL = await storageReference.getDownloadURL();
    }
    catch(e){
      print("Error : $e");
      downloadURL = '';
    }

    return downloadURL;
  }


  static Future<String> uploadProductImage(File file, String fileName) async {
    String downloadURL = '';
    try{
      Reference storageReference = storage.ref().child('product/$fileName/$fileName.jpg');

      UploadTask uploadTask = storageReference.putFile(file);
      
      await uploadTask.whenComplete(() => print('File uploaded successfully'));

      downloadURL = await storageReference.getDownloadURL();
    }
    catch(e){
      print("Error : $e");
      downloadURL = '';
    }

    return downloadURL;
  }

}

class DeviceIOMethods{

  static Future<File?> pickImageFromGallery() async {
    final returnedImg = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnedImg != null){
      return File(returnedImg.path);
    }
    else{
      return null;
    }
  }

  static Future<File?> pickImageFromCamera() async {
    final returnedImg = await ImagePicker().pickImage(source: ImageSource.camera);
    if(returnedImg != null){
      return File(returnedImg.path);
    }
    else{
      return null;
    }
  }

}

