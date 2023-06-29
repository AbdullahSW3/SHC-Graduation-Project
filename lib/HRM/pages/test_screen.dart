// ignore_for_file: must_be_immutable, depend_on_referenced_packages, prefer_const_constructors

import 'package:breathing_collection/breathing_collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gp/HRM/constants.dart';
import 'package:gp/HRM/pages/background.dart';
import 'package:camera/camera.dart';
import 'package:gp/HRM/pages/main_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TestScreen extends StatefulWidget {
  TestScreen({Key? key, required this.cameras}) : super(key: key);
  List<CameraDescription> cameras;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
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
          title: const Text('Heart Rate'),
          elevation: 0,
          centerTitle: true,),
      backgroundColor: scaffoldColor,
      body: CustomPaint(
        painter: BacgroundPaint(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BreathingGlowingButton(
                height: 100,
                width: 100,
                buttonBackgroundColor: heartColor,
                glowColor: waveColor,
                icon: FontAwesomeIcons.heartPulse,
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                    return MainScreen(
                      cameras: widget.cameras,
                    );
                  }));
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Press to Start",
                style: appText(
                    isShadow: true,
                    color: Colors.white,
                    weight: FontWeight.w500,
                    size: 23),
              )
            ],
          ),
        ),
      ),
    );
  }
}