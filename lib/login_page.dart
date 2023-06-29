// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'HRM/constants.dart';
import 'HomePage/HomePage.dart';
import 'package:gp/HomePage/mHomePage.dart';
import 'package:gp/auth_controller.dart';
import 'package:gp/profile_controller.dart';
import 'package:gp/signup_page.dart';
import 'package:gp/user_model.dart';
import 'forgot_pw_page.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();

  @override
  State<loginpage> createState() => _loginpageState();
}
List<String> roles=['Patient','Medical Practitioner'];
String? selectedItem='Patient';
class _loginpageState extends State<loginpage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formkey=GlobalKey<FormState>();
  Future<UserModel>? userData;
  final controller = Get.put(ProfileController());
  bool isLoading = false;

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

  Future<bool> checkDoctorEmailExists() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userEmail = user.email ?? '';
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('email', isEqualTo: userEmail)
          .get();

      return querySnapshot.docs.isNotEmpty;
    }

    return false;
  }

  @override
  void initState(){
    // userData=controller.getUserData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    key:_formkey;
// userData=controller.getUserData();
    bool _obscureText = true;
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,

      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: w,
                height: h*0.7,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "img/saud logo 2.png"
                        ),
                        fit: BoxFit.cover
                    )
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20,right: 20),
                width: w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: appText(
                          color: Colors.black,
                          isShadow: false,
                          weight: FontWeight.bold,
                          size: 60),
                    ),
                    Text(
                      "Sign into your account",
                      style: appText(
                          color: Colors.grey,
                          isShadow: false,
                          weight: FontWeight.w600,
                          size: 20),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow:[
                            BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 7,
                                offset: Offset(1,1),
                                color: Colors.grey.withOpacity(0.35)
                            )
                          ]
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: appText(
                                color: Colors.grey,
                                isShadow: false,
                                weight: FontWeight.w600,
                                size: 14),
                            prefixIcon: Icon(Icons.email, color: Colors.indigo),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow:[
                            BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 7,
                                offset: Offset(1,1),
                                color: Colors.grey.withOpacity(0.35)
                            )
                          ]
                      ),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: appText(
                                color: Colors.grey,
                                isShadow: false,
                                weight: FontWeight.w600,
                                size: 14),
                            prefixIcon: Icon(Icons.password, color: Colors.indigo),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0
                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                            );
                          },
                          child: Text(
                            "Forgot your password ?  ",
                            style: appText(
                                color: Colors.grey,
                                isShadow: false,
                                weight: FontWeight.w600,
                                size: 17),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              SizedBox(height: 33 ,),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true; // Show the circular progress indicator
                  });

                  bool loginSuccessful = await AuthController.instance.gptlogin(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  bool emailExists = await checkUserEmailExists();
                  bool doctoremailExists = await checkDoctorEmailExists();
                  if (loginSuccessful) {
                    if (emailExists) {
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        isLoading = false; // Hide the circular progress indicator
                      });// Delay for 2 seconds
                      Get.lazyPut<HomePage>(
                            () => HomePage(),
                      );
                    } else if(doctoremailExists){
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        isLoading = false; // Hide the circular progress indicator
                      });// Delay for 2 seconds
                      Get.lazyPut<mHomePage>(
                            () => mHomePage(),
                      );
                    }
                  }
                  setState(() {
                    isLoading = false; // Hide the circular progress indicator
                  });
                },
                child: Container(
                  width: w*0.5,
                  height: h*0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: AssetImage(
                              "img/saud logo.png"
                          ),
                          fit: BoxFit.cover
                      )
                  ),
                  child:isLoading? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 1,
                    ),
                  ): Center(
                    child: Text(
                      "Sign in",
                      style: appText(
                          color: Colors.white,
                          isShadow: false,
                          weight: FontWeight.w600,
                          size: 30),
                    ),
                  ),
                ),
              ),

              SizedBox(height:w*0.08),
              RichText(text: TextSpan(
                  text: "Don\'t have an account?",
                style: appText(
                    color: Colors.grey,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 18),
                  children: [
                    TextSpan(
                        text: " Create",
                style: appText(
                    color: Colors.black,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 18),
                        recognizer: TapGestureRecognizer()..onTap=(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpPage()),
                          );
                        })

                  ]
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}

// void route() {
//   User? user = FirebaseAuth.instance.currentUser;
//   var kk = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user!.uid)
//       .get()
//       .then((DocumentSnapshot documentSnapshot) {
//     if (documentSnapshot.exists) {
//       if (documentSnapshot.get('rool') == "Teacher") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>  HomePage(),
//           ),
//         );
//       }else{
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>  MHomePage(),
//           ),
//         );
//       }
//     } else {
//       print('Document does not exist on the database');
//     }
//   });
// }
// void signIn(String email, String password) async {
//   if (_formkey.currentState!.validate()) {
//     try {
//       UserCredential userCredential =
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       route();
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//       }
//     }
//   }
// }


