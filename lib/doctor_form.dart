// ignore_for_file: prefer_const_constructors, unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gp/signup_page.dart';

// ignore: unused_import
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'HomePage/mHomePage.dart';

// ignore: constant_identifier_names
enum ProductTypeEnum { Male, Female }

DateTime? _selectedDate;
int? age;

class DoctorForm extends StatefulWidget {
  const DoctorForm({super.key});

  @override
  State<DoctorForm> createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _Licensetype = TextEditingController();
  TextEditingController _Licensenumber = TextEditingController();
  final TextEditingController _state = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String valueChoose = '';

  String name = "";

  ProductTypeEnum? _productTypeEnum;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _age.dispose();
    _country.dispose();
    _city.dispose();
    _phone.dispose();
  }

  Future addUserDetails(
      String email,
      String name,
      String age,
      String Licensenumber,
      String Licensetype,
      String country,
      String city,
      String phone,
      String gender) async {
    await FirebaseFirestore.instance.collection('doctors').add({
      'email': email,
      'name': name,
      'age': age,
      'phone': phone,
      'country': country,
      "License Number": Licensenumber,
      "License type": Licensetype,
      'city': city,
      'gender': gender,
      'date_time': DateTime.now(),
      'profile_image': ''
    });
  }

  Future<bool> checkUserPhoneExists(String phone) async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('phone', isEqualTo: phone)
          .get();

      return querySnapshot.docs.isNotEmpty;
    }

    return false;
  }


  String _selectedRelationType = '';
  List<String> medicalJobTypes = [
    'Urologist',
    'Veterinary Surgeon',
    'Veterinary Technician',
  ];

  String _selectedLType = '';
  String? _dbSelectedLType;

  @override
  Widget build(BuildContext context) {
    String _selectedCountry = "d";
    String? _selectedCity = "d";
    //final double w = MediaQuery.of(context).size.width;
    // ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the leading arrow
        title: const Text('Personal Information'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // -----------------Patient Name---------------
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                      prefixIcon: Icon(LineAwesomeIcons.alternate_user),
                      border: UnderlineInputBorder(),
                      labelText: " Full Name",
                      hintText: "Ahmed Alturki"),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                      return "Please Enter Correct name";
                    } else {
                      return null;
                    }
                  },
                ),
              ),

              // -----------------Pateint Birth---------------
              SizedBox(
                height: h * 0.01,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: TextField(
                  controller: TextEditingController(
                      text: _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : ''),
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today_rounded),
                    labelText: " Enter your Birth",
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2022),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2023),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                        age =
                            DateTime.now().difference(pickedDate).inDays ~/ 365;
                      });
                    }
                  },
                ),
              ),
              //--------------License -------------------------
              // Card(
              //   margin: EdgeInsets.symmetric(horizontal: 0.0),
              //   child: Padding(
              //     padding: EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Relation Type',
              //           style: TextStyle(fontSize: 16.0),
              //         ),
              //         DropdownButtonFormField<String>(
              //           onChanged: (String? newValue) {
              //             setState(() {
              //               _selectedRelationType = newValue!;
              //               _dbSelectedRelationType= newValue;
              //             });
              //             // Do something with the selected value
              //           },
              //           items: <String>[
              //             'Parent',
              //             'Sibling',
              //             'Friend',
              //             'Family member',
              //           ].map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Text(value),
              //             );
              //           }).toList(),
              //           validator: (value) {
              //             if (value == null ||
              //                 value.isEmpty ||
              //                 value == 'None') {
              //               return 'Please select a relation type';
              //             }
              //             return null;
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              //--------------License type-------------------------
              SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'License type',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRelationType = newValue!;
                              _dbSelectedLType= newValue;
                            });
                            // Do something with the selected value
                          },
                          items: <String>[
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
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == 'None') {
                              return 'Please select a License type';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //-------------------License Number--------------------------------------------
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: TextFormField(
                  controller: _Licensenumber,
                  decoration: InputDecoration(
                      prefixIcon: Icon(LineAwesomeIcons.hashtag),
                      border: UnderlineInputBorder(),
                      labelText: "Enter your License Number",
                      hintText: "MD067370Y"),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[+]*[()]{0,1}[a-zA-Z0-9]{1,4}[)]{0,1}[-\s\./a-zA-Z0-9]+$')
                            .hasMatch(value)) {
                      return "Please Enter Correct License Number";
                    } else {
                      return null;
                    }
                  },
                ),
              ),

              //--------------Country-------------------------

              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: CountryStateCityPicker(
                  country: _country,
                  state: _state,
                  city: _city,
                  textFieldInputBorder: UnderlineInputBorder(),
                ),
              ),
              // Card(
              //   margin: EdgeInsets.symmetric(horizontal: 0.0),
              //   child: TextFormField(
              //     controller: _country,
              //     decoration: InputDecoration(
              //         prefixIcon: Icon(LineAwesomeIcons.city),
              //         border: UnderlineInputBorder(),
              //         labelText: " Country",
              //         hintText: "Saudi Arabia"),
              //     validator: (value) {
              //       if (value!.isEmpty ||
              //           !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
              //         return "Please Enter Correct Country";
              //       } else {
              //         return null;
              //       }
              //     },
              //   ),
              // ),
              // -----------------Patient City---------------
              // Card(
              //   margin: EdgeInsets.symmetric(horizontal: 0.0),
              //   child: TextFormField(
              //     controller: _city,
              //     decoration: InputDecoration(
              //         border: UnderlineInputBorder(),
              //         labelText: " City",
              //         hintText: "Jeddah"),
              //     minLines: 1,
              //     maxLines: 1,
              //     validator: (value) {
              //       if (value!.isEmpty ||
              //           !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
              //         return "Please Enter The city";
              //       } else {
              //         return null;
              //       }
              //     },
              //   ),
              // ),
              // -----------------Phone Number---------------
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: TextFormField(
                  controller: _phone,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: " Phone Number", hintText: "05xxxxxxxx",
                    prefixIcon: Icon(LineAwesomeIcons.phone),
                    //  style: TextStyle(fontSize: 20),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[+]*[()]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]+$')
                            .hasMatch(value)) {
                      return "Please Enter The Correct  Number ";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              // -----------------Patient Gender---------------
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<ProductTypeEnum>(
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        value: ProductTypeEnum.Male,
                        groupValue: _productTypeEnum,
                        title: Text(ProductTypeEnum.Male.name),
                        onChanged: (val) {
                          setState(() {
                            _productTypeEnum = val;
                          });
                        }),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: RadioListTile<ProductTypeEnum>(
                        contentPadding: EdgeInsets.all(0.0),
                        value: ProductTypeEnum.Female,
                        groupValue: _productTypeEnum,
                        title: Text(ProductTypeEnum.Female.name),
                        onChanged: (val) {
                          setState(() {
                            _productTypeEnum = val;
                          });
                        }),
                  ),
                ],
              ),
              if (_productTypeEnum == null)
                Text(
                  'Please select Gender',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                  ),
                ),

              //-----------------Submit Button -----------------------
              SizedBox(
                width: 280,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    late String validate;
                    validate = _phone.text;
                    // exist=checkUserPhoneExists(validate);
                    if (await checkUserPhoneExists(validate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Phone number is already used'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (age == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter your birthdate'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (_country.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a country'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (_state.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a state'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (formKey.currentState?.validate() == true) {
                        formKey.currentState?.save();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const mHomePage()),
                        );
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        addUserDetails(
                          SignUpPage.emailController.text.trim(),
                          _name.text.trim(),
                          _selectedDate.toString(),
                          _Licensenumber.text.trim(),
                          _dbSelectedLType.toString(),
                          _country.text.trim(),
                          _state.text.trim(),
                          '' + _phone.text.trim(),
                          _productTypeEnum
                              .toString()
                              .substring("ProductTypeEnum.".length), //gender
                        );
                      }
                      // Map<String,String> patients = {
                      //   'name':_name.text,
                      //   'age':_date.text,
                      //   'city':_city.text,
                      //   'phone':_phone.text
                      // };
                      // dbRef.push().set(patients);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Validate returns true if the form is valid, or false otherwise.
              //       if (formKey.currentState?.validate() == true) {
              //         formKey.currentState?.save();
              //         // Navigator.push(context,MaterialPageRoute(builder: (context) => const MHomePage()),);
              //         // Navigator.push(context,MaterialPageRoute(builder: (context) => const MHomePage()),
              //         // If the form is valid, display a snackbar. In the real world,
              //         // you'd often call a server or save the information in a database.
              //        //email, name,age, phone, LicenseNumber,String city,String country,String gender
              //         addUserDetails(
              //           SignUpPage.emailController.text.trim(),
              //             _name.text.trim(),
              //             int.parse(age.toString()),
              //           int.parse(_Licensenumber.text.trim()),
              //           _Licensetype.text.trim(),
              //           _country.text.trim(),
              //             _city.text.trim(),
              //             int.parse(_phone.text.trim()),
              //             _productTypeEnum.toString().substring("ProductTypeEnum.".length),//gender
              //         );
              //
              //
              //
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(content: Text('Processing Data')),
              //         );
              //       }
              //     },
              //     child: const Text('Submit'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
