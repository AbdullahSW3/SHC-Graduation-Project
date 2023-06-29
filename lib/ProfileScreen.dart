

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gp/privacy.dart';
import 'package:gp/update_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'HRM/constants.dart';
import 'Mupdate_profile.dart';
import 'Settings.dart';
import 'package:path/path.dart' as Path;


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


final firestore = FirebaseFirestore.instance;
Future<Map<String, dynamic>?> doThis(List<String> documentIds,) async {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference usersRef = firestore.collection('users');
  Query query = usersRef.where('email', isEqualTo: userEmail);
  QuerySnapshot querySnapshot = await query.get();
  querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<
        String,
        dynamic>?;
    return userData;
  } else {
    CollectionReference usersRef = firestore.collection('doctors');
    Query query = usersRef.where('email', isEqualTo: userEmail);
    QuerySnapshot querySnapshot = await query.get();
    querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<
          String,
          dynamic>?;
      return userData;
    }
  }
}


class _ProfileScreenState extends State<ProfileScreen> {

  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool uploading = false;
  List<String> documentIds = [];
  String? imageUrl;
  String? hisProfilePic;
  bool isDoctor = true;
  @override
  void initState() {
    isLoading = true;
    Future.delayed(Duration(milliseconds: 150), () {
      doThis(documentIds,).then((data) {
        setState(() {
          userData = data;
          isDoctor = (data!['License type'] != null);
          hisProfilePic = data!["profile_image"];
          isLoading = false;

        });
      });

    });
    super.initState();

  }



  final ImagePicker _picker = ImagePicker();
  File? selectedImage;


  getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Upload a Profile Picture"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(width: 8.0),
                      Text("Take a Photo"),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImageFromSource(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.photo_library),
                      SizedBox(width: 8.0),
                      Text("Import From Gallery"),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImageFromSource(ImageSource.gallery);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red),
                      SizedBox(width: 8.0),
                      Text("Cancel", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Handle cancel action
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  updateImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Change Profile Picture"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(width: 8.0),
                      Text("Take a Photo"),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImageFromSource(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.photo_library),
                      SizedBox(width: 8.0),
                      Text("Import From Gallery"),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImageFromSource(ImageSource.gallery);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8.0),
                      Text("Remove Profile Picture", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removeProfilePicture();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red),
                      SizedBox(width: 8.0),
                      Text("Cancel", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Handle cancel action
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _removeProfilePicture() async {
    final _firestore = FirebaseFirestore.instance;
    final field = FieldPath(['profile_image']);
    try {
      if (isDoctor){
        _firestore
            .collection('doctors')
            .doc(documentIds[0])
            .update(
            {field: ""}); // Set the profile_image field to an empty string
        setState(() {
          selectedImage = null; // Reset the selected image
        });
      }else {
        _firestore
            .collection('users')
            .doc(documentIds[0])
            .update(
            {field: ""}); // Set the profile_image field to an empty string
        setState(() {
          selectedImage = null; // Reset the selected image
        });
      }
    } catch (e) {
      print(e);
    }
  }



  _getImageFromSource(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        storeUserPicture();
      });
    } else {
      print("Error");
    }
  }


  uploadImage(File image) async {

    imageUrl = '';
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
        (value) {
          imageUrl = value;
        }

    );
    return imageUrl;
  }


  storeUserPicture() async {
    String url = await uploadImage(selectedImage!);
    final _firestore = FirebaseFirestore.instance;
    final field = FieldPath(['profile_image']);
    try {
      if (isDoctor){
        _firestore
            .collection('doctors')
            .doc(documentIds[0])
            .update({field: url});
        setState(() {
          uploading = false;
        });
      }else {
        _firestore
            .collection('users')
            .doc(documentIds[0])
            .update({field: url});
        setState(() {
          uploading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkUserEmailExists() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userEmail = user.email ?? '';
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      return querySnapshot.docs.isNotEmpty;
    }

    return false;
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
        title:  Text('Profile', style: appText(
            color: Colors.white,
            isShadow: false,
            weight: FontWeight.bold,
            size: 20)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade400,
      ),
      body: isLoading ?
          Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: InkWell(
                      onTap: () {
                        if (selectedImage == null && (hisProfilePic == null || hisProfilePic == "")){
                          getImage();
                        }else{
                        updateImage();
                        }
                        uploading = true;
                        storeUserPicture();
                      },
                      child: (() {
                        if (uploading) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: CircleAvatar(
                              backgroundColor: Colors.black38,
                              radius: 25.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Set a different color
                                strokeWidth: 3.0, // Adjust the width of the indicator
                              ),
                            ),
                          );

                        } else if (selectedImage == null) {
                          if (hisProfilePic == null || hisProfilePic == "") {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: CircleAvatar(
                                backgroundColor: Colors.black38,
                                radius: 25.0,
                                child: Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          } else {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: CircleAvatar(
                                foregroundImage: NetworkImage(hisProfilePic!),
                                backgroundColor: Colors.black38,
                                radius: 25.0,
                              ),
                            );
                          }
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: CircleAvatar(
                              foregroundImage: FileImage(selectedImage!),
                              backgroundColor: Colors.black38,
                              radius: 25.0,
                            ),
                          );
                        }
                      })(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${userData?['name'] ?? ''}',
                  style: appText(
                      color: Colors.black,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 20),
              ),
              Text(
                '${userData?['email'] ?? ''}',
                  style: appText(
                      color: Colors.black,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 14)),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    if(await checkUserEmailExists()) {
                      Navigator.push(// a patient
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfile()),
                      );
                    }else{// a doctor
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MUpdateProfile()),
                      );
                    }
                  },
                  child: Text('Edit Profile', style: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 16)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff3e4982),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),

              //----------------------------
              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),

              ProfileMenuWidget(
                title: "Privacy and Policy",
                icon: LineAwesomeIcons.info,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()),
                  );
                },
              ),
              ProfileMenuWidget(
                title: "Log out",
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: ()
                  async => await FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ProfileMenuWidget extends StatelessWidget {
   ProfileMenuWidget({
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    super.key,
  });
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;



  @override
  Widget build(BuildContext context) {
    var iconColor = Color(0xff3e4982);
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
          style: appText(
              color: Colors.black87,
              isShadow: false,
              weight: FontWeight.w600,
              size: 14,).apply(color: textColor)
      ),
      trailing: endIcon
          ? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color(0xff3e4982).withOpacity(0.1)),
        child: Icon(
          LineAwesomeIcons.angle_right,
          size: 18,
          color: Colors.grey,
        ),
      )
          : null,
    );
  }
}
