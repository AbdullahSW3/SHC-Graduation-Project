import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp/Logics/functions.dart';
import 'package:gp/ChatPage.dart';
import 'package:intl/intl.dart';
import 'package:gp/ChatComp/styles.dart';
import 'package:gp/ChatComp/widgets.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'HRM/constants.dart';
import 'HomePage/HomePage.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key? key}) : super(key: key);
  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}
Future<void> doThis(List<String> documentIds) async {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  final firestore = FirebaseFirestore.instance;
  CollectionReference usersRef = firestore.collection('users');
  Query query = usersRef.where('email', isEqualTo: userEmail);
  QuerySnapshot querySnapshot = await query.get();
  querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
}
class _ChatHomePageState extends State<ChatHomePage> {
  bool isLoading = true;
  List<String> documentIds = [];
  @override
  void initState() {
    isLoading = true;
    doThis(documentIds).whenComplete(() {
      setState(() {
        isLoading = false;
        Functions.updateAvailabilityUsers(documentIds);
      });
    });
    super.initState();
  }
  final firestore = FirebaseFirestore.instance;
  bool open = false;
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
        title:  Text('Chat' , style: appText(
            color: Colors.white,
            isShadow: false,
            weight: FontWeight.w600,
            size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    open == true ? open = false : open = true;
                  });
                },
                icon: Icon(
                  open == true ? Icons.close_rounded : Icons.search_rounded,
                  size: 30,
                )),
          )
        ],
      ),
      //drawer: ChatWidgets.drawer(context),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    color: Colors.indigo.shade400,
                    padding: const EdgeInsets.all(8),
                    height: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Text(
                            'Doctors',
                              style: appText(
                                  color: Colors.white,
                                  isShadow: false,
                                  weight: FontWeight.w600,
                                  size: 16)),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 80,
                          child: Visibility(
                            visible: isLoading,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                            replacement: StreamBuilder(
                            stream:  firestore.collection('Rooms').snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              List data = !snapshot.hasData ? [] : snapshot.data!.docs.where((element) => element['Chatters'].toString().contains(documentIds[0])).toList();
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (context, i) {
                                  List users = data[i]['Chatters'];
                                  var friend = users.where((element) => element != documentIds[0]);
                                  var user = friend.isNotEmpty ? friend.first : users .where((element) => element == documentIds[0]).first;
                                  return  FutureBuilder(
                                    future: firestore.collection('doctors').doc(user).get(),
                                    builder: (context, AsyncSnapshot snap) {
                                      return !snap.hasData? Container(): ChatWidgets.circleProfile(onTap: (){
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ChatPage(
                                                id: user,
                                                name: snap.data['name'],
                                              );
                                            },
                                          ),
                                        );
                                      }, name:  snap.data['name'], hisProfilepic: snap.data['profile_image']);
                                    }
                                  );
                                },
                              );
                            }
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: Styles.friendsBox(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            'Contacts',
                              style: appText(
                                  color: Colors.indigo.shade400,
                                  isShadow: false,
                                  weight: FontWeight.w600,
                                  size: 16)),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Visibility(
                              visible: isLoading,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                              replacement: StreamBuilder(
                                stream:
                                    firestore.collection('Rooms').snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  List data = !snapshot.hasData ? [] : snapshot.data!.docs.where((element) => element['Chatters'].toString().contains(documentIds[0])).toList();
                                  return ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, i) {
                                      List users = data[i]['Chatters'];
                                      var friend = users.where((element) => element != documentIds[0]);
                                      var user = friend.isNotEmpty ? friend.first : users .where((element) => element == documentIds[0]).first;
                                      return FutureBuilder(
                                        future: firestore.collection('doctors').doc(user).get(),
                                        builder: (context,AsyncSnapshot snap) {
                                          return !snap.hasData? Container(): ChatWidgets.card(
                                            hisProfileImage: snap.data['profile_image'],
                                            title: snap.data['name'],
                                            subtitle:data[i]['last_message'],
                                            time: DateFormat('hh:mm a').format(data[i]['last_message_time'].toDate()),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return ChatPage(
                                                      id: user,
                                                      name: snap.data['name'],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      );
                                    },
                                  );
                                }),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ChatWidgets.searchBar(open)
          ],
        ),
      ),
    );
  }
}
