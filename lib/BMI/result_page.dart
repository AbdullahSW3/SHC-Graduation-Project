// import 'package:bmi_calculator_app/Components/BottomContainer_Button.dart';
// import 'package:bmi_calculator_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import '../Components/Reusable_Bg.dart';
import '../HRM/constants.dart';
import 'components/BottomContainer_button.dart';
import 'components/reusable_bg.dart';
import 'constants.dart';

class ResultPage extends StatelessWidget {
  final String resultText;
  final String bmi;
  final String advise;
  final Color textColor;

  ResultPage(
      {required this.textColor,
        required this.resultText,
        required this.bmi,
        required this.advise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI",style: appText(
            color: Colors.white,
            isShadow: false,
            weight: FontWeight.bold,
            size: 20)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade400,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            LineAwesomeIcons.angle_left,
            size: 35,
          ),
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Expanded(
          //   child: Container(
          //     padding: EdgeInsets.all(15.0),
          //     alignment: Alignment.bottomCenter,
          //     child: Text(
          //       'Your Result',
          //       style: ktitleTextStyle,
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 5,
            child: ReusableBg(
              colour: Colors.indigo.shade400,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      resultText,
                      style: appText(
                          color: textColor,
                          isShadow: false,
                          weight: FontWeight.bold,
                          size: 25)),
                  Text(
                    bmi,
                    style: kBMITextStyle,
                  ),
                  Text(
                      'Normal BMI range:', style: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.normal,
                      size: 16)),
                  Text(
                      '18.5 - 25 kg/m2',
                      style: appText(
                          color: Colors.white,
                          isShadow: false,
                          weight: FontWeight.normal,
                          size: 16)),
                  Text(
                      advise,
                      textAlign: TextAlign.center,
                      style: appText(
                          color: Colors.white,
                          isShadow: false,
                          weight: FontWeight.normal,
                          size: 16)
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  // RawMaterialButton(
                  //   onPressed: () {},
                  //   constraints: BoxConstraints.tightFor(
                  //     width: 200.0,
                  //     height: 56.0,
                  //   ),
                  //   fillColor: Color(0xFF4C4F5E),
                  //   elevation: 0.0,
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10.0)),
                  //   child: Text(
                  //     'SAVE RESULT',
                  //     style: kBodyTextStyle,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          BottomContainer(
              text: 'RE-CALCULATE',
              onTap: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}