import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'HRM/constants.dart';

class MUpdateProfile extends StatefulWidget {
  const MUpdateProfile({Key? key}) : super(key: key);

  @override
  _MUpdateProfileState createState() => _MUpdateProfileState();
}

class _MUpdateProfileState extends State<MUpdateProfile> {

  // Future<bool> checkUserPhoneExists() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     String? userUID = user.uid;
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('uid', isEqualTo: userUID)
  //         .where('phone', isNotEqualTo: null)
  //         .limit(1)
  //         .get();
  //
  //     return querySnapshot.docs.isNotEmpty;
  //   }
  //
  //   return false;
  // }

  Future<bool> checkUserPhoneExists(String phone) async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('phone', isEqualTo: phone)
          .get();

      return querySnapshot.docs.isNotEmpty;
    }

    return false;
  }

  // Future<bool> checkUserPhoneExists(String phone) async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     String? userUID = user.uid;
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('uid', isEqualTo: userUID)
  //         .where('phone', isEqualTo: phone)
  //         .limit(1)
  //         .get();
  //
  //     return querySnapshot.docs.isNotEmpty;
  //   }
  //
  //   return false;
  // }




  final firestore = FirebaseFirestore.instance;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController LTypeController;
  late TextEditingController LNumberController;
  // late TextEditingController sosRelationController;
  // late TextEditingController sosheightController;
  // late TextEditingController sosweightController;
  late String validatephone;
  late String FBphone;

  Future<Map<String, dynamic>?> loadUserData(List<String> documentIds) async {
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    CollectionReference usersRef = firestore.collection('doctors');
    Query query = usersRef.where('email', isEqualTo: userEmail);
    QuerySnapshot querySnapshot = await query.get();
    querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic>? userData =
      querySnapshot.docs[0].data() as Map<String, dynamic>?;
      nameController.text = userData?['name'] ?? '';
      emailController.text = userData?['email'] ?? '';
      phoneController.text = "${userData?['phone'] ?? ''}";
      LTypeController.text = userData?['License type'] ?? '';
      LNumberController.text = "${userData?['License Number'] ?? ''}";
      // sosheightController.text = "${userData?['height'] ?? ''}";
      // sosweightController.text = "${userData?['weight'] ?? ''}";
      FBphone= "${userData?['phone'] ?? ''}";
      return userData;
    }
    return null;
  }
  bool isLoading = true;
  List<String> documentIds = [];
  bool name = false;
  bool phone = false;
  bool LTypebool = false;
  bool LNumberbool = false;
  bool sosrelation = false;
  bool height = false;
  bool weight = false;
  String IV='';
  Map<String, dynamic>? userdata;
  @override
  void initState() {
    isLoading = true;
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    LTypeController = TextEditingController();
    LNumberController = TextEditingController();
    IV = "loading...";
      // sosheightController = TextEditingController();
    // sosweightController = TextEditingController();
    
    loadUserData(documentIds).then((userData) {
      userdata = userData;
    IV = userdata!['License type'];
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }
  String _selectedLType = '';
  String? _dbSelectedLType;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    IV = userdata!["License type"];
    return Scaffold(
      appBar:AppBar(
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
        title: Text('Edit Your Profile',style: appText(
            color: Colors.white,
            isShadow: false,
            weight: FontWeight.w600,
            size: 20)),
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '    Full Name',
                    style:appText(
                        color: Colors.black,
                        isShadow: false,
                        weight: FontWeight.normal,
                        size: 16)),
              ),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  // labelText: "Full Name",
                  hintText: "Ahmed Alturki",
                  hintStyle: appText(
                      color: Colors.grey,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16),
                  prefixIcon: Icon(LineAwesomeIcons.alternate_user),
                ),
                validator: (value) {
                  if (value!.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value))
                  {
                    name = true;
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // TextFormField(
              //   controller: emailController,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(100),
              //       borderSide: BorderSide(color: Colors.black),
              //     ),
              //     labelText: "Email",
              //     hintText: "@gmail.com",
              //     prefixIcon: Icon(Icons.mail),
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
              //       return "Please Enter Correct email";
              //     } else {
              //       return null;
              //     }
              //   },
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '     Phone',
                    style:appText(
                        color: Colors.black,
                        isShadow: false,
                        weight: FontWeight.normal,
                        size: 16)),
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  // labelText: "Phone",
                  hintText: "05xxxxxxxx",
                  hintStyle: appText(
                      color: Colors.grey,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value){
                  if (value!.isEmpty || !RegExp(r'^\d{3}-\d{3}-\d{4}$').hasMatch(value)) {
                    phone = true;
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),


              // TextFormField(
              //   controller: sosheightController,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(100),
              //       borderSide: BorderSide(color: Colors.black),
              //     ),
              //     labelText: "Height",
              //     hintText: "in CM",
              //     prefixIcon: Icon(Icons.accessibility),
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty ||
              //         !RegExp(r'^(8[0-9]|9[0-9]|1[0-9][0-9]|2[0-2][0-9]|230)$').hasMatch(value)) {
              //       height = true;
              //     }
              //   },
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // TextFormField(
              //   controller: sosweightController,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(100),
              //       borderSide: BorderSide(color: Colors.black),
              //     ),
              //     labelText: "Weight",
              //     hintText: "in KG",
              //     prefixIcon: Icon(Icons.accessibility),
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty ||
              //         !RegExp(r'^(3[0-9]{2}|[1-2][0-9]{2}|30)$').hasMatch(value)) {
              //       weight = true;
              //     }
              //   },
              // ),
              const SizedBox(
                height: 0,
              ),



              SingleChildScrollView(
                // child: Card(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '    License Type',
                            style:appText(
                                color: Colors.black,
                                isShadow: false,
                                weight: FontWeight.normal,
                                size: 16)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.card_travel_sharp
                                  ,color:Colors.grey), // Icon on the far left
                              SizedBox(width: 10.0), // Add some spacing between the icon and dropdown
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  // value: IV, // Let the dropdown take available width
                                  decoration: InputDecoration(
                                    hintText: LTypeController.text,
                                    hintStyle: appText(
                                        color: Colors.black,
                                        isShadow: false,
                                        weight: FontWeight.normal,
                                        size: 16),
                                    border: InputBorder.none, // Remove the border from the dropdown
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedLType = newValue!;
                                      _dbSelectedLType = newValue;
                                    });
                                    // Do something with the selected value
                                  },
                                  items: <String>[
                                    'Acupuncturist',
                                    'Allergist/Immunologist',
                                    'Anesthesiologist',
                                    'Art Therapist',
                                    'Biochemist',
                                    'Biomedical Engineer',
                                    'Biostatistician',
                                    'Cardiologist',
                                    'Cardiothoracic Surgeon',
                                    'Certified Nursing Assistant (CNA)',
                                    'Clinical Nurse Specialist',
                                    'Clinical Pharmacologist',
                                    'Clinical Psychologist',
                                    'Clinical Research Associate',
                                    'Clinical Social Worker',
                                    'Cytotechnologist',
                                    'Dental Hygienist',
                                    'Dentist',
                                    'Dermatologist',
                                    'Dialysis Technician',
                                    'Dietetic Technician',
                                    'Emergency Medicine Physician',
                                    'Endocrinologist',
                                    'EKG Technician',
                                    'Exercise Physiologist',
                                    'Family Physician',
                                    'Forensic Pathologist',
                                    'Forensic Scientist',
                                    'Gastroenterologist',
                                    'General Practitioner (GP)',
                                    'General Surgeon',
                                    'Geneticist',
                                    'Geriatrician',
                                    'Health Information Manager',
                                    'Hematologist',
                                    'Immunologist',
                                    'Infectious Disease Specialist',
                                    'Internal Medicine Physician',
                                    'Medical Assistant',
                                    'Medical Billing Specialist',
                                    'Medical Coder',
                                    'Medical Ethicist',
                                    'Medical Illustrator',
                                    'Medical Laboratory Technologist',
                                    'Medical Librarian',
                                    'Medical Office Manager',
                                    'Medical Physicist',
                                    'Medical Secretary',
                                    'Medical Transcriptionist',
                                    'Medical Writer',
                                    'Neurologist',
                                    'Neurosurgeon',
                                    'Nurse Anesthetist',
                                    'Nurse Practitioner',
                                    'Nutritionist/Dietitian',
                                    'Occupational Therapist',
                                    'Oncologist',
                                    'Ophthalmologist',
                                    'Optician',
                                    'Optometrist',
                                    'Oral and Maxillofacial Surgeon',
                                    'Orthodontist',
                                    'Orthopedic Surgeon',
                                    'Orthopedic Technician',
                                    'Otolaryngologist (ENT Specialist)',
                                    'Paramedic',
                                    'Pediatric Dentist',
                                    'Pediatrician',
                                    'Pharmacy Technician',
                                    'Pharmacist',
                                    'Phlebotomist',
                                    'Physical Therapist',
                                    'Physiotherapist',
                                    'Plastic Surgeon',
                                    'Podiatrist',
                                    'Prosthetic Technician',
                                    'Prosthetist/Orthotist',
                                    'Psychiatrist',
                                    'Pulmonologist',
                                    'Radiation Oncologist',
                                    'Radiologist',
                                    'Registered Nurse (RN)',
                                    'Rehabilitation Counselor',
                                    'Respiratory Therapist',
                                    'Rheumatologist',
                                    'Sleep Technologist',
                                    'Speech-Language Pathologist',
                                    'Sports Medicine Physician',
                                    'Surgical Technologist',
                                    'Telemedicine Physician',
                                    'Toxicologist',
                                    'Transplant Coordinator',
                                    'Urologist',
                                    'Veterinary Surgeon',
                                    'Veterinary Technician', // List of license types
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == 'None') {
                                      return 'Please select a License type';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ),
              ),






              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '    License Number',
                    style:appText(
                        color: Colors.black,
                        isShadow: false,
                        weight: FontWeight.normal,
                        size: 16)),
              ),
              TextFormField(
                controller: LNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  // labelText: "License Number",
                  hintText: "7352846",
                  hintStyle: appText(
                      color: Colors.grey,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^\d{3}-\d{3}-\d{4}$').hasMatch(value)) {
                    LNumberbool = true;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),



              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Update the user's profile
                        validatephone = phoneController.text;
                        if (await checkUserPhoneExists(validatephone) && FBphone != validatephone) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Phone Already Exists'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (nameController.text.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please Enter a Correct name'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (phoneController.text.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(phoneController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please Enter a Correct Phone'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                          // } else if (LTypeController.text.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(LTypeController.text)) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text('Please Enter a Correct an License Type'),
                          //       duration: const Duration(seconds: 2),
                          //       backgroundColor: Colors.red,
                          //     ),
                          //   );
                        } else if (LNumberController.text.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(LNumberController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please Enter a Correct an License Number'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                          // } else if (sosheightController.text.isEmpty) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text('Please Enter a Correct Height'),
                          //       duration: const Duration(seconds: 2),
                          //     ),
                          //   );
                          // } else if (LNumberController.text.isEmpty) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text('Please Enter a Correct Weight'),
                          //       duration: const Duration(seconds: 2),
                          //       backgroundColor: Colors.red,
                          //     ),
                          //   );
                        } else {
                          updateProfile();
                        }
                      },
                      child:  Text('Submit', style:appText(
                          color: Colors.white,
                          isShadow: false,
                          weight: FontWeight.w600,
                          size: 20)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3e4982),
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(""),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Saved Successfully",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    SizedBox(width: 135),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(""),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  Future<void> updateProfile() async {
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    CollectionReference usersRef = firestore.collection('doctors');
    Query query = usersRef.where('email', isEqualTo: userEmail);
    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      String docId = querySnapshot.docs[0].id;
      await usersRef.doc(docId).update({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'License type': _dbSelectedLType == null? IV: _dbSelectedLType,
        'License Number': int.parse(LNumberController.text),
        // 'height': double.parse(sosheightController.text),
        // 'weight': double.parse(sosweightController.text),
      });
      showSaveDialog(context);
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
  }

}
