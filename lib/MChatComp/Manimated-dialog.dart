import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp/MChatComp/Mwidgets.dart';
import 'package:intl/intl.dart';
import '../MChatPage.dart';

class AnimatedDialog extends StatefulWidget {
  final double height;
  final double width;

  const AnimatedDialog({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> {
  final firestore= FirebaseFirestore.instance;
  final controller = TextEditingController();
  String search = '';
  bool show = false;
  @override
  Widget build(BuildContext context) {
    if (widget.height != 0) {
      Timer(const Duration(milliseconds: 200), () {
        setState(() {
          show = true;
        });
      });
    } else {
      setState(() {
        show = false;
      });
    }

    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              color: widget.width == 0
                  ? Colors.indigo.withOpacity(0)
                  : Colors.indigo.shade400,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.width == 0 ? 100 : 0),
                bottomRight: Radius.circular(widget.width == 0 ? 100 : 0),
                bottomLeft: Radius.circular(widget.width == 0 ? 100 : 0),
              )),
          child: widget.width == 0
              ? null
              : !show
              ? null
              : Column(
            children: [
              ChatWidgets.searchField(
                  onChange: (a){
                    setState(() {
                      search = a;
                    });
                  }
              ),
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0),
                  child: StreamBuilder(
                      stream: firestore.collection('users').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        List data = !snapshot.hasData
                            ? []
                            : snapshot.data!.docs
                            .where((element) =>
                        element['name']
                            .toString()
                            .toLowerCase()
                            .contains(search) ||
                            element['name']
                                .toString()
                                .toLowerCase()
                                .contains(search))
                            .toList();

                        // Sort the data list based on timestamp
                        data.sort((a, b) {
                          Timestamp timeA = a['date_time'];
                          Timestamp timeB = b['date_time'];
                          return timeB.compareTo(timeA);
                        });

                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, i) {
                            Timestamp time = data[i]['date_time'];
                            final now = DateTime.now();
                            final messageTime = time.toDate();
                            final difference = now.difference(messageTime);
                            String formattedTime;

                            if (difference.inDays >= 7) {
                              formattedTime = DateFormat('dd/MM/yyyy').format(messageTime);
                            } else if (difference.inDays == 0) {
                              formattedTime = 'Today ' + DateFormat('hh:mm a').format(messageTime);
                            } else {
                              formattedTime = DateFormat('EEE hh:mm a').format(messageTime);
                            }
                            return ChatWidgets.card(
                              title: data[i]['name'],
                              time: formattedTime,
                              hisProfileImage: data[i]['profile_image'],
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return  ChatPage(
                                        id: data[i].id.toString(),
                                        name: data[i]['name'],
                                      );
                                    },
                                  ),
                                );
                              },
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
      ],
    );
  }
}
