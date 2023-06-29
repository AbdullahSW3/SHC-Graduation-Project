import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withOpacity(0.8),
              Colors.white,
            ],
            stops: [0.2, 0.8],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Lottie.network(
                'https://assets9.lottiefiles.com/private_files/lf30_mvurfbs7.json',
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  SizedBox(height: 0),
                  Text(
                    '''   A Model That Predicts\n  diseases based on your\n      given symptoms!  ''',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
