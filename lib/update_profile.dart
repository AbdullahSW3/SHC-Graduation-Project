import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'HRM/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';


class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {


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
          .collection('users')
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
  late TextEditingController sosNameController;
  late TextEditingController sosPhoneController;
  late TextEditingController sosRelationController;
  late TextEditingController sosheightController;
  late TextEditingController sosweightController;
  late String validatephone;
  late String FBphone;

  Future<void> loadUserData(List<String> documentIds) async {
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    CollectionReference usersRef = firestore.collection('users');
    Query query = usersRef.where('email', isEqualTo: userEmail);
    QuerySnapshot querySnapshot = await query.get();
    querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic>? userData =
      querySnapshot.docs[0].data() as Map<String, dynamic>?;
      nameController.text = userData?['name'] ?? '';
      emailController.text = userData?['email'] ?? '';
      phoneController.text = "${userData?['phone'] ?? ''}";
      sosNameController.text = userData?['sosname'] ?? '';
      sosPhoneController.text = "${userData?['sosphone'] ?? ''}";
      sosheightController.text = "${userData?['height'] ?? ''}";
      sosweightController.text = "${userData?['weight'] ?? ''}";
      FBphone= "${userData?['phone'] ?? ''}";
    }
    return null;
  }
  bool isLoading = true;
  List<String> documentIds = [];
  bool name = false;
  bool phone = false;
  bool sosname = false;
  bool sosphone = false;
  bool sosrelation = false;
  bool height = false;
  bool weight = false;

  @override
  void initState() {
    isLoading = true;
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    sosNameController = TextEditingController();
    sosPhoneController = TextEditingController();
    sosheightController = TextEditingController();
    sosweightController = TextEditingController();
    Future.delayed(Duration(milliseconds: 150), () {
      loadUserData(documentIds).then((allData) {

      });});
    isLoading = false;
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
                    style: appText(
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
                    return "enter the correct name";
                  }
                  return null;
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
                  '    Phone',
                  style: appText(
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
                    return "enter the correct number";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '    Height',
                  style: appText(
                      color: Colors.black,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16)),

              ),
              TextFormField(
                controller: sosheightController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  // labelText: "Height",
                  hintText: "in CM",
                  hintStyle: appText(
                      color: Colors.grey,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16),
                  prefixIcon: Icon(Icons.accessibility),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^(8[0-9]|9[0-9]|1[0-9][0-9]|2[0-2][0-9]|230)$').hasMatch(value)) {
                    height = true;
                    return "enter the correct height";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '    Weight',
                  style: appText(
                      color: Colors.black,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16)),
              ),
              TextFormField(
                controller: sosweightController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  // labelText: "Weight",
                  hintText: "in KG",
                  hintStyle: appText(
                      color: Colors.grey,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16),
                  prefixIcon: Icon(Icons.accessibility),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^(3[0-9]{2}|[1-2][0-9]{2}|30)$').hasMatch(value)) {
                    weight = true;
                    return "enter the correct weight";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '    Emergency Contact Name',
                  style:appText(
                      color: Colors.black,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16)),


              ),
              TextFormField(
                controller: sosNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  // labelText: "Emergency Contact Name",
                  hintText: "Faisal Alflan",
                  hintStyle: appText(
                      color: Colors.grey,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value!.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value))
                  {
                    sosname = true;
                    return "enter the correct name";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '    Emergency Contact Phone',
                  style: appText(
                      color: Colors.black,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16)),

              ),
              TextFormField(
                controller: sosPhoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  // labelText: "Emergency Contact Phone",
                  hintText: "05xxxxxxxx",
                  hintStyle: appText(
                      color: Colors.grey,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^\d{3}-\d{3}-\d{4}$').hasMatch(value)) {
                    sosphone = true;
                    return "enter the correct number";
                  }
                  return null;
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
                        } else if (sosNameController.text.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(sosNameController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please Enter a Correct an Emergency Contact Name'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (sosPhoneController.text.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(sosPhoneController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please Enter a Correct an Emergency Contact Phone'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (sosheightController.text.isEmpty || !RegExp(r'^(?:[1-9]\d{0,2}(?:\.\d+)?|220(?:\.0+)?)$').hasMatch(sosheightController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please Enter a Correct Height'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (sosweightController.text.isEmpty|| !RegExp(r'^(?:[1-9]\d{0,2}(?:\.\d+)?|220(?:\.0+)?)$').hasMatch(sosweightController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please Enter a Correct Weight'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          updateProfile();
                        }
                      },

                      child:  Text('Submit', style: appText(
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
    CollectionReference usersRef = firestore.collection('users');
    Query query = usersRef.where('email', isEqualTo: userEmail);
    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      String docId = querySnapshot.docs[0].id;
      await usersRef.doc(docId).update({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'sosname': sosNameController.text,
        'sosphone': sosPhoneController.text,
        'height': double.parse(sosheightController.text),
        'weight': double.parse(sosweightController.text),
      });

      showSaveDialog(context);
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
  }

}
