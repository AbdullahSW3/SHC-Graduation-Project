import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp/MChatComp/Mstyles.dart';
import 'package:gp/MChatComp/Mwidgets.dart';
import 'package:gp/MChatHomePage.dart';
import 'package:gp/PatientMedicalRecord.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


import 'HRM/constants.dart';
import 'HomePage/mHomePage.dart';

class ChatPage extends StatefulWidget {
  final String id;
  final String name;
  const ChatPage({Key? key, required this.id, required this.name}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}
Future<List<Map<String, dynamic>>> doThis(List<String> documentIds, List<Map<String, dynamic>> allData, String id) async {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  final firestore = FirebaseFirestore.instance;
  CollectionReference doctorRef = firestore.collection('doctors');
  CollectionReference userRef = firestore.collection('users');
  Query query = doctorRef.where('email', isEqualTo: userEmail);
  QuerySnapshot querySnapshot = await query.get();
  DocumentSnapshot userSnapshot = await userRef.doc(id).get();
  querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
  if (querySnapshot.docs.isNotEmpty && userSnapshot.exists) {
    Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<
        String,
        dynamic>?;

    Map<String, dynamic>? userData2 = userSnapshot.data() as Map<
        String,
        dynamic>?;
    allData.add(userData!);
    allData.add(userData2!);
  }
  return allData;
}
class _ChatPageState extends State<ChatPage> {
  final firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  var roomId;
  List<String> documentIds = [];
  List<Map<String, dynamic>> allData = [];
  Map<String, dynamic>? mydata;
  Map<String, dynamic>? hisdata;

