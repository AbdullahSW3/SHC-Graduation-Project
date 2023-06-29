import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 33, 16, 184).withOpacity(0.8),
              Colors.white,
            ],
            stops: const [0.2, 0.8],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Lottie.network(
                'https://assets3.lottiefiles.com/packages/lf20_u9iuhxut.json',
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: const [
                  SizedBox(height: 0),
                  Text(
                    'Your Health Is Our Priority!',
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
