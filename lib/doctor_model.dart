
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorModel {
  final String? id;
  final String? name;
  final String email;
  final int age;
  final int phone;
  final String city;
  final String country;
  final String gender;

  const DoctorModel({
    this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.phone,
    required this.city,
    required this.country,
    required this.gender,
  });

  toJason(){
    return {
      "name": name,
      "email": email,
      "age": age,
      "phone": phone,
      "city": city,
      "country": country,
      "gender": gender,
     };
  }

  factory DoctorModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    final data=document.data()!;
    return DoctorModel(
      id:document.id,
      email: data["email"],
      name: data["name"],
      age: data["age"],
      phone: data["phone"],
      city: data["city"],
      country: data["country"],
      gender: data["gender"],
    );
  }

}