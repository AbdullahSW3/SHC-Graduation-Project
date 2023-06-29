import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp/HomePage/HomePage.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'ChatComp/widgets.dart';
import 'ChatPage.dart';
import 'DoctorMedicalRecord.dart';
import 'HRM/constants.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({Key? key}) : super(key: key);

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final firestore = FirebaseFirestore.instance;
  final controller = TextEditingController();
  String search = '';
  String selectedLicenseType = 'All License Types'; // Newly added variable for selected license type

  void initState() {
    super.initState();
  }

  @override
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
        title: Text('Doctors',
            style: appText(
                color: Colors.white,
                isShadow: false,
                weight: FontWeight.w600,
                size: 20)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          ChatWidgets.searchField(
            onChange: (a) {
              setState(() {
                search = a;
              });
            },
          ),
          DropdownButton<String>(
            value: selectedLicenseType,
            hint: Text('Select a License Type'),
            onChanged: (newValue) {
              setState(() {
                selectedLicenseType = newValue!;
              });
            },
            items: <String>[
              'All License Types', // Empty value represents all license types
              'Acupuncturist',
              'Allergist/Immunologist',
              'Anesthesiologist',
              'Art Therapist',
              'Biochemist',
              'Biomedical Engineer',
              'Biostatistician',
              'Cardiologist',
              'Cardiothoracic Surgeon',
              'Certified Nursing Assistant (CNA)',
              'Clinical Nurse Specialist',
              'Clinical Pharmacologist',
              'Clinical Psychologist',
              'Clinical Research Associate',
              'Clinical Social Worker',
              'Cytotechnologist',
              'Dental Hygienist',
              'Dentist',
              'Dermatologist',
              'Dialysis Technician',
              'Dietetic Technician',
              'Emergency Medicine Physician',
              'Endocrinologist',
              'EKG Technician',
              'Exercise Physiologist',
              'Family Physician',
              'Forensic Pathologist',
              'Forensic Scientist',
              'Gastroenterologist',
              'General Practitioner (GP)',
              'General Surgeon',
              'Geneticist',
              'Geriatrician',
              'Health Information Manager',
              'Hematologist',
              'Immunologist',
              'Infectious Disease Specialist',
              'Internal Medicine Physician',
              'Medical Assistant',
              'Medical Billing Specialist',
              'Medical Coder',
              'Medical Ethicist',
              'Medical Illustrator',
              'Medical Laboratory Technologist',
              'Medical Librarian',
              'Medical Office Manager',
              'Medical Physicist',
              'Medical Secretary',
              'Medical Transcriptionist',
              'Medical Writer',
              'Neurologist',
              'Neurosurgeon',
              'Nurse Anesthetist',
              'Nurse Practitioner',
              'Nutritionist/Dietitian',
              'Occupational Therapist',
              'Oncologist',
              'Ophthalmologist',
              'Optician',
              'Optometrist',
              'Oral and Maxillofacial Surgeon',
              'Orthodontist',
              'Orthopedic Surgeon',
              'Orthopedic Technician',
              'Otolaryngologist (ENT Specialist)',
              'Paramedic',
              'Pediatric Dentist',
              'Pediatrician',
              'Pharmacy Technician',
              'Pharmacist',
              'Phlebotomist',
              'Physical Therapist',
              'Physiotherapist',
              'Plastic Surgeon',
              'Podiatrist',
              'Prosthetic Technician',
              'Prosthetist/Orthotist',
              'Psychiatrist',
              'Pulmonologist',
              'Radiation Oncologist',
              'Radiologist',
              'Registered Nurse (RN)',
              'Rehabilitation Counselor',
              'Respiratory Therapist',
              'Rheumatologist',
              'Sleep Technologist',
              'Speech-Language Pathologist',
              'Sports Medicine Physician',
              'Surgical Technologist',
              'Telemedicine Physician',
              'Toxicologist',
              'Transplant Coordinator',
              'Urologist',
              'Veterinary Surgeon',
              'Veterinary Technician',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: StreamBuilder(
                stream: firestore.collection('doctors').snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  List data = !snapshot.hasData
                      ? []
                      : snapshot.data!.docs
                      .where((element) =>
                  (selectedLicenseType == "All License Types" ||
                      element['License type']
                          .toString()
                          .toLowerCase()
                          .contains(selectedLicenseType.toLowerCase())) &&
                      (element['name']
                          .toString()
                          .toLowerCase()
                          .contains(search) ||
                          element['name']
                              .toString()
                              .toLowerCase()
                              .contains(search)))
                      .toList();

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      return ChatWidgets.Card2(
                        context,
                        subtitle: data[i]['License type'],
                        title: data[i]['name'],
                        time: ChatPage(
                          id: data[i].id.toString(),
                          name: data[i]['name'],
                        ),
                        number: data[i]['phone'],
                        hisProfilepic: data[i]['profile_image'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorMedicalRecord(
                                id: data[i].id.toString(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


