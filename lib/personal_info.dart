// ignore_for_file: prefer_const_constructors, unnecessary_const
import 'package:country_state_city_pro/country_state_city_pro.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gp/BMI/components/icon_contents.dart';
import 'package:gp/privacy.dart';
// ignore: unused_import
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'HRM/pages/home_page.dart';
import 'HomePage/mHomePage.dart';
import 'signup_page.dart';
import 'intropages/onbording_screen.dart';
import 'package:gp/MultiSelect.dart';
import 'signup_page.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


// ignore: constant_identifier_names
enum ProductTypeEnum { Male, Female }

DateTime? _selectedDate;
int? age;

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});
  // static TextEditingController uname = TextEditingController();
  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final TextEditingController _name_ = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _phone = TextEditingController();




  final TextEditingController _sosname = TextEditingController();
  final TextEditingController _sosphone = TextEditingController();
  final TextEditingController _disease = TextEditingController();


  final TextEditingController _weight = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String valueChoose = '';

  String name = "";

  ProductTypeEnum? _productTypeEnum;
  late ProductTypeEnum selectedGender;
  bool exist=false;

  @override
  void dispose() {
    _name_.dispose();
    _date.dispose();
    _country.dispose();
    _city.dispose();
    _phone.dispose();
    super.dispose();
  }


  List<String> _selectedItems = [];
  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = [
      'Arthritis',
      'Asthma',
      'Cancer',
      'diabetes',
      'hypertension',
      'others'
    ];
    final List<String>? results = await showDialog(context: context,builder: (BuildContext context) {return MultiSelect(items: items);},);
    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }
  String _selectedRelationType = '';
  String? _dbSelectedRelationType;

  final List<String> _relationTypeOptions = [
    'Brother',
    'Sister',
    'Mother',
    'Friend'
  ];

  String _gender_= "";

  String _selectedBType = '';
  String? _dbSelectedBType='';


  Future addUserDetails(String email,String name,String age,String bloodtype,String phone,String country,String city,String gender,int height,int weight,String sosname,String sosphone,String Odisease,String disease)async{
    await FirebaseFirestore.instance.collection('users').add({
      'email':email,
      'name':name,
      'age':age,
      'blood type':bloodtype,
      'phone':phone,
      'country':country,
      'city':city,
      'gender':gender,
      'height':height,
      'weight':weight,
      'sosname':sosname,
      'sosphone':sosphone,
      // 'sosrelation':sosrelation,
      'Other Chronic Diseases': Odisease,
      'Chronic Diseases':disease,
      'date_time':DateTime.now(),
      'profile_image':''
    });
  }
  Future<bool> checkUserPhoneExists(String phone) async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      return querySnapshot.docs.isNotEmpty;
    }

    return false;
  }

//   final UserNameController = TextEditingController();
//   final UserAgeController = TextEditingController();
//   final UserCountryController = TextEditingController();
//
//   late DatabaseReference dbRef;
//
//   @override
//   void initState(){
//     super.initState();
//     dbRef = FirebaseDatabase.instance.ref().child('patients');
// }
  bool _acceptedPrivacyPolicy = false;
  @override
  Widget build(BuildContext context) {

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
              // Stack(
              //   children: [
              //     Container(
              //       alignment: Alignment.topLeft,
              //       padding: EdgeInsets.only(top: 45, left: 10),
              //       height: 100,
              //       width: 500,
              //       decoration: BoxDecoration(
              //         color: const Color(0xff3e4982),
              //       ),
              //       child: Column(
              //         children: const [
              //           Center(
              //             child: Text(
              //               'Patient Information8',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                 fontSize: 35,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // -----------------Patient Name---------------
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: TextFormField(
                  controller: _name_,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(100),
                    //   borderSide: BorderSide(color: Colors.black),
                    // ),
                    labelText: "Full Name",
                    hintText: "Ahmed Alturki",
                    prefixIcon: Icon(LineAwesomeIcons.alternate_user),
                  ),
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
                margin: EdgeInsets.symmetric( horizontal: 0.0),
                child: TextField(
                  controller: TextEditingController(text: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : ''),
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    // border: UnderlineInputBorder(),
                    //   borderRadius: BorderRadius.circular(100),
                    //   borderSide: BorderSide(color: Colors.black),
                    // ),
                    icon: Icon(Icons.calendar_today_rounded),
                    labelText: "Enter your Birth",
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2022),
                      firstDate: DateTime(1960),
                      lastDate: DateTime(2022),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                        age = DateTime.now().difference(pickedDate).inDays ~/ 365;
                      });
                    }
                  },
                ),
              ),

