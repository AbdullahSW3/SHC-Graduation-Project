import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_model.dart';


class UserRepositry{

final _db= FirebaseFirestore.instance;






  Future<UserModel> getUserDetails(String email) async{
    final snapshot= await _db.collection("users").where("email",isEqualTo: email).get();
    final userdata= snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userdata;
  }
Future<List<UserModel>> allUser() async{
  final snapshot= await _db.collection("users").get();
  final userdata= snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
  return userdata;
}

Future<void> updateUserRecord(UserModel user)async{
 await _db.collection("users").doc(user.id).update(user.toJason());
}
}