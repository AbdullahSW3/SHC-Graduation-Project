import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gp/login_page.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'HRM/constants.dart';
import 'HomePage/HomePage.dart';

class ForgotPasswordPage extends StatefulWidget{
  const ForgotPasswordPage({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage>{
  final _emailController=TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('Password reset link sent! Check your email'),
        );
      },
      );
    } on FirebaseAuthException catch(e) {
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      },
      );
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(
            LineAwesomeIcons.angle_left,
            size: 35,
          ),
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo.shade400,
        title: Text('Password Reset', style: appText(
            color: Colors.white,
            isShadow: false,
            weight: FontWeight.w600,
            size: 20)),
        elevation: 15,
        centerTitle: true,
        toolbarHeight: 70.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter your email to receive a password reset link',
              textAlign: TextAlign.center,
                style: appText(
                    color: Colors.black87,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 20)),

          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: appText(
                    color: Colors.grey,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 14),
                prefixIcon: Icon(Icons.email, color: Colors.indigo),
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 0.7),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MaterialButton(
              onPressed: passwordReset,
              child: Text(
                'Reset Password',
                  style: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 20)),
              color: Colors.indigo,
              padding: EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),

          ),
        ],
      ),

    );
  }
}