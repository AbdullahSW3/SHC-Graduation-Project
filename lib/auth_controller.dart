import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp/HomePage/HomePage.dart';
import 'package:gp/personal_info.dart';

import 'HomePage/mHomePage.dart';
import 'login_page.dart';

class AuthController extends GetxController{
//Authcontroller.instance..
  static AuthController instance =Get.find();
  //email, password , name....
  late Rx<User?> firebaseUser = Rx<User?>(null);//
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady(){
    super.onReady();
    firebaseUser= Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser,_initialScreen);
  }

  _initialScreen(User? user) async {
    await Future.delayed(const Duration(seconds: 1));
    if(user==null){
      Get.offAll(()=>loginpage());
    }else{
      String? userEmail = FirebaseAuth.instance.currentUser!.email;
      CollectionReference usersRef = firestore.collection('users');
      CollectionReference doctorsRef = docfirestore.collection('doctors');
      Query query = usersRef.where('email', isEqualTo: userEmail);
      Query docquery = doctorsRef.where('email', isEqualTo: userEmail);
      QuerySnapshot querySnapshot = await query.get();
      QuerySnapshot docquerySnapshot = await docquery.get();
      if (querySnapshot.docs.isNotEmpty) {
        Get.offAll(() => HomePage());
      }else if (docquerySnapshot.docs.isNotEmpty){
        Get.offAll(() => mHomePage());
      }
    }
  }
  Future<bool> register(String email, password)async{
  try{
  await auth.createUserWithEmailAndPassword(email: email, password: password);
  return true;
  }catch(e){
 Get.snackbar("about User", "User message",
 backgroundColor: Colors.redAccent,
 snackPosition: SnackPosition.BOTTOM,
   titleText: const Text(
     "Account creation failed",
     style: TextStyle(
       color: Colors.white
     ),
   ),
     messageText: Text(
       e.toString().replaceAll(RegExp(r"\[.*?\]"), "").trim(),
       style: const TextStyle(color: Colors.white),
     )
 );
 return false;
}
  }
  void login(String email, password)async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      Get.snackbar("about Login", "Login message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Login failed",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          messageText: Text(
            e.toString().replaceAll(RegExp(r"\[.*?\]"), "").trim(),
            style: const TextStyle(color: Colors.white),
          )
      );
    }
  }
  void logout()async{
    await auth.signOut();
  }
  var isLoggedIn = false.obs;

  Future<bool> gptlogin(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      Get.snackbar("about Login", "Login message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Login Failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString().replaceAll(RegExp(r"\[.*?\]"), "").trim(),
            style: const TextStyle(color: Colors.white),
          ));
      return false;
    }
  }

}



//we need to wrap the sign out button with a widget (gestureDetector) from 40:00 second video



