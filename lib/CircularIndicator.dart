// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:gp/doctor_model.dart';
// import 'package:gp/login_page.dart';
// import 'package:gp/profile_controller.dart';
// import 'package:gp/user_model.dart';
//
// // import 'HomePage/HomePage.dart';
// import 'HomePage/mHomePage.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'CircularIndicator Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SplashScreen(),
//       routes: {
//         '/home': (context) => MHomePage(),
//       },
//     );
//   }
// }
//
// class SplashScreen extends StatefulWidget {
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// final formKey = GlobalKey<FormState>();
// Future<UserModel>? userData;
// final controller = Get.put(ProfileController());
// // @override
// // void initState(){
// //   userData=controller.getUserData();
// //   super.initState();
// // }
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     signIn(loginpage.emailController.text.trim(), loginpage.passwordController.text.trim());
//     _startTimer();
//   }
//
//   void _startTimer() {
//     Timer(Duration(seconds: 2), () {
//       Navigator.pushReplacementNamed(context, '/home');
//     });
//   }
//
//   void route() {
//     User? user = FirebaseAuth.instance.currentUser;
//     var kk = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user!.uid)
//         .get()
//         .then((DocumentSnapshot documentSnapshot) {
//       if (documentSnapshot.exists) {
//         if (documentSnapshot.get('role') == "user") {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const MHomePage(),
//             ),
//           );
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const MHomePage(),
//             ),
//           );
//         }
//       } else {
//         print('Document does not exist on the database');
//       }
//     });
//   }
//
//   void signIn(String email, String password) async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//
//       ),
//     );
//   }
// }
//
//
// // class HomePage extends StatelessWidget {
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('hello'),
// //       ),
// //
// //       body: SingleChildScrollView(
// //       child: Container(
// //     padding: const EdgeInsets.all(25),
// //     // )
//     // // child: FutureBuilder(
//     // //   future: userData,
//     // //   builder: (context, snapshot) {
//     // //     if (snapshot.connectionState == ConnectionState.done){
//     // // if (snapshot.hasData) {
//     // //   UserModel user = snapshot.data as UserModel;
//     // //   DoctorModel doctor = snapshot.data as DoctorModel;
//     // //
//     // // }
//     // //     }doctor
//     // },
//     // ),
// //     ),
// //       ),
// //     );
// //   }
// // }
