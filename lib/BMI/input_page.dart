// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:line_awesome_flutter/fonts';
// import '../Components/Icon_Content.dart';
// import '../Components/Reusable_Bg.dart';
// import '../Components/RoundIcon_Button.dart';
// import '../constants.dart';
// import 'Results_Page.dart';
// import '../Components/BottomContainer_Button.dart';
// import '../calculator_brain.dart';

// ignore: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp/BMI/result_page.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../HRM/constants.dart';
import 'calculate.dart';
import 'components/BottomContainer_button.dart';
import 'components/icon_contents.dart';
import 'components/reusable_bg.dart';
import 'components/roundicon_button.dart';
import 'constants.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

//ENUMERATION : The action of establishing number of something , implicit way
enum Gender {
  male,
  female,
}
late Gender selectedGender = Gender.male;
int height = 180;
int weight = 50;
int age = 20;

late int h;
final firestore = FirebaseFirestore.instance;
Future<Map<String, dynamic>?> doThis(List<String> documentIds) async {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference usersRef = firestore.collection('users');
  Query query = usersRef.where('email', isEqualTo: userEmail);
  QuerySnapshot querySnapshot = await query.get();
  querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<
        String,
        dynamic>?;
    height = (userData?['height'] ?? 0).toDouble().toInt();
    weight = (userData?['weight'] ?? 0).toDouble().toInt();
    age = (userData?['age'] ?? 0).toInt();
    return userData;
  } else {
    return null;
  }
}



class _InputPageState extends State<InputPage> {
  //by default male will be selected
  Map<String, dynamic>? userData;
  bool isLoading = true;
  List<String> documentIds = [];



  @override
  void initState(){
    isLoading=true;
    doThis(documentIds).then((data) {
      setState(() {
        userData = data;
        isLoading = false;
      });
    });
  }

  // late Gender selectedGender = Gender.male;
  // int height = 180;
  // int weight = 50;
  // int age = 20;
  //
  // late int h;

  @override
  Widget build(BuildContext context) {
    // h=userData!['height'];
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                    child: ReusableBg(
                      colour: selectedGender == Gender.male
                          ? Colors.indigo.shade400
                          : kinactiveCardColor,
                      cardChild: IconContent(
                        myicon: Icons.male,
                        text: 'Male',
                      ),
                    ),

                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                    child: ReusableBg(
                      colour: selectedGender == Gender.female
                          ? Colors.indigo.shade400
                          : kinactiveCardColor,
                      cardChild: IconContent(
                        myicon: Icons.female,
                        text: 'Female',
                      ),
                    ),

                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableBg(
              colour: Colors.indigo.shade400,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Height',
                      style: appText(
                          color: Colors.white,
                          isShadow: false,
                          weight: FontWeight.bold,
                          size: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        height.toString(),
                        style: kDigitTextStyle,
                      ),
                      Text(
                        'cm',
                        style: klabelTextStyle,
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: ksliderInactiveColor,
                      thumbColor: Color(0xFFEB1555),
                      overlayColor: Color(0x29EB1555),
                      thumbShape:
                      RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape:
                      RoundSliderOverlayShape(overlayRadius: 35.0),
                    ),
                    child: Slider(
                      value: height.toDouble(),
                      min: 120,
                      max: 220,
                      onChanged: (double newValue) {
                        setState(() {
                          height = newValue.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableBg(
                    colour: Colors.indigo.shade400,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Weight',
                            style: appText(
                                color: Colors.white,
                                isShadow: false,
                                weight: FontWeight.bold,
                                size: 16)),
                        Text(
                          weight.toString(),
                          // userData != null ? userData!['weight']?.toString() ?? '' : '',
                          style: kDigitTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: Icons.remove_rounded,
                              onPressed: () {
                                setState(() {
                                  weight--;
                                  // weight=userData!['weight'];
                                });
                              },
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            RoundIconButton(
                              icon: Icons.add,
                              onPressed: () {
                                setState(() {
                                  // userData!['weight']++;
                                  weight++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ),
                Expanded(
                  child: ReusableBg(
                    colour: Colors.indigo.shade400,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Age',
                            style: appText(
                                color: Colors.white,
                                isShadow: false,
                                weight: FontWeight.bold,
                                size: 16)),
                        Text(
                          age.toString(),
                          style: kDigitTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: Icons.remove_rounded,
                              onPressed: () {
                                setState(() {
                                  // userData!['age']--;
                                  age--;
                                });
                              },
                            ),
                            SizedBox(width: 15.0),
                            RoundIconButton(
                              icon: Icons.add,
                              onPressed: () {
                                setState(() {
                                  // userData!['age']++;
                                  age++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ),
              ],
            ),
          ),
          BottomContainer(
            text: 'Calculate',
            onTap: () {
              Calculate calc = Calculate(height: height, weight: weight);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(
                    bmi: calc.result(),
                    resultText: calc.getText(),
                    advise: calc.getAdvise(),
                    textColor: calc.getTextColor(),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(
      //     Icons.favorite,
      //     color: Colors.pink,
      //     size: 23.0,
      //   ),
      //   backgroundColor: kactiveCardColor,
      // ),
    );
  }
}