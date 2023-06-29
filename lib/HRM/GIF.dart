import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp/HRM/pages/test_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:camera/camera.dart';

import 'constants.dart';

class GIF extends StatefulWidget {
  const GIF({Key? key}) : super(key: key);

  @override
  State<GIF> createState() => _GIFState();
}

class _GIFState extends State<GIF> {
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    loadCamera();
    super.initState();

  }

  Future<void> loadCamera() async {
    cameras = await availableCameras();
  }

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
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Heart Rate measures your heart rate by analyzing the color changes in blood flow from the tip of your finger.',textAlign: TextAlign.center,
              style: appText(
                  color: Colors.black,
                  isShadow: false,
                  weight: FontWeight.normal,
                  size: 16),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 200,
              height: 200,
              child: Image.asset(
                'img/tutorial.gif',
                fit: BoxFit.cover,
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Gently place the tip of your finger on the top camera lens so it completely covers the lens.\n Hold your phone steady throughout the reading.',textAlign: TextAlign.center,
              style: appText(
                  color: Colors.black,
                  isShadow: false,
                  weight: FontWeight.normal,
                  size: 16),
            ),
          ),
          SizedBox(height: 30),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestScreen(cameras: cameras)),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo,  // Set the background color
                borderRadius: BorderRadius.circular(8),  // Set the border radius
              ),
              padding: EdgeInsets.all(16),  // Set the padding around the text
              child: Text(
                'Start here!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

