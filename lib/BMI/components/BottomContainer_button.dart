import 'package:flutter/material.dart';

import '../../HRM/constants.dart';
import '../constants.dart';
// import 'constants.dart';

class BottomContainer extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  BottomContainer({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFEB1555),
              borderRadius: BorderRadius.circular(50.0), // Adjust the border radius as desired
            ),
            margin: EdgeInsets.only(top: 10.0),
            height: 80.0,
            padding: EdgeInsets.only(bottom: 1.0),
            child: Center(
              child: Text(
                text,
                  style: appText(
              color: Colors.white,
                  isShadow: false,
                  weight: FontWeight.bold,
                  size: 22)),
            ),
          ),
        ),
      ),
    );
  }
}
