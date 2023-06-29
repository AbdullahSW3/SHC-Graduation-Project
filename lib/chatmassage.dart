import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'HRM/constants.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
        required this.text,
        required this.sender,
        required this.userData,
        required this.isEnglish,});
  final Map<String, dynamic>? userData;
  final String text;
  final String sender;
  final bool isEnglish;


  @override
  Widget build(BuildContext context) {
    //RegExp englishPattern = RegExp(r'[a-zA-Z]');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey,
          child: sender == "DoctorBot" ? ImageIcon(
            AssetImage("img/chatbot.png"),
            color: Colors.black,
            size: 40,
          ) : (userData!["profile_image"] != null && userData!["profile_image"] != '')?
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CircleAvatar(
              foregroundImage: NetworkImage(userData!["profile_image"]),
              backgroundColor: Colors.black38,
              radius: 25.0,
            ),
          ):Icon(
            Icons.person,
            size: 40,
            color: Colors.white,
          ),
        ),
        // Text(sender)
        //     .text
        //     .subtitle1(context)
        //     .make()
        //     .box
        //     .color(sender == "user" ? Vx.gray300 : Colors.indigo.shade300)
        //     .p16
        //     .rounded
        //     .alignBottomLeft
        //     .makeCentered(),
        Expanded(
        child: Directionality(
        textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
                text,
                style: appText(
                    color: Colors.black,
                    isShadow: false,
                    weight: FontWeight.normal,
                    size: 12),

                  ),
                ),
            ),
        ),
      ],
    ).py8();
  }
}