  final now = DateTime.now();
  void initState() {
    isLoading = true;
    String id = widget.id; // Store widget.id in a variable
    doThis(documentIds,allData,id).then((allData) {
      setState(() {
        mydata = allData![0];
        hisdata = allData![1];
        isLoading = false;
      });
    });
    super.initState();
  }
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation', style: appText(
              color: Colors.red,
              isShadow: false,
              weight: FontWeight.w600,
              size: 18)),
          content: Text('Are you sure you want to delete all messages?', style: appText(
              color: Colors.black,
              isShadow: false,
              weight: FontWeight.w600,
              size: 16)),
          actions: [
            TextButton(
              child: Text('Cancel', style: appText(
                  color: Colors.blue,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 14)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: appText(
                  color: Colors.red,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 14)),
              onPressed: () {
                setState(() {
                  firestore.collection('Rooms').doc(roomId).delete();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _seePatientInfo(id){

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  PatientMedicalRecord(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade400,
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
        title:  Center(child: Text(widget.name, style: appText(
            color: Colors.white,
            isShadow: false,
            weight: FontWeight.w600,
            size: 18),)),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: PopupMenuButton<int>(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text('See Patient Profile', style: appText(
                      color: Colors.black,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 16)),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Delete All Messages', style: appText(
                      color: Colors.red,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 16)),
                ),
              ],
              onSelected: (value) {
                if (value == 1) {
                  _seePatientInfo(widget.id);
                }
                if (value == 2) {
                  _showDeleteConfirmation();
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Chats',
                  style: appText(
                      color: Colors.white,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 18),
                ),
                const Spacer(),
                StreamBuilder(
                  stream: firestore.collection('users').doc(widget.id).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    final lastSeenDateTime = snapshot.data!['date_time'].toDate();
                    final now = DateTime.now();
                    final difference = now.difference(lastSeenDateTime);

                    if (difference.inMinutes <= 3) {
                      return Text(
                        'Last seen : Online',
                        style: Styles.h1().copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      );
                    } else if (difference.inDays == 0) {
                      final formattedTime = DateFormat('hh:mm a').format(lastSeenDateTime);
                      return Text(
                        'Last seen : Today $formattedTime',
                        style: appText(
                            color: Colors.white54,
                            isShadow: false,
                            weight: FontWeight.w600,
                            size: 12),
                      );
                    } else {
                      final formattedTime1 = DateFormat('dd/MM/yyyy').format(lastSeenDateTime);
                      final formattedTime2 = DateFormat('EEE hh:mm a').format(lastSeenDateTime);
                      return Text(
                        difference.inDays >= 7 ? 'Last seen : $formattedTime1' : 'Last seen : $formattedTime2',
                        style: appText(
                            color: Colors.white54,
                            isShadow: false,
                            weight: FontWeight.w600,
                            size: 12),
                      );
                    }
                  },
                ),
                const Spacer(),
                const SizedBox(
                  width: 50,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: Styles.friendsBox(),
              child: Visibility(
              visible: isLoading,
              child: Center(
              child: CircularProgressIndicator(),
              ),
              replacement: StreamBuilder(
                  stream: firestore.collection('Rooms').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        List<QueryDocumentSnapshot?> allData = snapshot
                            .data!.docs
                            .where((element) =>
                        element['Chatters'].contains(widget.id) &&
                            element['Chatters'].contains(
                                documentIds[0]))
                            .toList();
                        QueryDocumentSnapshot? data =
                        allData.isNotEmpty ? allData.first : null;
                        if (data != null) {
                          roomId = data.id;
                        }
                        return data == null
                            ? Container()
                            : StreamBuilder(
                            stream: data.reference
                                .collection('messages')
                                .orderBy('datetime', descending: true)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snap) {
                              return !snap.hasData
                                  ? Container()
                                  : ListView.builder(
                                itemCount: snap.data!.docs.length,
                                reverse: true,
                                itemBuilder: (context, i) {
                                  final message = snap.data!.docs[i]['message'];
                                  final sentBy = snap.data!.docs[i]['sent_by'];
                                  final messageDate = snap.data!.docs[i]['datetime'].toDate();

                                  bool isFirstMessageOfDay = i == snap.data!.docs.length - 1 || // First message
                                      messageDate.day != snap.data!.docs[i + 1]['datetime'].toDate().day;

                                  return Column(
                                    crossAxisAlignment:
                                    sentBy == documentIds[0] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      // Display the date if it's the first message of the day
                                      if (isFirstMessageOfDay)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Center(
                                            child: Text(
                                              DateFormat('MMM dd, yyyy').format(messageDate),
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ChatWidgets.messagesCard(
                                        sentBy == documentIds[0],
                                        (sentBy == documentIds[0])? mydata!["profile_image"]:hisdata!["profile_image"] ,
                                        message,
                                        DateFormat('hh:mm a').format(messageDate),

                                      ),
                                    ],
                                  );
                                },
                              );
                            });
                      } else {
                        return Center(
                          child: Text(
                            'No conversion found',
                            style: Styles.h1()
                                .copyWith(color: Colors.indigo.shade400),
                          ),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.indigo,
                        ),
                      );
                    }
                  }),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: ChatWidgets.messageField(onSubmit: (controller) {
              if(controller.text.toString() != ''){
                if (roomId != null) {
                  Map<String, dynamic> data = {
                    'message': controller.text.trim(),
                    'sent_by': documentIds[0],
                    'datetime': DateTime.now(),
                  };
                  firestore.collection('Rooms').doc(roomId).update({
                    'last_message_time': DateTime.now(),
                    'last_message': controller.text,
                  });
                  firestore
                      .collection('Rooms')
                      .doc(roomId)
                      .collection('messages')
                      .add(data);
                } else {
                  Map<String, dynamic> data = {
                    'message': controller.text.trim(),
                    'sent_by': documentIds[0],
                    'datetime': DateTime.now(),
                  };
                  firestore.collection('Rooms').add({
                    'Chatters': [
                      widget.id,
                      documentIds[0],
                    ],
                    'last_message': controller.text,
                    'last_message_time': DateTime.now(),
                  }).then((value) async {
                    value.collection('messages').add(data);
                  });
                }
              }
              controller.clear();
            }),
          )
        ],
      ),
    );
  }
}
