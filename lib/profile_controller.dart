

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp/user_model.dart';
import 'package:gp/user_repositry.dart';

import 'auth_controller.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  //controllers
  final name=TextEditingController();
  final email=TextEditingController();
  final phone=TextEditingController();
  final sosname=TextEditingController();
  final sosphone=TextEditingController();



  final _authrepo = Get.put(AuthController());

  final _userrepo = Get.put(UserRepositry());

  getUserData(){
  final email = _authrepo.firebaseUser.value?.email;
  if(email != null){
    return _userrepo.getUserDetails(email);
  }else{
    Get.snackbar("Error", "Login to continue");
  }
  }

  updateRecord(UserModel user)async{
   await _userrepo.updateUserRecord(user);
  }
}