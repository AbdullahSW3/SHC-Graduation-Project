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

class MedicalRecord extends StatefulWidget {
  const MedicalRecord({Key? key}) : super(key: key);

  @override
  State<MedicalRecord> createState() => _MedicalRecordState();
}

int selectedPersonIndex = 0;
final firestore = FirebaseFirestore.instance;
Future<List<Map<String, dynamic>>?> doThis(List<Map<String, dynamic>> allData, List<String> documentIds) async {
  String? userPhone;
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference usersRef = firestore.collection('users');
  Query query = usersRef.where('email', isEqualTo: userEmail);
  QuerySnapshot querySnapshot = await query.get();
  querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<
        String,
        dynamic>?;
    allData.add(userData!);
    userPhone = userData!['phone'];
  }
  Query sosQuery = usersRef.where('sosphone', isEqualTo: userPhone);
  QuerySnapshot sosQuerySnapshot = await sosQuery.get();
  for (int i = 0; i < sosQuerySnapshot.size; i++) {
    if (sosQuerySnapshot.docs.isNotEmpty) {
      Map<String, dynamic>? sosData = sosQuerySnapshot.docs[i].data() as Map<
          String,
          dynamic>?;
      allData.add(sosData!);

    }
  }
  return allData;
}



class _MedicalRecordState extends State<MedicalRecord> {
  List<Map<String, dynamic>> allData = [];
  Map<String, dynamic>? userData;
  bool isLoading = true;
  List<String> documentIds = [];
  String chronicDiseases = '';
  bool FirstTime = true;
  bool meSlidable = true;
  bool iAmaDoctor = false;
  String? hisProfilepic;


  @override
  void initState() {
    if (FirstTime) {
      meSlidable = true;
      isLoading = true;
      Future.delayed(Duration(milliseconds: 150), () {
        doThis(allData, documentIds).then((allData) {
          setState(() {
            userData = allData![0];
            hisProfilepic = userData!["profile_image"];
            if (userData!['Chronic Diseases'] != null) {
              chronicDiseases = userData!['Chronic Diseases'];
              if (chronicDiseases == '[]') {
                chronicDiseases = 'None';
              } else {
                chronicDiseases = chronicDiseases.replaceAll('others', '');
                chronicDiseases = chronicDiseases
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .split(',')
                    .map((disease) => disease.trim())
                    .join(', ');

                if (userData?['Other Chronic Diseases'] != '') {
                  chronicDiseases =
                      chronicDiseases + userData?['Other Chronic Diseases'];
                }

                // Replace the last comma with "and"
                final lastCommaIndex = chronicDiseases.lastIndexOf(',');
                if (lastCommaIndex != -1) {
                  chronicDiseases = chronicDiseases.replaceRange(
                    lastCommaIndex,
                    lastCommaIndex + 1,
                    ' and',
                  );
                }
              }
            } else {
              chronicDiseases = "None";
            }
            isLoading = false;
            FirstTime = false;
          });
        });
      });
      super.initState();
    } else {
      setState(() {
        meSlidable = false;
        userData = allData![selectedPersonIndex];
        hisProfilepic = userData!["profile_image"];
        if (userData!['Chronic Diseases'] != null) {
          chronicDiseases = userData!['Chronic Diseases'];
          if (chronicDiseases == '[]') {
            chronicDiseases = 'None';
          } else {
            chronicDiseases = chronicDiseases.replaceAll('others', '');
            chronicDiseases = chronicDiseases
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((disease) => disease.trim())
                .join(', ');

            if (userData?['Other Chronic Diseases'] != '') {
              chronicDiseases =
                  chronicDiseases + userData?['Other Chronic Diseases'];
            }

            // Replace the last comma with "and"
            final lastCommaIndex = chronicDiseases.lastIndexOf(',');
            if (lastCommaIndex != -1) {
              chronicDiseases = chronicDiseases.replaceRange(
                lastCommaIndex,
                lastCommaIndex + 1,
                ' and',
              );
            }
          }
        } else {
          chronicDiseases = "None";
        }
        isLoading = false;
        FirstTime = false;
      });
    }
  }

