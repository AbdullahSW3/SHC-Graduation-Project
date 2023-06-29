
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? id;
  final String? name;
  final String email;
  final int age;
  final int phone;
  final String city;
  final String country;
  final int height;
  final int weight;
  final String gender;
  final String sosname;
  final int sosphone;
  final String sosrelation;
  final String chronic_diseases;
  final String others;
  final Timestamp date_time;
  final String profile_image;

  const UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.phone,
    required this.city,
    required this.country,
    required this.height,
    required this.weight,
    required this.gender,
    required this.sosname,
    required this.sosrelation,
    required this.sosphone,
    required this.chronic_diseases,
    required this.others,
    required this.date_time,
    required this.profile_image,

  });

  toJason(){
    return {
      "name": name,
      "email": email,
      "age": age,
      "phone": phone,
      "city": city,
      "country": country,
      "height": height,
      "weight": weight,
      "gender": gender,
      "sosname": sosname,
      "sosrelation": sosrelation,
      "sosphone": sosphone,
      "Chronic Diseases": chronic_diseases,
      "Other Chronic Diseases": others,
      "date_time":date_time,
      "profile_image":profile_image
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
   final data=document.data()!;
    return UserModel(
        id:document.id,
        email: data["email"],
        name: data["name"],
         age: data["age"],
         phone: data["phone"],
         city: data["city"],
         country: data["country"],
          height: data["height"],
         weight: data["weight"],
         gender: data["gender"],
        sosname: data["sosname"],
        sosrelation: data["sosrelation"],
        sosphone: data["sosphone"],
        chronic_diseases: data["Chronic Diseases"],
        others: data["Other Chronic Diseases"],
      date_time: data["date_time"],
      profile_image: data['profile_image'],
    );
  }

}