import 'package:cloud_firestore/cloud_firestore.dart';

import 'doctor_model.dart';
import 'user_model.dart';


class DoctorRepositry{

  final _db= FirebaseFirestore.instance;






  Future<DoctorModel> getDoctorDetails(String email) async{
    final snapshot= await _db.collection("users").where("email",isEqualTo: email).get();
    final Doctordata= snapshot.docs.map((e) => DoctorModel.fromSnapshot(e)).single;
    return Doctordata;
  }
  Future<List<DoctorModel>> allUser() async{
    final snapshot= await _db.collection("users").get();
    final Doctordata= snapshot.docs.map((e) => DoctorModel.fromSnapshot(e)).toList();
    return Doctordata;
  }

  Future<void> updateDoctorRecord(UserModel user)async{
    await _db.collection("doctors").doc(user.id).update(user.toJason());
  }
}