  void _DeleteDialog(String documentId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text(
                'Are you sure you want to permanently delete this prediction?'),
            actions: [
              Row(
                children: [
                  SizedBox(width: 120),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No',
                      style: TextStyle(color: Colors.red, fontSize: 16.0,),),
                  ),

                  TextButton(
                    onPressed: () {
                      firestore.collection('diagnosis')
                          .doc(documentId)
                          .delete();
                      Navigator.pop(context);
                    },
                    child: Text('Yes', style: TextStyle(fontSize: 16.0,)),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void _showNameEditDialog(String documentId, String currentName) {
    String newName = currentName;
    final TextEditingController textEditingController =
    TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: SingleChildScrollView(
            child: TextField(
              onChanged: (value) {
                if (value != '') {
                  newName = value;
                }
              },
              controller: textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a Text',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    textEditingController.clear();
                  },
                ),
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                SizedBox(width: 135),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Update the name value in Firestore
                    firestore.collection('diagnosis').doc(documentId).update({
                      'name': newName,
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        );
      },
    );
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
        title: Text('Medical ID', style: appText(
            color: Colors.white,
            isShadow: false,
            weight: FontWeight.bold,
            size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          Visibility(
            visible: iAmaDoctor != true,
            child: IconButton(
              onPressed: () {},
              icon: PopupMenuButton<int>(
                itemBuilder: (BuildContext context) {
                  return List<PopupMenuEntry<int>>.generate(
                    allData.length,
                        (index) =>
                        PopupMenuItem<int>(
                          value: index,
                          child: index != 0 ? Text(allData[index]['name'] ,
                              style: appText(
                                  color: Colors.black,
                                  isShadow: false,
                                  weight: FontWeight.normal,
                                  size: 16)) : Text(
                              allData[index]['name'] + " (me)", style: appText(
                              color: Colors.black,
                              isShadow: false,
                              weight: FontWeight.normal,
                              size: 16)),
                        ),
                  );
                },
                onSelected: (value) {
                  // Handle the selected value based on the index
                  if (value >= 0 && value < allData.length) {
                    setState(() {
                      selectedPersonIndex = value;
                      initState();
                    });
                  }
                },
              ),
            ),
          ),
        ],

      ),
      body: Stack(
        children: [
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
          else
            Center(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(9.0),
                    child: (hisProfilepic == "" || hisProfilepic == null)
                        ? CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 40.0,
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.white,
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(hisProfilepic!),
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
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
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
                                      padding: EdgeInsets.zero,
                                      // Remove unwanted padding
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
                                                              weight: FontWeight
                                                                  .w600,
                                                              size: 14)),
                                                      TextSpan(
                                                        text: calculateAge(
                                                            userData?['age']),
                                                        style: appText(
                                                          color: Colors.black,
                                                          isShadow: false,
                                                          weight: FontWeight.w600,
                                                          size: 14,
                                                        ),
                                                      ),
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
                                                              weight: FontWeight
                                                                  .w600,
                                                              size: 14)),
                                                      TextSpan(
                                                          text: '${userData?['gender'] ??
                                                              ''}',
                                                          style: appText(
                                                              color: Colors.black,
                                                              isShadow: false,
                                                              weight: FontWeight
                                                                  .w600,
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
                        SizedBox(height: 15),
                        // Add space between the two containers
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Height: ',
                                                  style: appText(
                                                      color: Colors.grey,
                                                      isShadow: false,
                                                      weight: FontWeight.w600,
                                                      size: 14)),
                                              TextSpan(
                                                  text: '${userData?['height'] ??
                                                      ''}',
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
                                                  text: 'Weight: ',
                                                  style: appText(
                                                      color: Colors.grey,
                                                      isShadow: false,
                                                      weight: FontWeight.w600,
                                                      size: 14)),
                                              TextSpan(
                                                  text: '${userData?['weight'] ??
                                                      ''}',
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
                                            text: 'Blood Type: ',
                                            style: appText(
                                                color: Colors.grey,
                                                isShadow: false,
                                                weight: FontWeight.w600,
                                                size: 14)),
                                        TextSpan(
                                            text: '${userData?['blood type'] ??
                                                ''}',
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
                                            text: '${userData?['country'] ??
                                                ''}, ${userData?['city'] ?? ''}',
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
                                            text: 'Chronic diseases: ',
                                            style: appText(
                                                color: Colors.grey,
                                                isShadow: false,
                                                weight: FontWeight.w600,
                                                size: 14)),
                                        TextSpan(
                                            text: '$chronicDiseases',
                                            style: appText(
                                                color: Colors.black,
                                                isShadow: false,
                                                weight: FontWeight.w600,
                                                size: 12)),
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
                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    // Adjust the padding values as needed
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                        "Previous Predictions",
                        style: appText(
                            color: Colors.black,
                            isShadow: false,
                            weight: FontWeight.w600,
                            size: 24)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: StreamBuilder(
                        stream: firestore.collection('diagnosis').snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          List data = !snapshot.hasData
                              ? []
                              : snapshot.data!.docs
                              .where((element) =>
                          element['docID']
                              .toString()
                              .toLowerCase()
                              .contains(documentIds[0]) ||
                              element['email']
                                  .toString()
                                  .toLowerCase()
                                  .contains(userData!['email']))
                              .toList()
                            ..sort((a, b) {
                              Timestamp timestampA = a['time'];
                              Timestamp timestampB = b['time'];
                              // Sort in descending order (newest first), modify the comparison logic if needed
                              return timestampB.compareTo(timestampA);
                            });

                          if (data.isEmpty) {
                            return Center(
                              child: Text(
                                'No Previous Predictions',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, i) {
                                  final documentId = data[i]
                                      .id; // Document ID in Firestore

                                  if (selectedPersonIndex == 0 || meSlidable ||
                                      iAmaDoctor != true) {
                                    return Slidable(
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) =>
                                                _DeleteDialog(documentId),
                                            backgroundColor: Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                          // SlidableAction(
                                          //   onPressed: (context) =>
                                          //       _showNameEditDialog(
                                          //           documentId, data[i]['name']),
                                          //   backgroundColor: Colors.blueAccent,
                                          //   foregroundColor: Colors.white,
                                          //   icon: Icons.edit,
                                          //   label: 'Edit',
                                          // ),
                                        ],
                                      ),
                                      child: ChatWidgets.Card3(
                                        context,
                                        title: data[i]['name'],
                                        time: data[i]['time'],
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/medicalrecord',
                                            arguments: {
                                              'Diseases': data[i]['disease'],
                                              'Symptoms': data[i]['symptoms'],
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return ChatWidgets.Card3(
                                      context,
                                      title: data[i]['name'],
                                      time: data[i]['time'],
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/medicalrecord',
                                          arguments: {
                                            'Diseases': data[i]['disease'],
                                            'Symptoms': data[i]['symptoms'],
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
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
