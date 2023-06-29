import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gp/Conditions.dart';
import 'package:gp/DoctorsPage.dart';
import 'package:gp/MedicalRecordPage.dart';
import 'package:gp/Prediction/Prediction.dart';
import 'package:gp/ProfileScreen.dart';

import '../BMI/input_page.dart';
import '../ChatHomePage.dart';
import '../DoctorMedicalRecord.dart';
import '../HRM/GIF.dart';
import '../HRM/constants.dart';
import '../MChatHomePage.dart';
import '../chatscreen.dart';




class mHomePage extends StatefulWidget {
  const mHomePage({Key? key}) : super(key: key);

  @override
  State<mHomePage> createState() => _mHomePageState();
}

final docfirestore = FirebaseFirestore.instance;

Future<Map<String, dynamic>?> doThis(List<String> documentIds) async {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference usersRef = docfirestore.collection('doctors');
  Query query = usersRef.where('email', isEqualTo: userEmail);
  QuerySnapshot querySnapshot = await query.get();
  querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? userData =
    querySnapshot.docs[0].data() as Map<String, dynamic>?;
    return userData;
  }
  return null;
}

class _mHomePageState extends State<mHomePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  List<String> documentIds = [];
  String? hisProfilePic;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    doThis(documentIds).then((data) {
      setState(() {
        userData = data;
        hisProfilePic = data!["profile_image"];
        isLoading = false;
      });
    });
  }

  Future<void> refreshPage() async {
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(child: CircularProgressIndicator()):RefreshIndicator(
    onRefresh: refreshPage,
    child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    "Dr.${userData?['name'] ?? ''}",
                      style: appText(
                          color: Colors.white,
                          isShadow: false,
                          weight: FontWeight.w600,
                          size: 20),
                  ),
                  subtitle: Text(
                    'Welcome',
                    style: appText(
                        color: Colors.white54,
                        isShadow: false,
                        weight: FontWeight.w600,
                        size: 14),
                  ),
                  trailing: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                    child: (hisProfilePic == null || hisProfilePic == '')
                        ? CircleAvatar(
                      backgroundColor: Colors.grey.shade600,
                      radius: 25.0,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.white,
                      ),
                    ):
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(hisProfilePic!),
                        backgroundColor: Colors.black38,
                        radius: 25.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Container(
            color: Colors.indigo,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(350),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 40,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorMedicalRecord(id: documentIds[0])),
                      );
                    },
                    child: itemDashboard(
                      'Medical ID',
                      'img/medical1.png',
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MChatHomePage()),
                      );
                    },
                    child: itemDashboard(
                      'Chat',
                      'img/chat.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                    child: itemDashboard(
                      'My Doctor',
                      'img/chatbot.png',
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InputPage()),
                      );
                    },
                    child: itemDashboard(
                      'BMI',
                      'img/calculator.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  GIF() ));
                    },
                    child: itemDashboard(
                      'Heart Rate',
                      'img/heart.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Conditions()),
                      );
                    },
                    child: itemDashboard(
                      'Conditions',
                      'img/lamp.png',

                    ),
                  ),
                  Container(
                    color: Colors.white, // Set the background color to white
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Container(
                    color: Colors.white, // Set the background color to white
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                    ),
                  ),
                ],
              ),

            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      ),
    );
  }

  itemDashboard(String title, String imagePath) => Container(
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(1, 5),
          color: Theme.of(context).primaryColor.withOpacity(.3),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            imagePath,
            color: Colors.indigo,
            width: 60,
            height: 60,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            title,
            style: appText(
                color: Colors.black,
                isShadow: false,
                weight: FontWeight.w600,
                size: 14),
          ),
        ),
      ],
    ),
  );
}
