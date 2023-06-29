import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp/HomePage/HomePage.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:gp/Prediction//Description.dart';
import 'package:flutter/services.dart';
import '../HRM/constants.dart';
import 'Diseases.dart';
class PossibleDiseases extends StatefulWidget {
  final String? previousRoute;
  PossibleDiseases({Key? key, this.previousRoute}) : super(key: key);

  @override
  _PossibleDiseases createState() => _PossibleDiseases();
}
//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
Future <Map<String, dynamic>?> doThis(List<String> documentIds) async {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  final firestore = FirebaseFirestore.instance;
  CollectionReference usersRef = firestore.collection('users');
  Query query = usersRef.where('email', isEqualTo: userEmail);
  QuerySnapshot querySnapshot = await query.get();
  querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<String, dynamic>?;
    return userData;
  }

  return null;
}

class _PossibleDiseases extends State<PossibleDiseases> {
  final formattedTime = DateTime.now();
  List<String> documentIds = [];
  Map<String, dynamic>? userData;
  Map<String, dynamic>? symptoms ;
  Map<String, dynamic>? diagnosis ;
  final TextEditingController textEditingController = TextEditingController(
      text: DateTime.now().toString().replaceAll(' ', '_').split('.')[0]
  );


  List DiseasesList = [];
  Future openDialog() => showDialog(
    context: context,
    builder: (context) {
      bool isSaving = false; // Flag to track saving state

      return StatefulBuilder(
        builder: (context, setState) {
          // Build the dialog content within a StatefulBuilder to update the state
          return AlertDialog(
            title: isSaving ? Text("") : Text("Save As", style: appText(
                color: Colors.black,
                isShadow: false,
                weight: FontWeight.w600,
                size: 18)),
            content: isSaving
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                SizedBox(height: 16),
                Text(
                  "Saved Successfully",
                  style: appText(
                color: Colors.black,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 20),
                ),
              ],
            )
                : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Text',
                    hintStyle: appText(
                      color: Colors.grey,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 14),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        textEditingController.clear();
                      },
                    ),
                  ),
                ),
                if (textEditingController.text.isEmpty)
                  Text(
                    'Please enter a text',
                       style: appText(
                  color: Colors.red,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 14),
                  ),
              ],
            ),
            actions: [
              Row(
                children: [
                  SizedBox(width: 110),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: isSaving
                        ? Text("")
                        : Text(
                      "Cancel",
                      style: appText(
                      color: Colors.red,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (!isSaving && textEditingController.text.isNotEmpty) {
                        setState(() {
                          isSaving = true; // Set saving state to true
                        });

                        userData = await doThis(documentIds);
                        addDiagnosis(
                          textEditingController.text,
                          documentIds[0],
                          userData!['email'],
                          symptoms!,
                          diagnosis!,
                          formattedTime,
                        );

                        // Delay the closing of the dialog by 2 seconds
                        await Future.delayed(Duration(seconds: 2));

                        // Close the dialog and navigate to the HomePage
                        Navigator.of(context).pop();
                      }
                    },
                    child: isSaving ? Text("") : Text("Submit", style: appText(
                      color: Colors.blue,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 16),),
                  ),
                ],
              ),
            ],
          );
        },
      );

    },
  );



  @override
  Widget build(BuildContext context) {
    bool saveButton = (widget.previousRoute == '/predicting');
    int counter = 0;
    String match = '';
    Map<String, dynamic> args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    symptoms = args['Symptoms'];
    final formattedTime= DateFormat('EEE hh:mm a').format(DateTime.now());
    diagnosis = args['Diseases'];
    List<MapEntry<String,dynamic>> listMappedEntries = diagnosis!.entries.toList();
    listMappedEntries.sort((a,b)=> b.value.compareTo(a.value));
    final Map<String,dynamic> sortedDiagnosis = Map.fromEntries(listMappedEntries);
    for (var item in sortedDiagnosis.entries) {
      if (item.value >= 0.02) {

        if (item.value >= 0.75) {
          match = "    Very High Match";
          DiseasesList.insert(counter++, Diseases(name: item.key, match: match, percentage: item.value));
        }

        if (item.value >= 0.51  && item.value <= 0.74) {
          match = "         High Match";
          DiseasesList.insert(counter++, Diseases(name: item.key, match: match, percentage: item.value));
        }

        if (item.value >= 0.26 && item.value <= 0.50) {
          match = "Moderate Match";
          DiseasesList.insert(counter++, Diseases(name: item.key, match: match , percentage: item.value));
        }


        if (item.value >= 0.13 && item.value <= 0.25) {
          match = "         Low Match";
          DiseasesList.insert(counter++, Diseases(name: item.key, match: match, percentage: item.value));
        }


        if (item.value >= 0.02 && item.value <= 0.12) {
          match = "   Very Low Match";
          DiseasesList.insert(counter++, Diseases(name: item.key, match: match, percentage: item.value));
        }

      }
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              LineAwesomeIcons.angle_left,
              size: 35,
            ),
            color: Colors.white,
          ),
          title: Text('Possible Diseases', style: appText(
              color: Colors.white,
              isShadow: false,
              weight: FontWeight.w600,
              size: 20),),
          centerTitle: true,
          backgroundColor: Colors.indigo.shade400,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  showSymptomsDialog(symptoms);
                });
              },
              icon: Icon(Icons.info_outline),
            ),
          ],
        ),

        body: ListView.builder(
          itemCount: counter,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(11),
                child: ListTile(
                  title: Text(
                    DiseasesList[index].name + "\n",
                    style: appText(
                      color: Colors.black,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 18),
                  ),
                  subtitle: LinearPercentIndicator(
                    width: 140,
                    lineHeight:15,
                    percent: DiseasesList[index].percentage,
                    progressColor: Colors.indigo ,
                    animation: true,
                    animationDuration: 2000,
                    barRadius: Radius.circular(40.0),

                  ),
                  trailing: Text("${DiseasesList[index].match}", style: appText(
                      color: Colors.black,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 14),),
                  isThreeLine: true,
                  onTap: (){
                    Navigator.pushNamed(
                      context,
                      '/Diagnosis',
                      arguments: {
                        'diagnosis': DiseasesList[index].name,
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),

        floatingActionButton: Visibility(
          visible: saveButton,
          child: FloatingActionButton(
            backgroundColor: Colors.indigo,
            child:  Text('Save', style: appText(
                  color: Colors.white,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 14),),
            onPressed: () {
              openDialog();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: SizedBox(height: 0),
        ),

    );
  }


  void showSymptomsDialog(Map<String, dynamic>? symptoms) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text('Symptoms', style: appText(
            color: Colors.black,
            isShadow: false,
            weight: FontWeight.w600,
            size: 18),),),
        content: SingleChildScrollView(
          child: Center(
            child: Column(
              children: symptoms?.values.map((symptom) {
                return Text(symptom.toString(), style: appText(
                color: Colors.black,
                    isShadow: false,
                    weight: FontWeight.normal,
                    size: 16),);
              }).toList() ?? [
                Text('No symptoms available', style: appText(
                    color: Colors.black,
                    isShadow: false,
                    weight: FontWeight.w600,
                    size: 14),)
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Center(child: Text(
              'Close',
              style: TextStyle(fontSize: 16.0), // Increase font size to 24
            ),
            ),
          ),
        ],
      ),
    );
  }



  Future addDiagnosis(String name, String docID ,String email,Map<String, dynamic> Symptoms, Map<String, dynamic> disease , DateTime time)async{
    await FirebaseFirestore.instance.collection('diagnosis').add({
      'name': name,
      "docID":docID,
      'email':email,
      'symptoms':Symptoms,
      'disease':disease,
      'time': time,
    });
  }
}