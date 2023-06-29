import 'package:flutter/material.dart';
class IndigoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              'screen1_cleanup.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Image.asset(
              'firstscreen.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Image.asset(
              'screen1_cleanup.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

