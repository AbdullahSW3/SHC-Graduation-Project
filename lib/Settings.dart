import 'package:flutter/material.dart';
// import 'package:flutter_application_1/profile.dart';
import 'package:get/get.dart';
import 'package:gp/forgot_pw_page.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'HRM/constants.dart';
import 'ProfileScreen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        title:  Text('Settings', style: appText(
            color: Colors.white,
            isShadow: false,
            weight: FontWeight.bold,
            size: 20)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade400,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 33,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Account",
                    style: appText(
                        color: Colors.black,
                        isShadow: false,
                        weight: FontWeight.bold,
                        size: 25)),
              ],
            ),
            Divider(
              height: 20,
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOption(context, "Change Password"),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.blue,
                  size: 33,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "General",
                    style: appText(
                        color: Colors.black,
                        isShadow: false,
                        weight: FontWeight.bold,
                        size: 25)),

              ],
            ),
            Divider(
              height: 20,
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOption(context, "Language"),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
                style: appText(
                    color: Colors.grey.shade700,
                    isShadow: false,
                    weight: FontWeight.bold,
                    size: 18)),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
