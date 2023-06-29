import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp/auth_controller.dart';
import 'package:gp/doctor_form.dart';
import 'package:gp/personal_info.dart';

import 'HRM/constants.dart';
import 'intropages/onbording_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? Key}) : super(key: Key);
  static var emailController = TextEditingController();
  static var passwordController = TextEditingController();
  // static TextEditingController _emailController = TextEditingController();
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  List<String> roles = ['Patient', 'Doctor'];
  String selectedItem = 'Patient';



  // static var emailController = TextEditingController();
  // static var passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // TextEditingController _emailController = TextEditingController();
  bool _showEmailError = false;

  // @override
  // void dispose() {
  //   SignUpPage.emailController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: w,
                height: h * 0.7,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("img/saud logo 2.png"),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                width: w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign up with us",
                      style: appText(
                          color: Colors.black,
                          isShadow: false,
                          weight: FontWeight.bold,
                          size: 38),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome to SHC",
                      style: appText(
                          color: Colors.grey,
                          isShadow: false,
                          weight: FontWeight.bold,
                          size: 20),
                    ),
                    SizedBox(
                      height: 35,
                    ),
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
                        controller: SignUpPage.emailController,
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
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 7,
                                offset: Offset(1, 1),
                                color: Colors.grey.withOpacity(0.35))
                          ]),
                      child: TextField(
                        controller: SignUpPage.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: appText(
                                color: Colors.grey,
                                isShadow: false,
                                weight: FontWeight.w600,
                                size: 14),
                            prefixIcon:
                            Icon(Icons.password, color: Colors.indigo),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.0)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sign up as   ",
                            style: appText(
                                color: Colors.grey,
                                isShadow: false,
                                weight: FontWeight.w600,
                                size: 20),
                          ),
                          DropdownButton<String>(
                            value: selectedItem,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedItem = newValue!;
                              });
                            },
                            items: roles.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),


              SizedBox(height: 30 ,),
              GestureDetector(
                onTap: () async {
                  if (SignUpPage.emailController.text.trim().isNotEmpty && SignUpPage.passwordController.text.trim().isNotEmpty && selectedItem=='Patient') {
                   var registerd =  AuthController.instance.register(SignUpPage.emailController.text.trim(), SignUpPage.passwordController.text.trim());
                   if (await registerd) {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => PersonalInfo()),
                     );
                   }
                  }else if(SignUpPage.emailController.text.trim().isNotEmpty && SignUpPage.passwordController.text.trim().isNotEmpty && selectedItem=='Doctor'){
                    var registerd = AuthController.instance.register(SignUpPage.emailController.text.trim(), SignUpPage.passwordController.text.trim());
                 if (await registerd) {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => DoctorForm()),
                   );
                 }
                  }
                  else {
                    // show a message to the user that email and password are required
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please Enter a Correct Email and Password.')),
                    );
                  }
                },
                child: Container(
                  width: w * 0.5,
                  height: h * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      image: AssetImage("img/saud logo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Sign up",
                      style: appText(
                          color: Colors.white,
                          isShadow: false,
                          weight: FontWeight.w600,
                          size: 30),
                    ),
                  ),
                ),
              ),
              SizedBox(height:w*0.05),
              RichText(text: TextSpan(
                  text: "You have an account? ",
                  style: appText(
                      color: Colors.grey,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 18),
                  children: [
                    TextSpan(
                        text: " Sign in",
                        style: appText(
                            color: Colors.black,
                            isShadow: false,
                            weight: FontWeight.w600,
                            size: 18),
                        recognizer: TapGestureRecognizer()..onTap=() {
                          Navigator.of(context).pop();
                        }
                    )
                  ]
              )
              ),




              SizedBox(height:w*0.1),
              // RichText(text: TextSpan(
              //     text: "Sign up as a Medical Practitioner",
              //     style: TextStyle(
              //         color: Colors.grey[500],
              //         fontSize: 20
              //     ),
              //     children: [
              //       TextSpan(
              //           text: " Click",
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 20,
              //               fontWeight: FontWeight.bold
              //           ),
              //           recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>MsignupPage())
              //       )
              //     ]
              // )
              // )
            ],
          ),
        ),
      ),
    );
  }
}