// SizedBox(height: 8),

              //--------------Country-------------------------
              Card(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: CountryStateCityPicker(
                  country: _country,
                  state: _state,
                  city: _city,
                  textFieldInputBorder: UnderlineInputBorder(),
                ),
              ),



              // -----------------Patient City---------------
              // Card(
              //   margin: EdgeInsets.symmetric(horizontal: 0.0),
              //   child: TextFormField(
              //     controller: _city,
              //     decoration: InputDecoration(
              //       // border: OutlineInputBorder(
              //       //   borderRadius: BorderRadius.circular(100),
              //       //   borderSide: BorderSide(color: Colors.black),
              //       // ),
              //       labelText: " City",
              //       // hintText: "Ahmed Alturki",
              //       prefixIcon: Icon(LineAwesomeIcons.city),
              //
              //   ),
              //
              //     minLines: 1,
              //     maxLines: 1,
              //     validator: (value) {
              //       if (value!.isEmpty ||
              //           !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
              //         return "Please Enter The Address";
              //       } else {
              //         return null;
              //       }
              //     },
              //   ),
              // ),
              // -----------------Phone Number---------------
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                // margin: EdgeInsets.symmetric(vertical: 0.5, horizontal: 25.0),
                child: TextFormField(
                  controller: _phone,
                  // autofocus: false,

                  decoration: InputDecoration(
                    labelText: " Enter Your Number", hintText: "05xxxxxxxx",
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(100),
                    //   borderSide: BorderSide(color: Colors.black),
                    // ),
                    // labelText: " City",
                    // hintText: "Ahmed Alturki",
                    prefixIcon: Icon(LineAwesomeIcons.phone),
                    //  style: TextStyle(fontSize: 20),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[+]*[()]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]+$')
                            .hasMatch(value)) {
                      return "Please Enter a phone Number ";
                    }else if(exist){
                      return "This mobile number is already regestered";
                    }else {
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
              // =============== Height===========
              Column(
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text('          Height'),
                          subtitle: TextFormField(
                            controller: _height,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                              hintText: 'in cm',
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[+]*[()]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]+$')
                                      .hasMatch(value)) {
                                return " Incorrect Height ";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      // =============== Weight===========
                      SizedBox(
                        width: 0.01,
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('          Weight'),
                          subtitle: TextFormField(
                            controller: _weight,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                              hintText: 'in kg',
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[+]*[()]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]+$')
                                      .hasMatch(value)) {
                                return "Incorrect Weight ";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              //-------------------blood type------------------------------
              SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Blood type',
                        //   style: TextStyle(
                        //     fontSize: 16.0,
                        //     color: Colors.black54,
                        //   ),
                        // ),
                        DropdownButtonFormField<String>(
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedBType = newValue!;
                              _dbSelectedBType = newValue;
                            });
                            // Do something with the selected value
                          },
                          items: <String>[
                            'A+',
                            'A-',
                            'B+',
                            'B-',
                            'AB+',
                            'AB-',
                            'O+',
                            'O-',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text('   Select blood type (optional)'), // Add the hint text here
                          // validator: (value) {
                          //   if (value == null ||
                          //       // value.isEmpty ||
                          //       value == 'None') {
                          //     return 'Please select a Blood type';
                          //   }
                          //   return null;
                          // },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Text(
                'Emergency Contact',
                style: TextStyle(
                  fontSize: 18.0, // Set the desired font size
                  color: Colors.black54,
                ),
              ),
              // =============== SOS Contact Name===========
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: TextFormField(
                  controller: _sosname,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Emergency contact Name (Optional)",
                    hintText: "Fawaz Alturki",
                    prefixIcon: Icon(LineAwesomeIcons.alternate_user),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                        return "Please enter a name with letters only";
                      }
                    }
                    return null;
                  },
                ),

              ),
              //-------------------SOS Number-------------
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                child: TextFormField(
                  controller: _sosphone,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Enter Emergency Number (Optional)",
                    hintText: "05xxxxxxxx",
                    prefixIcon: Icon(LineAwesomeIcons.phone),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return "Please enter a number with digits only";
                      }
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),

              ),
              //---------------------Relation-----------------------
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
//-------------------------------chronic diseases-------------------------------

              ElevatedButton(
                onPressed: _showMultiSelect,
                child: const Text('Any chronic disease?'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    side: BorderSide.none,
                    shape: const StadiumBorder()),
              ),

              const Divider(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Visibility(
                  visible: _selectedItems.contains('others'),
                  child: TextFormField(
                    controller: _disease,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Enter Other chronic diseases",
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                        return "Please Enter Other chronic diseases";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              // display selected items
              Wrap(
                children: _selectedItems
                    .map((e) => Chip(//255.60.21.178
                  label: Text(e),
                  backgroundColor: Color.fromARGB(255, 60, 80, 180),
                ))
                    .toList(),
              ),





              // bool _acceptedPrivacyPolicy = false;


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "I have read and agree to the ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                    onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                    );
                    },
                    child : Text(
                      "Privacy Policy",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: Colors.indigo,
                      ),
                    ),
                    ),
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all<Color>(Colors.indigo),
                      value: _acceptedPrivacyPolicy,
                      onChanged: (bool? value) {
                        setState(() {
                          _acceptedPrivacyPolicy = value!;
                        });
                      },
                    ),
                  ],
                ),



              sizedBox,

              //-----------------Submit Button -----------------------
              SizedBox(
                width: 350,height:50,
                child: ElevatedButton(
                  onPressed: () async{
                    late String validate;
                    validate=_phone.text;
                    // exist=checkUserPhoneExists(validate);
                    if(await checkUserPhoneExists(validate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Phone number is already used'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }else if(age==null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter your birthdate'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }else if(_country.text==""){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a country'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }else if(_state.text==""){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a state'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }if(_acceptedPrivacyPolicy==false){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You must agree on the Privacy and Policy'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }else{
                      // Validate returns true if the form is valid, or false otherwise.
                      if (formKey.currentState?.validate() == true) {
                        formKey.currentState?.save();
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => const OnBoardingScreen()),);
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        // _phone.text='0'+_phone.text;
                        addUserDetails(
                            SignUpPage.emailController.text.trim(),
                            _name_.text.trim(),
                            _selectedDate.toString(),
                            _dbSelectedBType.toString() == ''? "None":_dbSelectedBType.toString(),
                            '' + _phone.text.trim(),
                            _country.text,
                            _state.text,
                            _productTypeEnum.toString().substring(
                                "ProductTypeEnum.".length),
                            //gender
                            int.parse(_height.text.trim()),
                            int.parse(_weight.text.trim()),
                            _sosname.text.trim(),
                            '' + _sosphone.text.trim(),
                            // _dbSelectedRelationType.toString(),
                            _disease.text.trim(),
                            _selectedItems.toString()
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
              const Divider(
                height: 20,
              ),
            ],
          ),
        ),
      ),

    );
  }
}
