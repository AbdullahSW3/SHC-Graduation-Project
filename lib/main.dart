import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp/auth_controller.dart';
import 'package:gp/login_page.dart';
import 'package:gp/personal_info.dart';
import 'package:gp/MultiSelect.dart';
import 'package:gp/signup_page.dart';
import 'package:get/get.dart';
import 'package:gp/update_profile.dart';

import 'FirstScreen.dart';
import 'Prediction/Description.dart';
import 'Prediction/PossibleDiseases.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        routes: {

          '/medicalrecord': (context) => PossibleDiseases(previousRoute: ModalRoute.of(context)!.settings.name),
          '/predicting': (context) => PossibleDiseases(previousRoute: ModalRoute.of(context)!.settings.name),
          '/Diagnosis': (context) => Description(),
        },
        debugShowCheckedModeBanner: false,
        home: IndigoScreen()
    );
  }
}
