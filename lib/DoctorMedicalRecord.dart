import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp/HomePage/HomePage.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'dart:core';

import 'ChatComp/widgets.dart';
import 'HRM/constants.dart';
import 'Prediction/PossibleDiseases.dart';

class DoctorMedicalRecord extends StatefulWidget {
  final String? id;
  const DoctorMedicalRecord({Key? key, this.id}) : super(key: key);

  @override
  State<DoctorMedicalRecord> createState() => _DoctorMedicalRecordState();
}


final firestore = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>?> doctorDoThis(List<Map<String, dynamic>> allData, List<String?> documentIds, String? id) async {

  CollectionReference usersRef = FirebaseFirestore.instance.collection('doctors');
  DocumentSnapshot docSnapshot = await usersRef.doc(id).get();

  if (docSnapshot.exists) {
    Map<String, dynamic>? userData = docSnapshot.data() as Map<String, dynamic>?;
    allData.add(userData!);
  }

  return allData;
}


class _DoctorMedicalRecordState extends State<DoctorMedicalRecord> {
  List<Map<String, dynamic>> allData = [];
  Map<String, dynamic>? userData;
  bool isLoading = true;
  List<String?> documentIds = [];
  String? hisProfilePic;

  @override
  void initState() {
    isLoading = true;
    String docId = widget!.id!;
    documentIds.add(docId);
    Future.delayed(Duration(milliseconds: 150), () {
      doctorDoThis(allData, documentIds, widget.id).then((allData) {
        setState(() {
          userData = allData![0];
          hisProfilePic = userData!["profile_image"];
          isLoading = false;
        });
      });
    });
    super.initState();

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                LineAwesomeIcons.angle_left,
                size: 35,
              ),
              color: Colors.white,
            ),
            backgroundColor: Colors.indigo.shade400,
            title:  Text("Medical Profile",style: appText(
                color: Colors.white,
                isShadow: false,
                weight: FontWeight.bold,
                size: 20)),
            elevation: 0,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(9.0),
                      child: (hisProfilePic == "" || hisProfilePic == null) ?CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 40.0,
                        child: Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.white,
                        ),
                      ): ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: CircleAvatar(
                          foregroundImage: NetworkImage(hisProfilePic!),
                          backgroundColor: Colors.black38,
                          radius: 40.0,
                        ),
                      ),
                    ),
                    Text(
                      "${userData?['name'] ?? ''}",
                        style: appText(
                            color: Colors.black,
                            isShadow: false,
                            weight: FontWeight.w600,
                            size: 20)),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 9.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 2.0,
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // First Container: Name, Age, and Gender
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [

                                      Padding(
                                        padding: EdgeInsets.zero, // Remove unwanted padding
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Age: ',
                                                            style: appText(
                                                                color: Colors.grey,
                                                                isShadow: false,
                                                                weight: FontWeight.w600,
                                                                size: 14)),
                                                        TextSpan(
                                                          text: calculateAge(
                                                              userData?['age']),
                                                            style: appText(
                                                                color: Colors.black,
                                                                isShadow: false,
                                                                weight: FontWeight.w600,
                                                                size: 14)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              child: VerticalDivider(
                                                color: Colors.grey,
                                                thickness: 1,
                                                indent: 0, // Remove top padding
                                                endIndent: 0, // Remove bottom padding
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Gender: ',
                                                            style: appText(
                                                                color: Colors.grey,
                                                                isShadow: false,
                                                                weight: FontWeight.w600,
                                                                size: 14)),
                                                        TextSpan(
                                                          text: '${userData?['gender'] ?? ''}',
                                                            style: appText(
                                                                color: Colors.black,
                                                                isShadow: false,
                                                                weight: FontWeight.w600,
                                                                size: 14)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15), // Add space between the two containers
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 2.0,
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Second Container: Address, Mobile Phone, and Chronic Diseases


                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'License Type: ',
                                              style: appText(
                                                  color: Colors.grey,
                                                  isShadow: false,
                                                  weight: FontWeight.w600,
                                                  size: 14)),
                                          TextSpan(
                                            text: '${userData?['License type'] ?? ''}',
                                              style: appText(
                                                  color: Colors.black,
                                                  isShadow: false,
                                                  weight: FontWeight.w600,
                                                  size: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Divider(
                                  color: Colors.grey,
                                  thickness: 1.0,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'License Number: ',
                                              style: appText(
                                                  color: Colors.grey,
                                                  isShadow: false,
                                                  weight: FontWeight.w600,
                                                  size: 14)),
                                          TextSpan(
                                            text: '${userData?['License Number'] ?? ''}',
                                              style: appText(
                                                  color: Colors.black,
                                                  isShadow: false,
                                                  weight: FontWeight.w600,
                                                  size: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),


                                Divider(
                                  color: Colors.grey,
                                  thickness: 1.0,
                                ),


                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Address: ',
                                              style: appText(
                                                  color: Colors.grey,
                                                  isShadow: false,
                                                  weight: FontWeight.w600,
                                                  size: 14)),
                                          TextSpan(
                                            text: '${userData?['country'] ?? ''}, ${userData?['city'] ?? ''}',
                                              style: appText(
                                                  color: Colors.black,
                                                  isShadow: false,
                                                  weight: FontWeight.w600,
                                                  size: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Divider(
                                  color: Colors.grey,
                                  thickness: 1.0,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Mobile Phone: ',
                                              style: appText(
                                                  color: Colors.grey,
                                                  isShadow: false,
                                                  weight: FontWeight.w600,
                                                  size: 14)),
                                          TextSpan(
                                            text: '${userData?['phone'] ?? ''}',
                                              style: appText(
                                                  color: Colors.black,
                                                  isShadow: false,
                                                  weight: FontWeight.w600,
                                                  size: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
      ),
    );
  }
  String calculateAge(String birthDateStr) {
    if (birthDateStr == null || birthDateStr.isEmpty) {
      return '';
    }

    DateTime now = DateTime.now();
    DateTime dateOfBirth = DateTime.parse(birthDateStr);
    int age = now.year - dateOfBirth.year;

    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    return age.toString();
  }
}