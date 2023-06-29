import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:gp/Prediction/Description.dart';
import 'package:http/http.dart' as http;
import 'package:gp/Prediction/PossibleDiseases.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'dart:async';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

import '../HRM/constants.dart';
import '../HomePage/HomePage.dart';

class Prediction extends StatefulWidget {
  Prediction({Key? key}) : super(key: key);

  @override
  _PredictionState createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {
  static List<String> symptoms = [
    'itching',
    ' skin_rash',
    ' nodal_skin_eruptions',
    ' dischromic _patches',
    ' continuous_sneezing',
    ' shivering',
    ' chills',
    ' watering_from_eyes',
    ' stomach_pain',
    ' acidity',
    ' ulcers_on_tongue',
    ' vomiting',
    ' cough',
    ' chest_pain',
    ' yellowish_skin',
    ' nausea',
    ' loss_of_appetite',
    ' abdominal_pain',
    ' yellowing_of_eyes',
    ' burning_micturition',
    ' spotting_urination',
    ' passage_of_gases',
    ' internal_itching',
    ' indigestion',
    ' muscle_wasting',
    ' patches_in_throat',
    ' high_fever',
    ' extra_marital_contacts',
    ' fatigue',
    ' weight_loss',
    ' restlessness',
    ' lethargy',
    ' irregular_sugar_level',
    ' blurred_and_distorted_vision',
    ' obesity',
    ' excessive_hunger',
    ' increased_appetite',
    ' polyuria',
    ' sunken_eyes',
    ' dehydration',
    ' diarrhoea',
    ' breathlessness',
    ' family_history',
    ' mucoid_sputum',
    ' headache',
    ' dizziness',
    ' loss_of_balance',
    ' lack_of_concentration',
    ' stiff_neck',
    ' depression',
    ' irritability',
    ' visual_disturbances',
    ' back_pain',
    ' weakness_in_limbs',
    ' neck_pain',
    ' weakness_of_one_body_side',
    ' altered_sensorium',
    ' dark_urine',
    ' sweating',
    ' muscle_pain',
    ' mild_fever',
    ' swelled_lymph_nodes',
    ' malaise',
    ' red_spots_over_body',
    ' joint_pain',
    ' pain_behind_the_eyes',
    ' constipation',
    ' toxic_look_(typhos)',
    ' belly_pain',
    ' yellow_urine',
    ' receiving_blood_transfusion',
    ' receiving_unsterile_injections',
    ' coma',
    ' stomach_bleeding',
    ' acute_liver_failure',
    ' swelling_of_stomach',
    ' distention_of_abdomen',
    ' history_of_alcohol_consumption',
    ' fluid_overload',
    ' phlegm',
    ' blood_in_sputum',
    ' throat_irritation',
    ' redness_of_eyes',
    ' sinus_pressure',
    ' runny_nose',
    ' congestion',
    ' loss_of_smell',
    ' fast_heart_rate',
    ' rusty_sputum',
    ' pain_during_bowel_movements',
    ' pain_in_anal_region',
    ' bloody_stool',
    ' irritation_in_anus',
    ' cramps',
    ' bruising',
    ' swollen_legs',
    ' swollen_blood_vessels',
    ' prominent_veins_on_calf',
    ' weight_gain',
    ' cold_hands_and_feets',
    ' mood_swings',
    ' puffy_face_and_eyes',
    ' enlarged_thyroid',
    ' brittle_nails',
    ' swollen_extremeties',
    ' abnormal_menstruation',
    ' muscle_weakness',
    ' anxiety',
    ' slurred_speech',
    ' palpitations',
    ' drying_and_tingling_lips',
    ' knee_pain',
    ' hip_joint_pain',
    ' swelling_joints',
    ' painful_walking',
    ' movement_stiffness',
    ' spinning_movements',
    ' unsteadiness',
    ' pus_filled_pimples',
    ' blackheads',
    ' scurring',
    ' bladder_discomfort',
    ' foul_smell_of urine',
    ' continuous_feel_of_urine',
    ' skin_peeling',
    ' silver_like_dusting',
    ' small_dents_in_nails',
    ' inflammatory_nails',
    ' blister',
    ' red_sore_around_nose',
    ' yellow_crust_ooze',
  ];
  static Map<String, String> symptomsMap = {
    'Itching': 'itching',
    'Skin Rash': ' skin_rash',
    'Nodal Skin Eruptions': ' nodal_skin_eruptions',
    'Dischromic Patches': ' dischromic _patches',
    'Continuous Sneezing': ' continuous_sneezing',
    'Shivering': ' shivering',
    'Chills': ' chills',
    'Watering From Eyes': ' watering_from_eyes',
    'Stomach Pain': ' stomach_pain',
    'Acidity': ' acidity',
    'Ulcers On Tongue': ' ulcers_on_tongue',
    'Vomiting': ' vomiting',
    'Cough': ' cough',
    'Chest Pain': ' chest_pain',
    'Yellowish Skin': ' yellowish_skin',
    'Nausea': ' nausea',
    'Loss Of Appetite': ' loss_of_appetite',
    'Abdominal Pain': ' abdominal_pain',
    'Yellowing Of Eyes': ' yellowing_of_eyes',
    'Burning Micturition': ' burning_micturition',
    'Spotting Urination': ' spotting_urination',
    'Passage Of Gases': ' passage_of_gases',
    'Internal Itching': ' internal_itching',
    'Indigestion': ' indigestion',
    'Muscle Wasting': ' muscle_wasting',
    'Patches In Throat': ' patches_in_throat',
    'High Fever': ' high_fever',
    'Extra Marital Contacts': ' extra_marital_contacts',
    'Fatigue': ' fatigue',
    'Weight Loss': ' weight_loss',
    'Restlessness': ' restlessness',
    'Lethargy': ' lethargy',
    'Irregular Sugar Level': ' irregular_sugar_level',
    'Blurred And Distorted Vision': ' blurred_and_distorted_vision',
    'Obesity': ' obesity',
    'Excessive Hunger': ' excessive_hunger',
    'Increased Appetite': ' increased_appetite',
    'Polyuria': ' polyuria',
    'Sunken Eyes': ' sunken_eyes',
    'Dehydration': ' dehydration',
    'Diarrhoea': ' diarrhoea',
    'Breathlessness': ' breathlessness',
    'Family History': ' family_history',
    'Mucoid Sputum': ' mucoid_sputum',
    'Headache': ' headache',
    'Dizziness': ' dizziness',
    'Loss Of Balance': ' loss_of_balance',
    'Lack Of Concentration': ' lack_of_concentration',
    'Stiff Neck': ' stiff_neck',
    'Depression': ' depression',
    'Irritability': ' irritability',
    'Visual Disturbances': ' visual_disturbances',
    'Back Pain': ' back_pain',
    'Weakness In Limbs': ' weakness_in_limbs',
    'Neck Pain': ' neck_pain',
    'Weakness Of One Body Side': ' weakness_of_one_body_side',
    'Altered Sensorium': ' altered_sensorium',
    'Dark Urine': ' dark_urine',
    'Sweating': ' sweating',
    'Muscle Pain': ' muscle_pain',
    'Mild Fever': ' mild_fever',
    'Swelled Lymph Nodes': ' swelled_lymph_nodes',
    'Malaise': ' malaise',
    'Red Spots Over Body': ' red_spots_over_body',
    "Joint Pain": " joint_pain",
    "Pain Behind the Eyes": " pain_behind_the_eyes",
    "Constipation": " constipation",
    "Toxic Look (Typhos)": " toxic_look_(typhos)",
    "Belly Pain": " belly_pain",
    "Yellow Urine": " yellow_urine",
    "Receiving Blood Transfusion": " receiving_blood_transfusion",
    "Receiving Unsterile Injections": " receiving_unsterile_injections",
    "Coma": " coma",
    "Stomach Bleeding": " stomach_bleeding",
    "Acute Liver Failure": " acute_liver_failure",
    "Swelling of Stomach": " swelling_of_stomach",
    "Distention of Abdomen": " distention_of_abdomen",
    "History of Alcohol Consumption": " history_of_alcohol_consumption",
    "Fluid Overload": " fluid_overload",
    "Phlegm": " phlegm",
    "Blood in Sputum": " blood_in_sputum",
    "Throat Irritation": " throat_irritation",
    "Redness of Eyes": " redness_of_eyes",
    "Sinus Pressure": " sinus_pressure",
    "Runny Nose": " runny_nose",
    "Congestion": " congestion",
    "Loss of Smell": " loss_of_smell",
    "Fast Heart Rate": " fast_heart_rate",
    "Rusty Sputum": " rusty_sputum",
    "Pain During Bowel Movements": " pain_during_bowel_movements",
    "Pain in Anal Region": " pain_in_anal_region",
    "Bloody Stool": " bloody_stool",
    "Irritation in Anus": " irritation_in_anus",
    "Cramps": " cramps",
    "Bruising": " bruising",
    "Swollen Legs": " swollen_legs",
    "Swollen Blood Vessels": " swollen_blood_vessels",
    "Prominent Veins on Calf": " prominent_veins_on_calf",
    "Weight Gain": " weight_gain",
    "Cold Hands and Feets": " cold_hands_and_feets",
    "Mood Swings": " mood_swings",
    "Puffy Face and Eyes": " puffy_face_and_eyes",
    "Enlarged Thyroid": " enlarged_thyroid",
    "Brittle Nails": " brittle_nails",
    "Swollen Extremeties": " swollen_extremeties",
    "Abnormal Menstruation": " abnormal_menstruation",
    "Muscle Weakness": " muscle_weakness",
    "Anxiety": " anxiety",
    "Slurred Speech": " slurred_speech",
    "Palpitations": " palpitations",
    "Drying and Tingling Lips": " drying_and_tingling_lips",
    "Knee Pain": " knee_pain",
    "Hip Joint Pain": " hip_joint_pain",
    "Swelling Joints": " swelling_joints",
    "Painful Walking": " painful_walking",
    "Movement Stiffness": " movement_stiffness",
    "Spinning Movements": " spinning_movements",
    "Unsteadiness": " unsteadiness",
    "Pus Filled Pimples": " pus_filled_pimples",
    'Blackheads': ' blackheads',
    'Scurring': ' scurring',
    'Bladder Discomfort': ' bladder_discomfort',
    'Foul Smell Of Urine': ' foul_smell_of urine',
    'Continuous Feel Of Urine': ' continuous_feel_of_urine',
    'Skin Peeling': ' skin_peeling',
    'Silver Like Dusting': ' silver_like_dusting',
    'Small Dents In Nails': ' small_dents_in_nails',
    'Inflammatory Nails': ' inflammatory_nails',
    'Blister': ' blister',
    'Red Sore Around Nose': ' red_sore_around_nose',
    'Yellow Crust Ooze': ' yellow_crust_ooze'
  };
  List<dynamic> BodyParts = [];
  List<dynamic> symptomSelector = [];
  List<dynamic> symptomSelected = [];
  List<String> nose = ['Continuous Sneezing',"Phlegm","Runny Nose",'Blackheads','Red Sore Around Nose',"Congestion","Loss of Smell","Blood in Sputum","Rusty Sputum"];
  List<String> face = ['Pain Behind the Eyes','Blackheads',"Sinus Pressure","Puffy Face and Eyes"];
  List<String> mouth = ['Ulcers On Tongue','Vomiting','Cough',"Phlegm","Drying and Tingling Lips","Blood in Sputum","Rusty Sputum","Slurred Speech"];
  List<String> eyes = ['Sunken Eyes',"Puffy Face and Eyes","Redness of Eyes",'Watering From Eyes','Pain Behind the Eyes','Yellowing Of Eyes','Visual Disturbances','Blurred And Distorted Vision',];
  List<String> mental = ['Headache','Scurring',"Slurred Speech","Anxiety","Mood Swings",'Dizziness','Loss Of Balance',"Unsteadiness",'Lack Of Concentration','Depression','Irritability','Loss Of Appetite','Increased Appetite','Excessive Hunger','Altered Sensorium',"Coma"];
  List<String> body = ['Mild Fever',"Spinning Movements","Movement Stiffness","Painful Walking","Swelling Joints","Muscle Weakness","Swollen Blood Vessels","Weight Gain",'Breathlessness','Muscle Wasting','Muscle Pain',"Receiving Blood Transfusion","Cramps",'Receiving Unsterile Injections','Weakness Of One Body Side','Fatigue','Restlessness','Lethargy','Malaise','Irregular Sugar Level',"Coma",'Weight Loss','Obesity','Dehydration','Weakness In Limbs','High Fever'];
  List<String> neck = ['Cough',"Enlarged Thyroid","Throat Irritation",'Muscle Wasting','Muscle Pain','Patches In Throat',"Phlegm",'Mucoid Sputum','Stiff Neck','Neck Pain','Swelled Lymph Nodes'];
  List<String> shoulders = ['Muscle Wasting',"Swelling Joints","Muscle Weakness",'Muscle Pain','Joint Pain'];
  List<String> arms = ['Muscle Wasting','Inflammatory Nails','Small Dents In Nails',"Spinning Movements","Movement Stiffness","Swelling Joints","Muscle Weakness",'Weakness In Limbs','Muscle Pain',"Swollen Extremeties",'Joint Pain',"Cold Hands and Feets","Brittle Nails"];
  List<String> chest = ['Chest Pain',"Palpitations","Muscle Weakness","Fast Heart Rate",'Muscle Wasting','Breathlessness','Muscle Pain'];
  List<String> back = ['Muscle Wasting','Back Pain','Muscle Pain'];
  List<String> abdomen = ['Stomach Pain',"Pain During Bowel Movements","Acute Liver Failure","History of Alcohol Consumption","Distention of Abdomen",'Excessive Hunger',"Swelling of Stomach",'Acidity',"Stomach Bleeding",'Nausea','Constipation','Abdominal Pain','Indigestion','Belly Pain','Muscle Wasting','Irregular Sugar Level',];
  List<String> private_area = ['Polyuria','Continuous Feel Of Urine','Foul Smell Of Urine','Bladder Discomfort',"Hip Joint Pain","Abnormal Menstruation","Bloody Stool","Irritation in Anus",'Burning Micturition','Spotting Urination','Diarrhoea','Passage Of Gases',"Yellow Urine",'Muscle Wasting','Extra Marital Contacts','Dark Urine'];
  List<String> legs = ['Muscle Wasting','Inflammatory Nails','Small Dents In Nails',"Spinning Movements","Movement Stiffness","Painful Walking","Swelling Joints","Knee Pain","Muscle Weakness","Swollen Extremeties","Cold Hands and Feets","Swollen Legs","Prominent Veins on Calf","Brittle Nails",'Weakness In Limbs','Muscle Pain','Joint Pain'];
  List<String> skin = ['Itching','Yellow Crust Ooze','Blister','Silver Like Dusting','Skin Peeling','Blackheads',"Pus Filled Pimples",'Skin Rash',"Bruising",'Internal Itching',"Fluid Overload",'Nodal Skin Eruptions','Red Spots Over Body','Dischromic Patches','Shivering','Chills','Yellowish Skin','Toxic Look (Typhos)'];
  @override
  void initState(){
    super.initState();
    this.BodyParts.add({"id": 15, "label": 'Mental Health'});
    this.BodyParts.add({"id": 1, "label": 'Face'});
    this.BodyParts.add({"id": 2, "label": 'Eyes'});
    this.BodyParts.add({"id": 3, "label": 'Nose'});
    this.BodyParts.add({"id": 4, "label": 'Mouth'});
    this.BodyParts.add({"id": 5, "label": 'Neck'});
    this.BodyParts.add({"id": 6, "label": 'Shoulders'});
    this.BodyParts.add({"id": 7, "label": 'Arms'});
    this.BodyParts.add({"id": 8, "label": 'Chest'});
    this.BodyParts.add({"id": 9, "label": 'Back'});
    this.BodyParts.add({"id": 10, "label": 'Abdomen'});
    this.BodyParts.add({"id": 11, "label": 'Private Area'});
    this.BodyParts.add({"id": 12, "label": 'Legs'});
    this.BodyParts.add({"id": 13, "label": 'Whole Body'});
    this.BodyParts.add({"id": 14, "label": 'Skin'});


    this.symptomSelector = [
      {"ID": 1, "symptom": 'Pain Behind the Eyes', "ParentId": 1},
      {"ID": 2, "symptom": 'Blackheads', "ParentId": 1},
      {"ID": 3, "symptom": "Sinus Pressure", "ParentId": 1},
      {"ID": 4, "symptom": "Puffy Face and Eyes", "ParentId": 1},
      //
      {"ID": 1, "symptom": 'Sunken Eyes', "ParentId": 2},
      {"ID": 2, "symptom": "Puffy Face and Eyes", "ParentId": 2},
      {"ID": 3, "symptom": "Redness of Eyes", "ParentId": 2},
      {"ID": 4, "symptom": 'Watering From Eyes', "ParentId": 2},
      {"ID": 5, "symptom": 'Pain Behind the Eyes', "ParentId": 2},
      {"ID": 6, "symptom": 'Yellowing Of Eyes', "ParentId": 2},
      {"ID": 7, "symptom": 'Visual Disturbances', "ParentId": 2},
      //
      {"ID": 8, "symptom": 'Blurred And Distorted Vision', "ParentId": 2},
      {"ID": 1, "symptom": 'Continuous Sneezing', "ParentId": 3},
      {"ID": 2, "symptom": "Phlegm", "ParentId": 3},
      {"ID": 3, "symptom": "Runny Nose", "ParentId": 3},
      {"ID": 4, "symptom": 'Red Sore Around Nose', "ParentId": 3},
      {"ID": 5, "symptom": "Congestion", "ParentId": 3},
      {"ID": 6, "symptom": "Loss of Smell", "ParentId": 3},
      {"ID": 7, "symptom": "Blood in Sputum", "ParentId": 3},
      {"ID": 8, "symptom": "Rusty Sputum", "ParentId": 3},
      {"ID": 9, "symptom": "Mucoid Sputum", "ParentId": 3},
      //
      {"ID": 1, "symptom": 'Ulcers On Tongue', "ParentId": 4},
      {"ID": 2, "symptom": 'Vomiting', "ParentId": 4},
      {"ID": 3, "symptom": 'Cough', "ParentId": 4},
      {"ID": 4, "symptom": "Phlegm", "ParentId": 4},
      {"ID": 5, "symptom": "Drying and Tingling Lips", "ParentId": 4},
      {"ID": 6, "symptom": "Blood in Sputum", "ParentId": 4},
      {"ID": 7, "symptom": "Rusty Sputum", "ParentId": 4},
      {"ID": 8, "symptom": "Mucoid Sputum", "ParentId": 4},
      {"ID": 9, "symptom": "Slurred Speech", "ParentId": 4},
      //
      {"ID": 1, "symptom": 'Cough', "ParentId": 5},
      {"ID": 2, "symptom": "Enlarged Thyroid", "ParentId": 5},
      {"ID": 3, "symptom": "Throat Irritation", "ParentId": 5},
      {"ID": 4, "symptom": 'Muscle Wasting', "ParentId": 5},
      {"ID": 5, "symptom": 'Muscle Pain', "ParentId": 5},
      {"ID": 6, "symptom": 'Patches In Throat', "ParentId": 5},
      {"ID": 7, "symptom": "Phlegm", "ParentId": 5},
      {"ID": 8, "symptom": 'Stiff Neck', "ParentId": 5},
      {"ID": 9, "symptom": 'Neck Pain', "ParentId": 5},
      {"ID": 10, "symptom": 'Swelled Lymph Nodes', "ParentId": 5},
      //
      {"ID": 1, "symptom": 'Muscle Wasting', "ParentId": 6},
      {"ID": 2, "symptom": "Swelling Joints", "ParentId": 6},
      {"ID": 3, "symptom": "Muscle Weakness", "ParentId": 6},
      {"ID": 4, "symptom": 'Muscle Pain', "ParentId": 6},
      {"ID": 5, "symptom": 'Joint Pain', "ParentId": 6},
      //
      {"ID": 1, "symptom": 'Muscle Wasting', "ParentId": 7},
      {"ID": 2, "symptom": 'Inflammatory Nails', "ParentId": 7},
      {"ID": 3, "symptom": 'Small Dents In Nails', "ParentId": 7},
      {"ID": 4, "symptom": "Spinning Movements", "ParentId": 7},
      {"ID": 5, "symptom": "Movement Stiffness", "ParentId": 7},
      {"ID": 6, "symptom": "Swelling Joints", "ParentId": 7},
      {"ID": 7, "symptom": "Muscle Weakness", "ParentId": 7},
      {"ID": 8, "symptom": 'Muscle Pain', "ParentId": 7},
      {"ID": 9, "symptom": "Swollen Extremeties", "ParentId": 7},
      {"ID": 10, "symptom": 'Joint Pain', "ParentId": 7},
      {"ID": 11, "symptom": "Cold Hands and Feets", "ParentId": 7},
      {"ID": 12, "symptom": "Brittle Nails", "ParentId": 7},
      //
      {"ID": 1, "symptom": 'Chest Pain', "ParentId": 8},
      {"ID": 2, "symptom": "Palpitations", "ParentId": 8},
      {"ID": 3, "symptom": "Muscle Weakness", "ParentId": 8},
      {"ID": 4, "symptom": "Fast Heart Rate", "ParentId": 8},
      {"ID": 5, "symptom": 'Muscle Wasting', "ParentId": 8},
      {"ID": 6, "symptom": 'Breathlessness', "ParentId": 8},
      {"ID": 7, "symptom": 'Muscle Pain', "ParentId": 8},
      //
      {"ID": 1, "symptom": 'Muscle Wasting', "ParentId": 9},
      {"ID": 2, "symptom": 'Back Pain', "ParentId": 9},
      {"ID": 3, "symptom": 'Muscle Pain', "ParentId": 9},
      {"ID": 4, "symptom": "Muscle Weakness", "ParentId": 9},
      //
      {"ID": 1, "symptom": 'Stomach Pain', "ParentId": 10},
      {"ID": 2, "symptom": "Pain During Bowel Movements", "ParentId": 10},
      {"ID": 3, "symptom": "Acute Liver Failure", "ParentId": 10},
      {"ID": 4, "symptom": "History of Alcohol Consumption", "ParentId": 10},
      {"ID": 5, "symptom": "Distention of Abdomen", "ParentId": 10},
      {"ID": 6, "symptom": 'Excessive Hunger', "ParentId": 10},
      {"ID": 7, "symptom": "Swelling of Stomach", "ParentId": 10},
      {"ID": 8, "symptom": 'Acidity', "ParentId": 10},
      {"ID": 9, "symptom": "Stomach Bleeding", "ParentId": 10},
      {"ID": 10, "symptom": 'Nausea', "ParentId": 10},
      {"ID": 11, "symptom": 'Constipation', "ParentId": 10},
      {"ID": 12, "symptom": 'Abdominal Pain', "ParentId": 10},
      {"ID": 13, "symptom": 'Indigestion', "ParentId": 10},
      {"ID": 14, "symptom": 'Belly Pain', "ParentId": 10},
      {"ID": 15, "symptom": 'Muscle Wasting', "ParentId": 10},
      {"ID": 16, "symptom": 'Irregular Sugar Level', "ParentId": 10},
      //
      {"ID": 1, "symptom": 'Polyuria', "ParentId": 11},
      {"ID": 2, "symptom": 'Continuous Feel Of Urine', "ParentId": 11},
      {"ID": 3, "symptom": 'Foul Smell Of Urine', "ParentId": 11},
      {"ID": 4, "symptom": 'Bladder Discomfort', "ParentId": 11},
      {"ID": 5, "symptom": "Hip Joint Pain", "ParentId": 11},
      {"ID": 6, "symptom": "Abnormal Menstruation", "ParentId": 11},
      {"ID": 7, "symptom": "Bloody Stool", "ParentId": 11},
      {"ID": 8, "symptom": "Irritation in Anus", "ParentId": 11},
      {"ID": 9, "symptom": 'Burning Micturition', "ParentId": 11},
      {"ID": 10, "symptom": 'Spotting Urination', "ParentId": 11},
      {"ID": 11, "symptom": 'Diarrhoea', "ParentId": 11},
      {"ID": 12, "symptom": 'Passage Of Gases', "ParentId": 11},
      {"ID": 13, "symptom": "Yellow Urine", "ParentId": 11},
      {"ID": 14, "symptom": 'Muscle Wasting', "ParentId": 11},
      {"ID": 15, "symptom": 'Extra Marital Contacts', "ParentId": 11},
      {"ID": 16, "symptom": 'Dark Urine', "ParentId": 11},
      //
      {"ID": 1, "symptom": 'Muscle Wasting', "ParentId": 12},
      {"ID": 2, "symptom": 'Inflammatory Nails', "ParentId": 12},
      {"ID": 3, "symptom": 'Small Dents In Nails', "ParentId": 12},
      {"ID": 4, "symptom": "Spinning Movements", "ParentId": 12},
      {"ID": 5, "symptom": "Movement Stiffness", "ParentId": 12},
      {"ID": 6, "symptom": "Painful Walking", "ParentId": 12},
      {"ID": 7, "symptom": "Swelling Joints", "ParentId": 12},
      {"ID": 8, "symptom": "Knee Pain", "ParentId": 12},
      {"ID": 9, "symptom": "Muscle Weakness", "ParentId": 12},
      {"ID": 10, "symptom": "Swollen Extremeties", "ParentId": 12},
      {"ID": 11, "symptom": "Cold Hands and Feets", "ParentId": 12},
      {"ID": 12, "symptom": "Swollen Legs", "ParentId": 12},
      {"ID": 13, "symptom": "Prominent Veins on Calf", "ParentId": 12},
      {"ID": 14, "symptom": "Brittle Nails", "ParentId": 12},
      {"ID": 15, "symptom": 'Muscle Pain', "ParentId": 12},
      {"ID": 16, "symptom": 'Joint Pain', "ParentId": 12},
      //
      {"ID": 1, "symptom": 'Mild Fever', "ParentId": 13},
      {"ID": 2, "symptom": "Spinning Movements", "ParentId": 13},
      {"ID": 3, "symptom": "Movement Stiffness", "ParentId": 13},
      {"ID": 4, "symptom": "Painful Walking", "ParentId": 13},
      {"ID": 5, "symptom": "Swelling Joints", "ParentId": 13},
      {"ID": 6, "symptom": "Muscle Weakness", "ParentId": 13},
      {"ID": 7, "symptom": "Swollen Blood Vessels", "ParentId": 13},
      {"ID": 8, "symptom": "Weight Gain", "ParentId": 13},
      {"ID": 9, "symptom": 'Breathlessness', "ParentId": 13},
      {"ID": 10, "symptom": 'Muscle Wasting', "ParentId": 13},
      {"ID": 11, "symptom": 'High Fever', "ParentId": 13},
      {"ID": 12, "symptom": 'Muscle Pain', "ParentId": 13},
      {"ID": 13, "symptom": "Receiving Blood Transfusion", "ParentId": 13},
      {"ID": 14, "symptom": "Cramps", "ParentId": 13},
      {"ID": 15, "symptom": 'Receiving Unsterile Injections', "ParentId": 13},
      {"ID": 16, "symptom": 'Weakness Of One Body Side', "ParentId": 13},
      {"ID": 17, "symptom": 'Fatigue', "ParentId": 13},
      {"ID": 18, "symptom": 'Restlessness', "ParentId": 13},
      {"ID": 19, "symptom": 'Lethargy', "ParentId": 13},
      {"ID": 20, "symptom": 'Malaise', "ParentId": 13},
      {"ID": 21, "symptom": 'Irregular Sugar Level', "ParentId": 13},
      {"ID": 22, "symptom": 'Weight Loss', "ParentId": 13},
      {"ID": 23, "symptom": 'Obesity', "ParentId": 13},
      {"ID": 24, "symptom": 'Dehydration', "ParentId": 13},
      {"ID": 25, "symptom": 'Weakness In Limbs', "ParentId": 13},
      //
      {"ID": 1, "symptom": 'Itching', "ParentId": 14},
      {"ID": 2, "symptom": 'Yellow Crust Ooze', "ParentId": 14},
      {"ID": 3, "symptom": 'Blister', "ParentId": 14},
      {"ID": 4, "symptom": 'Silver Like Dusting', "ParentId": 14},
      {"ID": 5, "symptom": 'Skin Peeling', "ParentId": 14},
      {"ID": 6, "symptom": 'Blackheads', "ParentId": 14},
      {"ID": 7, "symptom": "Pus Filled Pimples", "ParentId": 14},
      {"ID": 8, "symptom": 'Skin Rash', "ParentId": 14},
      {"ID": 9, "symptom": "Bruising", "ParentId": 14},
      {"ID": 10, "symptom": 'Internal Itching', "ParentId": 14},
      {"ID": 11, "symptom": "Fluid Overload", "ParentId": 14},
      {"ID": 12, "symptom": 'Nodal Skin Eruptions', "ParentId": 14},
      {"ID": 13, "symptom": 'Red Spots Over Body', "ParentId": 14},
      {"ID": 14, "symptom": 'Dischromic Patches', "ParentId": 14},
      {"ID": 15, "symptom": 'Shivering', "ParentId": 14},
      {"ID": 16, "symptom": 'Chills', "ParentId": 14},
      {"ID": 17, "symptom": 'Yellowish Skin', "ParentId": 14},
      {"ID": 18, "symptom": 'Toxic Look (Typhos)', "ParentId": 14},
      //
      {"ID": 1, "symptom": 'Headache', "ParentId": 15},
      {"ID": 2, "symptom": 'Scurring', "ParentId": 15},
      {"ID": 3, "symptom": "Slurred Speech", "ParentId": 15},
      {"ID": 4, "symptom": "Anxiety", "ParentId": 15},
      {"ID": 5, "symptom": "Mood Swings", "ParentId": 15},
      {"ID": 6, "symptom": 'Dizziness', "ParentId": 15},
      {"ID": 7, "symptom": 'Loss Of Balance', "ParentId": 15},
      {"ID": 8, "symptom": "Unsteadiness", "ParentId": 15},
      {"ID": 9, "symptom": 'Lack Of Concentration', "ParentId": 15},
      {"ID": 10, "symptom": 'Depression', "ParentId": 15},
      {"ID": 11, "symptom": 'Irritability', "ParentId": 15},
      {"ID": 12, "symptom": 'Loss Of Appetite', "ParentId": 15},
      {"ID": 13, "symptom": 'Increased Appetite', "ParentId": 15},
      {"ID": 14, "symptom": 'Excessive Hunger', "ParentId": 15},
      {"ID": 15, "symptom": 'Altered Sensorium', "ParentId": 15},
      {"ID": 16, "symptom": "Coma", "ParentId": 15},
    ];
  }

  Map<String, int> severity = {
    'itching': 1,
    ' skin_rash': 3,
    ' nodal_skin_eruptions': 4,
    ' continuous_sneezing': 4,
    ' shivering': 5,
    ' chills': 3,
    ' joint_pain': 3,
    ' stomach_pain': 5,
    ' acidity': 3,
    ' ulcers_on_tongue': 4,
    ' muscle_wasting': 3,
    ' vomiting': 5,
    ' burning_micturition': 6,
    ' spotting_urination': 6,
    ' fatigue': 4,
    ' weight_gain': 3,
    ' anxiety': 4,
    ' cold_hands_and_feets': 5,
    ' mood_swings': 3,
    ' weight_loss': 3,
    ' restlessness': 5,
    ' lethargy': 2,
    ' patches_in_throat': 6,
    ' irregular_sugar_level': 5,
    ' cough': 4,
    ' high_fever': 7,
    ' sunken_eyes': 3,
    ' breathlessness': 4,
    ' sweating': 3,
    ' dehydration': 4,
    ' indigestion': 5,
    ' headache': 3,
    ' yellowish_skin': 3,
    ' dark_urine': 4,
    ' nausea': 5,
    ' loss_of_appetite': 4,
    ' pain_behind_the_eyes': 4,
    ' back_pain': 3,
    ' constipation': 4,
    ' abdominal_pain': 4,
    ' diarrhoea': 4,
    ' mild_fever': 5,
    ' yellow_urine': 4,
    ' yellowing_of_eyes': 4,
    ' acute_liver_failure': 6,
    ' swelling_of_stomach': 7,
    ' swelled_lymph_nodes': 6,
    ' malaise': 6,
    ' blurred_and_distorted_vision': 5,
    ' phlegm': 5,
    ' throat_irritation': 4,
    ' redness_of_eyes': 5,
    ' sinus_pressure': 4,
    ' runny_nose': 5,
    ' congestion': 5,
    ' chest_pain': 7,
    ' weakness_in_limbs': 7,
    ' fast_heart_rate': 5,
    ' pain_during_bowel_movements': 5,
    ' pain_in_anal_region': 6,
    ' bloody_stool': 5,
    ' irritation_in_anus': 6,
    ' neck_pain': 5,
    ' dizziness': 4,
    ' cramps': 4,
    ' bruising': 4,
    ' obesity': 4,
    ' swollen_legs': 5,
    ' swollen_blood_vessels': 5,
    ' puffy_face_and_eyes': 5,
    ' enlarged_thyroid': 6,
    ' brittle_nails': 5,
    ' swollen_extremeties': 5,
    ' excessive_hunger': 4,
    ' extra_marital_contacts': 5,
    ' drying_and_tingling_lips': 4,
    ' slurred_speech': 4,
    ' knee_pain': 3,
    ' hip_joint_pain': 2,
    ' muscle_weakness': 2,
    ' stiff_neck': 4,
    ' swelling_joints': 5,
    ' movement_stiffness': 5,
    ' spinning_movements': 6,
    ' loss_of_balance': 4,
    ' unsteadiness': 4,
    ' weakness_of_one_body_side': 4,
    ' loss_of_smell': 3,
    ' bladder_discomfort': 4,
    ' foul_smell_of urine': 5,
    ' continuous_feel_of_urine': 6,
    ' passage_of_gases': 5,
    ' internal_itching': 4,
    ' toxic_look_(typhos)': 5,
    ' depression': 3,
    ' irritability': 2,
    ' muscle_pain': 2,
    ' altered_sensorium': 2,
    ' red_spots_over_body': 3,
    ' belly_pain': 4,
    ' abnormal_menstruation': 6,
    ' dischromic_patches': 6,
    ' watering_from_eyes': 4,
    ' increased_appetite': 5,
    ' polyuria': 4,
    ' family_history': 5,
    ' mucoid_sputum': 4,
    ' rusty_sputum': 4,
    ' lack_of_concentration': 3,
    ' visual_disturbances': 3,
    ' receiving_blood_transfusion': 5,
    ' receiving_unsterile_injections': 2,
    ' coma': 7,
    ' stomach_bleeding': 6,
    ' distention_of_abdomen': 4,
    ' history_of_alcohol_consumption': 5,
    ' fluid_overload': 4,
    ' blood_in_sputum': 5,
    ' prominent_veins_on_calf': 6,
    ' palpitations': 4,
    ' painful_walking': 2,
    ' pus_filled_pimples': 2,
    ' blackheads': 2,
    ' scurring': 2,
    ' skin_peeling': 3,
    ' silver_like_dusting': 2,
    ' small_dents_in_nails': 2,
    ' inflammatory_nails': 5,
    ' blister': 5,
    ' red_sore_around_nose': 5,
    ' yellow_crust_ooze': 5,
  };
  Map<String, dynamic> diagnosis = {};
  Map<String, dynamic> symptomsToShow = {};
  final _items = [];
  List<String> predictSymptoms = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  String Value = "";
  double percentage = 0.0;
  bool isLoading = false;
  bool showButton = false;
  bool showMassage = false;
  var Data;
  bool DropDown = true;
  String symptom = "";
  String? Selected1;
  String? Selected2;

  dynamic getSymptomById(int id) {
    for (var symptom in symptomSelected) {
      if (symptom['ID'] == id) {
        return symptom;
      }
    }
    return null; // return null if the ID is not found
  }


  void isSevere(String value){

    for (var item in severity.entries) {
      if (item.key == value){
        if (item.value > 5){
          showButton = true;
          showMassage = true;
        }
      }
    }
  }


  void predictionStrength(){

    double currentPercentage = 0.0;
    for (int i = 0; i < _items.length; i++) {
      for (var item in symptomsMap.entries) {
        if (_items[i] == item.key){
          for (var item1 in severity.entries) {
            if (item1.key == item.value) {
              currentPercentage += item1.value * 0.05;
            }
          }
        }
      }
    }

    if ((currentPercentage) >= 1) {
      currentPercentage = 1;
    }

    setState((){
      percentage = currentPercentage;
    });
  }


  void addItem(String value) {
    bool isThere = false;
    String value2 = "";
    for (int i = 0; i < _items.length; i++) {
      if (_items[i] == value) isThere = true;
    }



    for (var item in symptomsMap.entries) {
      if (item.key == value) {
        value2 = item.value;
      }
    }

    if (isThere == false) {
      _items.insert(0, value);
      _key.currentState!
          .insertItem(0, duration: const Duration(milliseconds: 300));


    }
    setState(() {
      isSevere(value2);
      symptomsToShow = _items.asMap().map((index, value) => MapEntry(index.toString(), value));
      predictionStrength();
    });

  }

  void removeItem(int index) {
    _key.currentState!.removeItem(index, (_, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: const Card(
          margin: EdgeInsets.all(10),
          color: Colors.red,
          shape: StadiumBorder(
            side: BorderSide(
              color: Colors.red,
              width: 2.0,
            ),),
          child: ListTile(
            title: Text(
              "Symptom has been deleted",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 300));
    String toDelete = _items.elementAt(index);
    _items.removeAt(index);
    symptomsToShow = _items.asMap().map((index, value) => MapEntry(index.toString(), value));
    predictionStrength();


    for (var item in symptomsMap.entries) {
      if (item.key == toDelete) {
        for (var item1 in severity.entries) {
          if (item1.key == item.value) {
            if (item1.value > 5) {
              setState(() {
                showButton = false;
                showMassage = false;
              });
            }
          }
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text('Symptom Checker', style: appText(
              color: Colors.white,
              isShadow: false,
              weight: FontWeight.w600,
              size: 20),),
          centerTitle: true,
          backgroundColor: Colors.indigo.shade400,
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
          actions: [
            Container(
                color: Color(0x00ffffff), child: IconButton(
              icon: DropDown? Icon(Icons.search) : Icon(Icons.search_off),
              onPressed: () {
                setState(() {
                  DropDown = !DropDown;
                });
              },
            )),
          ],
        ),
        body: DropDown? Column(
          children: [
            Column(
              children: [
                FormHelper.dropDownWidgetWithLabel(
                  context,
                  "                          Body Part",
                  " Select a Body Part",
                  this.Selected1,
                  this.BodyParts,
                      (onChangedVal){
                    this.Selected1 = onChangedVal;
                    setState(() {
                      this.symptomSelected = this.symptomSelector.where(
                            (stateItem) =>
                        stateItem["ParentId"].toString() ==
                            onChangedVal.toString(),
                      ).toList();
                    });
                    this.Selected2 = null;
                  },
                      (onValidateVal){
                    if (onValidateVal == null){
                      return "Please Select a Body Part";
                    }
                    return null;
                  },
                  hintFontSize: 16,
                  borderColor: Theme.of(context).primaryColor,
                  borderFocusColor: Theme.of(context).primaryColor,
                  borderRadius: 10,
                  optionValue: 'id',
                  optionLabel: 'label',
                ),

                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: 'Please Select a body part',
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: appText(
                    color: Colors.white,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 16),
                  child: FormHelper.dropDownWidgetWithLabel(
                      context,
                      "                         Symptom",
                      "Select a Symptom",
                      this.Selected2,
                      this.symptomSelected,
                          (onChangedVal){
                        this.Selected2 = onChangedVal;
                        var TheSelectedSymptom = getSymptomById(int.parse(Selected2!).toInt());
                        symptom = TheSelectedSymptom['symptom'];
                      },
                          (onValidateVal){
                        if (onValidateVal == null){
                          return "Please Select a Symptom";
                        }
                        return null;
                      },
                      hintFontSize: 16,
                      borderColor: Theme.of(context).primaryColor,
                      borderFocusColor: Theme.of(context).primaryColor,
                      borderRadius: 10,
                      optionValue: 'ID',
                      optionLabel: 'symptom'
                  ),
                ),
              ],
            ),

            const SizedBox(
              width: 7.0,
              height: 7.0,
            ),

            Row(
              mainAxisAlignment : MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (symptom != "") {
                      addItem(symptom);
                      if (showButton && showMassage) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You have entered a serious symptom, please press call to dial 997', style: appText(
                                color: Colors.white,
                                isShadow: false,
                                weight: FontWeight.w600,
                                size: 16),),
                            duration: const Duration(seconds: 6),
                          ),
                        );
                        showMassage = false;
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a symptom first', style: appText(
                              color: Colors.white,
                              isShadow: false,
                              weight: FontWeight.w600,
                              size: 16),),
                          duration: const Duration(seconds: 6),
                        ),
                      );
                    }
                  },
                  child: Text('Add',style: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 16),),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    for( int i = _items.length-1 ; i >= 0 ; i--) {
                      setState(() {
                        removeItem(i);
                      });
                    }
                  },
                  child: Text('Remove All', style: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 16),),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              width: 10.0,
              height: 10.0,
            ),

            Tooltip(
              message: 'Enter more symptoms to get a higher accuracy.',
              triggerMode: TooltipTriggerMode.tap,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: appText(
                  color: Colors.white,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 14),
              child: Text(
                "Prediction Strength",
                style: appText(
                    color: Colors.black,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 16),),
            ),

            Tooltip(
              message: 'Enter more symptoms to get a higher accuracy.',
              triggerMode: TooltipTriggerMode.tap,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: appText(
                  color: Colors.white,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 14),
              child : const SizedBox(
                width: 4.0,
                height: 4.0,
              ),
            ),

            Tooltip(
              message: 'Enter more symptoms to get a higher accuracy.',
              triggerMode: TooltipTriggerMode.tap,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: appText(
                  color: Colors.white,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 14),
              child: LinearPercentIndicator(
                width: 170,
                lineHeight:15,
                percent: percentage,
                progressColor: Colors.indigo ,
                animation: true,
                animationDuration: 2000,
                barRadius: Radius.circular(40.0),
                alignment: MainAxisAlignment.center,
              ),
            ),

            Expanded(
              child: AnimatedList(
                key: _key,
                initialItemCount: 0,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index, animation) {
                  return FadeTransition(
                    key: UniqueKey(),
                    opacity: animation,
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          _items[index],
                          style : appText(
                              color: Colors.black,
                              isShadow: false,
                              weight: FontWeight.w600,
                              size: 18
                          ),),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey,),
                          onPressed: () {
                            removeItem(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: showButton,
              child: ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri(scheme: 'tel', path: '997');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }else{
                    print("can't launch");
                  }
                },
                child: const Text('Call'),
                style: ElevatedButton.styleFrom(
                  textStyle: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 18),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: Colors.red,
                ),
              ),
            ),
            Container(
              width: 155,
              child: ElevatedButton (
                onPressed: () async {
                  if (_items.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You have to add at least 1 symptom', style: appText(
                            color: Colors.white,
                            isShadow: false,
                            weight: FontWeight.w600,
                            size: 14)),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    return; // exit the function
                  }


                  if (_items.length >= 18) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                        Text('Number of symptoms must be less than 18', style: appText(
                            color: Colors.white,
                            isShadow: false,
                            weight: FontWeight.w600,
                            size: 14)),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    return; // exit the function
                  }
                  setState(() {
                    isLoading = true;
                  });

                  List<String> predictSymptoms = [];
                  List<int> symptomesToTest = List.filled(131, 0);

                  for (int i = 0; i < _items.length; i++) {
                    for (var item in symptomsMap.entries) {
                      if (item.key == _items[i]) {
                        predictSymptoms.add(item.value);
                        symptomesToTest[
                        symptoms.indexOf(predictSymptoms[i])] = 1;
                      }
                    }
                  }

                  final url = Uri.parse('https://flutter-shc-app.herokuapp.com/name');
                  final response1 =  await http.post(url,body: jsonEncode({'name': symptomesToTest } ));
                  final decoded = json.decode(response1.body) as Map<String,dynamic>;
                  setState(() {
                    diagnosis = decoded['name'];
                    print(diagnosis);
                  });
                    Navigator.pushNamed(
                      context,
                      '/predicting',
                      arguments: {
                        'Diseases': diagnosis,
                        'Symptoms': symptomsToShow,
                      },
                    );
                    setState(() {
                      isLoading = false;
                    });

                },
                style: ElevatedButton.styleFrom(
                  textStyle: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 18),
                  primary: Colors.indigo,
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                )

                    : Text("Predict", style: appText(
                    color: Colors.white,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 18)),
              ),
            ),
          ],
        )
            : Column(
          children: [

            const SizedBox(height: 10),
            Text(
              "Search Your Symptoms",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: 370,
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue == '') {
                    return const Iterable<String>.empty();
                  }
                  return symptomsMap.keys.where((String Item) {
                    return Item.toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (selectedString) {
                  symptom = selectedString;
                  FocusScope.of(context).unfocus();
                },
                fieldViewBuilder:
                    (context, _controller, focusNode, onEditingComplete) {
                  return TextField(
                    controller: _controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                      hintText: "Search for a symptom",
                      hintStyle: appText(
                          color: Colors.grey,
                          isShadow: false,
                          weight: FontWeight.w600,
                          size: 16),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (_controller.text == '')
                            focusNode.unfocus();
                          _controller.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  );
                },
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected<String> onSelected,
                    Iterable<String> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        height: 200.0,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            String option = options.elementAt(index);
                            return ListTile(
                              title: Text(option, style:appText(
                                color: Colors.black,
                                isShadow: false,
                                weight: FontWeight.w600,
                                size: 16)),
                              onTap: () {
                                onSelected(option);
                                /////////////
                              },
                            );
                          },
                          separatorBuilder:
                              (BuildContext context, int index) {
                            return Divider(color: Colors.grey);
                          },
                          itemCount: options.length,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              width: 10.0,
              height: 10.0,
            ),

            Row(
              mainAxisAlignment : MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (symptom != "") {
                      addItem(symptom);
                      if (showButton && showMassage) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You have entered a serious symptom, please press call to dial 997', style: appText(
                                color: Colors.white,
                                isShadow: false,
                                weight: FontWeight.w600,
                                size: 16),),
                            duration: const Duration(seconds: 6),
                          ),
                        );
                        showMassage = false;
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please search for a symptom first', style: appText(
                              color: Colors.white,
                              isShadow: false,
                              weight: FontWeight.w600,
                              size: 16),),
                          duration: const Duration(seconds: 6),
                        ),
                      );
                    }
                  },
                  child: Text('Add',style: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 16),),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    for( int i = _items.length-1 ; i >= 0 ; i--) {
                      setState(() {
                        removeItem(i);
                      });
                    }
                  },
                  child: Text('Remove All', style: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 16),),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              width: 5.0,
              height: 5.0,
            ),


            Tooltip(
              message: 'Enter more symptoms to get a higher accuracy.',
              triggerMode: TooltipTriggerMode.tap,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: appText(
                  color: Colors.white,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 14),
              child: Text(
                "Prediction Strength",
                style: appText(
                    color: Colors.black,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 16),
              ),
            ),

            Tooltip(
              message: 'Enter more symptoms to get a higher accuracy.',
              triggerMode: TooltipTriggerMode.tap,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: appText(
                  color: Colors.white,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 14),
              child : const SizedBox(
                width: 4.0,
                height: 4.0,
              ),
            ),

            Tooltip(
              message: 'Enter more symptoms to get a higher accuracy.',
              triggerMode: TooltipTriggerMode.tap,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: appText(
                  color: Colors.white,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 14),
              child: LinearPercentIndicator(
                width: 170,
                lineHeight:15,
                percent: percentage,
                progressColor: Colors.indigo ,
                animation: true,
                animationDuration: 2000,
                barRadius: Radius.circular(40.0),
                alignment: MainAxisAlignment.center,
              ),
            ),

            Expanded(
              child: AnimatedList(
                key: _key,
                initialItemCount: 0,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index, animation) {
                  return FadeTransition(
                    key: UniqueKey(),
                    opacity: animation,
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          _items[index],
                          style : appText(
                              color: Colors.black,
                              isShadow: false,
                              weight: FontWeight.w600,
                              size: 18
                        ),),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey,),
                          onPressed: () {
                            removeItem(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: showButton,
              child: ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri(scheme: 'tel', path: '997');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }else{
                    print("can't launch");
                  }
                },
                child: const Text('Call'),
                style: ElevatedButton.styleFrom(
                  textStyle: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 18),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: Colors.red,
                ),
              ),
            ),
            Container(
              width: 155,
              child: ElevatedButton (
                onPressed: () async {
                  if (_items.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You have to add at least 1 symptom', style: appText(
                            color: Colors.white,
                            isShadow: false,
                            weight: FontWeight.w600,
                            size: 14)),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    return; // exit the function
                  }


                  if (_items.length >= 18) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                        Text('Number of symptoms must be less than 18', style: appText(
                            color: Colors.white,
                            isShadow: false,
                            weight: FontWeight.w600,
                            size: 14)),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    return; // exit the function
                  }
                  setState(() {
                    isLoading = true;
                  });

                  List<String> predictSymptoms = [];
                  List<int> symptomesToTest = List.filled(131, 0);

                  for (int i = 0; i < _items.length; i++) {
                    for (var item in symptomsMap.entries) {
                      if (item.key == _items[i]) {
                        predictSymptoms.add(item.value);
                        symptomesToTest[
                        symptoms.indexOf(predictSymptoms[i])] = 1;
                      }
                    }
                  }

                  final url = Uri.parse('https://flutter-shc-app.herokuapp.com/name');
                  final response1 =  await http.post(url,body: jsonEncode({'name': symptomesToTest } ));
                  final decoded = json.decode(response1.body) as Map<String,dynamic>;
                  setState(() {
                    diagnosis = decoded['name'];
                  });


                    Navigator.pushNamed(
                      context,
                      '/predicting',
                      arguments: {
                        'Diseases': diagnosis,
                        'Symptoms': symptomsToShow,
                      },
                    );
                    setState(() {
                      isLoading = false;
                    });

                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 18),
                  primary: Colors.indigo,
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                )

                    : Text("Predict", style: appText(
                    color: Colors.white,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 18)),
              ),
            ),
          ],
        )
    );



  }
}
