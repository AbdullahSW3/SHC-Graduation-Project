
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:gp/ChatComp/animated-dialog.dart';
import 'package:gp/ChatComp/styles.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../HRM/constants.dart';

class ChatWidgets {
  static Widget card({title, time, hisProfileImage, subtitle, onTap}) {
    if (hisProfileImage != null && hisProfileImage != '') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 0,
          child: ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.all(5),
            leading: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CircleAvatar(
                  foregroundImage: NetworkImage(hisProfileImage!),
                  backgroundColor: Colors.black38,
                  radius: 25.0,
                ),
              ),
            ),
            title: Text(title, style: appText(
                color: Colors.black,
                isShadow: false,
                weight: FontWeight.w600,
                size: 14),),
            subtitle: subtitle != null ? Text(subtitle, style: appText(
                color: Colors.grey,
                isShadow: false,
                weight: FontWeight.w600,
                size: 13),) : null,
            trailing: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(time,style: appText(
                  color: Colors.grey,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 12),),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),////
          ),
          elevation: 0,
          child: ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.all(5),
            leading: const Padding(
              padding: EdgeInsets.all(0.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 25,
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(title, style: appText(
                color: Colors.black,
                isShadow: false,
                weight: FontWeight.w600,
                size: 14),),
            subtitle: subtitle != null ? Text(subtitle, style: appText(
                color: Colors.grey,
                isShadow: false,
                weight: FontWeight.w600,
                size: 13),) : null,
            trailing: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(time, style: appText(
                  color: Colors.grey,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 12),),
            ),
          ),
        ),
      );
    }
  }


  static Widget Card2(BuildContext context, {title, subtitle,hisProfilepic, time, number, onTap, onEdit}) {
    if (hisProfilepic != null && hisProfilepic != '') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.all(5),
            leading: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CircleAvatar(
                  foregroundImage: NetworkImage(hisProfilepic!),
                  backgroundColor: Colors.black38,
                  radius: 25.0,
                ),
              ),
            ),
            title: Text(title , style: appText(
                color: Colors.black,
                isShadow: false,
                weight: FontWeight.w600,
                size: 14),),
            subtitle: Text(subtitle, style: appText(
                color: Colors.grey,
                isShadow: false,
                weight: FontWeight.w600,
                size: 12),),
            // Add the subtitle here
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    // Perform the message action here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return time;
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.message),
                ),
                IconButton(
                  onPressed: () async {
                    final Uri url = Uri(scheme: 'tel', path: '{$number}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      print("can't launch");
                    }
                  },
                  icon: Icon(Icons.phone),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.all(5),
            leading: const Padding(
                padding: EdgeInsets.all(0.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
            ),
            title: Text(title , style: appText(
                color: Colors.black,
                isShadow: false,
                weight: FontWeight.w600,
                size: 14),),
            subtitle: Text(subtitle, style: appText(
                color: Colors.grey,
                isShadow: false,
                weight: FontWeight.w600,
                size: 12),),
            // Add the subtitle here
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    // Perform the message action here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return time;
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.message),
                ),
                IconButton(
                  onPressed: () async {
                    final Uri url = Uri(scheme: 'tel', path: '{$number}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      print("can't launch");
                    }
                  },
                  icon: Icon(Icons.phone),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }




  static Widget Card3(BuildContext context, {title, time, onTap}) {
    final lastSeenDateTime = time.toDate();
    final now = DateTime.now();
    final difference = now.difference(lastSeenDateTime);

    String displayText;
    if (difference.inDays >= 7) {
      displayText = DateFormat('dd/MM/yyyy').format(lastSeenDateTime);
    } else if (difference.inDays == 0) {
      displayText = 'Today ' + DateFormat('hh:mm a').format(lastSeenDateTime);
    } else {
      displayText = DateFormat('EEE hh:mm a').format(lastSeenDateTime);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(5),
          title: Text(
            title,
            style: appText(
              color: Colors.black,
              isShadow: false,
              weight: FontWeight.w600,
              size: 18),),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              displayText,
              style: appText(
                  color: Colors.grey,
                  isShadow: false,
                  weight: FontWeight.w600,
                  size: 16),),
          ),
        ),
      ),
    );

  }




  static Widget circleProfile({onTap,name, hisProfilepic}) {
    if (hisProfilepic != null && hisProfilepic != '') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CircleAvatar(
                  foregroundImage: NetworkImage(hisProfilepic!),
                  backgroundColor: Colors.black38,
                  radius: 25.0,
                ),
              ),
              SizedBox(width: 50,
                  child: Center(child: Text(name, style: TextStyle(
                      height: 1.5, fontSize: 12, color: Colors.white),
                    overflow: TextOverflow.ellipsis,)))
            ],
          ),
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 50,
                  child: Center(child: Text(name, style: TextStyle(
                      height: 1.5, fontSize: 12, color: Colors.white),
                    overflow: TextOverflow.ellipsis,)))
            ],
          ),
        ),
      );
    }
  }

  static Widget messagesCard(bool check,hisProfilepic, message, time) {
    if (hisProfilepic != null && hisProfilepic != '') {
      final arabicPattern = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFBC2\uFBD3-\uFD3D\uFD50-\uFD8F\uFD92-\uFDC7\uFDF0-\uFDFD\uFE70-\uFEFC]');
      final isArabic = arabicPattern.hasMatch(message);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (check) const Spacer(),
            if (!check)
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CircleAvatar(
                  foregroundImage: NetworkImage(hisProfilepic!),
                  backgroundColor: Colors.black38,
                  radius: 13.0,
                ),
              ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$message',
                      style: appText(
                          color: check ? Colors.white : Colors.black,
                          isShadow: false,
                          weight: FontWeight.w600,
                          size: 15),
                    ),
                    const SizedBox(height:6),
                    Text(
                      time,
                      style: appText(
                          color: check ? Colors.white : Colors.black,
                          isShadow: false,
                          weight: FontWeight.w600,
                          size: 10),
                    ),
                  ],
                ),
                decoration: Styles.messagesCardStyle(check),
              ),
            ),
            if (check)
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CircleAvatar(
                  foregroundImage: NetworkImage(hisProfilepic!),
                  backgroundColor: Colors.black38,
                  radius: 13.0,
                ),
              ),
            if (!check) const Spacer(),
          ],
        ),
      );
    }else{
      final arabicPattern = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFBC2\uFBD3-\uFD3D\uFD50-\uFD8F\uFD92-\uFDC7\uFDF0-\uFDFD\uFE70-\uFEFC]');
      final isArabic = arabicPattern.hasMatch(message);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (check) const Spacer(),
            if (!check)
              const CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 13,
                  color: Colors.white,
                ),
                backgroundColor: Colors.grey,
                radius: 10,
              ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$message',
                      style: appText(
                          color: check ? Colors.white : Colors.black,
                          isShadow: false,
                          weight: FontWeight.w600,
                          size: 15),
                    ),
                    const SizedBox(height:6),
                    Text(
                      time,
                      style: appText(
                          color: check ? Colors.white : Colors.black,
                          isShadow: false,
                          weight: FontWeight.w600,
                          size: 10),
                    ),
                  ],
                ),
                decoration: Styles.messagesCardStyle(check),
              ),
            ),
            if (check)
              const CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 13,
                  color: Colors.white,
                ),
                backgroundColor: Colors.grey,
                radius: 10,
              ),
            if (!check) const Spacer(),
          ],
        ),
      );
    }
  }
  bool isTextArabic(String text) {
    final arabicPattern = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFBC2\uFBD3-\uFD3D\uFD50-\uFD8F\uFD92-\uFDC7\uFDF0-\uFDFD\uFE70-\uFEFC]');
    return arabicPattern.hasMatch(text);
  }

  String reverseText(String text) {
    return text.split('').reversed.join();
  }

  static messageField({required onSubmit}) {
    final con = TextEditingController();

    return Container(
      margin: const EdgeInsets.all(5),
      child: TextField(
        controller: con,
        decoration: Styles.messageTextFieldStyle(onSubmit: () {
          onSubmit(con);
        }),
      ),
      decoration: Styles.messageFieldCardStyle(),
    );
  }


  static searchBar(bool open, ) {
    return AnimatedDialog(
      height: open ? 800 : 0,
      width: open ? 400 : 0,

    );
  }

  static searchField({Function(String)? onChange}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
       onChanged: onChange,
        decoration: Styles.searchTextFieldStyle(),
      ),
      decoration: Styles.messageFieldCardStyle(),
    );
  }
}
