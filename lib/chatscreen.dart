import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp/ChatHomePage.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'DoctorBot.dart';
import 'package:velocity_x/velocity_x.dart';
import 'HRM/constants.dart';
import 'HomePage/HomePage.dart';
import 'chatmassage.dart';
import 'threedots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

Future<Map<String, dynamic>?> doThis(List<String> documentIds) async {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  Query query = usersRef.where('email', isEqualTo: userEmail);
  QuerySnapshot querySnapshot = await query.get();
  querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<String, dynamic>?;
    return userData;
  }else{
    CollectionReference usersRef = FirebaseFirestore.instance.collection('doctors');
    Query query = usersRef.where('email', isEqualTo: userEmail);
    QuerySnapshot querySnapshot = await query.get();
    querySnapshot.docs.forEach((doc) => documentIds.add(doc.id));
  Map<String, dynamic>? userData = querySnapshot.docs[0].data() as Map<String, dynamic>?;
  return userData;
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late OpenAI? chatGPT;
  bool isEnglish = true;

  bool _isTyping = false;
  Map<String, dynamic>? userData;
  String Eng = "you are a person who only answers medical related questions, only when i greet you greet back.";
  List<String> documentIds = [];


  @override
  void initState() {
    super.initState();
    chatGPT = OpenAI.instance.build(
      token: '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',
      baseOption: HttpSetup(receiveTimeout: 60000),
    );

    _isTyping = true; // Show the three dots
    doThis(documentIds).then((data) {
      setState(() {
        userData = data;

    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      // Delayed execution after 2.5 seconds
      ChatMessage message = ChatMessage(
        text: "Hello ${userData?['name'] ?? ''}, I'm here to answer all of your medical questions.",
        sender: "DoctorBot",
        userData: userData,
        isEnglish: isEnglish
      );
      _messages.insert(0, message);
      _isTyping = false; // Hide the three dots
      setState(() {});
    });
    });
  }



  @override
  void dispose() {
    chatGPT?.close();
    chatGPT?.genImgClose();
    super.dispose();
  }

  // Link for api - https://beta.openai.com/account/api-keys

  void _sendMessage(bool isEnglish) async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
      userData: userData,
      isEnglish: isEnglish,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });
    _controller.clear();

    //String EngPrompt = "you are a person who only answers medical related questions, only when i greet you greet back. With that being said my question is: " + message.text + "?";
    Eng = Eng + "i say "+  message.text + "? and your answer is: ";
    //String ArabicPrompt = "تذكر: أنت شخص يجيب فقط على الأسئلة الطبية، وعندما أحييك تحييني أيضًا." + "؟"+ message.text ;

    RegExp englishPattern = RegExp(r'[a-zA-Z]');
    //if (englishPattern.hasMatch(message.text)) {
      final request =
      CompleteText(
          prompt: Eng, model: kTranslateModelV3 , maxTokens: 500);

    final response = await chatGPT!.onCompleteText(request: request);
    final text = response!.choices[0].text.trim();

    isEnglish = englishPattern.hasMatch(message.text);
    final formattedText = isEnglish ? text.replaceFirst('.', '.\n\n').trim() : '\u202B$text\u202C'.replaceFirst('.', '.\n').trim();
    Eng = Eng  + formattedText;
    insertNewData(formattedText,isEnglish );
   // }else{
   //    final request =
   //    CompleteText(
   //        prompt: ArabicPrompt
   //        , model: "text-davinci-003",  maxTokens: 400);
   //    final response = await chatGPT!.onCompleteText(request: request);
   //    Vx.log(response!.choices[0].text);
      // insertNewData(response.choices[0].text);
   // }
  }

  void insertNewData(String response, isEnglish) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "DoctorBot",
      userData: userData,
      isEnglish: isEnglish,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
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
              size: 16),),
          content: Text('Are you sure you want to delete all messages?', style: appText(
              color: Colors.black,
              isShadow: false,
              weight: FontWeight.w600,
              size: 14),),
          actions: [
            TextButton(
              child: Text('Cancel',style: appText(
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
                  _messages.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _regenerateBotAnswer() async {
    if (_messages.isEmpty) return;

    final lastUserMessageIndex = _messages.indexWhere(
          (message) => message.sender == "user",
    );

    if (lastUserMessageIndex == -1) return;

    final lastBotMessageIndex = _messages.indexWhere(
          (message) => message.sender == "DoctorBot",
    );

    if (lastBotMessageIndex == -1) return;

    setState(() {
      _isTyping = true;
    });

    final lastUserMessage = _messages[lastUserMessageIndex];
    final lastBotMessage = _messages[lastBotMessageIndex];
    _messages.removeAt(lastBotMessageIndex); // Remove the last message (bot's answer)

    final request = CompleteText(
      prompt: "you are a person who only answers medical related questions, when i greet you greet back.\n With that being said my question is: " +
          lastUserMessage.text +
          "?",
      model: kTranslateModelV3, maxTokens: 1000
    );


    RegExp englishPattern = RegExp(r'[a-zA-Z]');
    final response = await chatGPT!.onCompleteText(request: request);
    final regeneratedAnswer = response!.choices[0].text;
    isEnglish = englishPattern.hasMatch(regeneratedAnswer);
    final formattedText = isEnglish ? regeneratedAnswer.replaceFirst('.', '.\n\n').trim() : '\u202B$regeneratedAnswer\u202C'.replaceFirst('.', '.\n').trim();
    insertNewData(formattedText,isEnglish);
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(isEnglish),
            decoration: const InputDecoration.collapsed(
              hintText: "Ask a Question",
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            RegExp englishPattern = RegExp(r'[a-zA-Z]');
            isEnglish = englishPattern.hasMatch(_controller.text);
            _sendMessage(isEnglish);
          },
        ),
      ],
    ).px16();
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
          title:  Center(child: Text("My Doctor",style: appText(
              color: Colors.white,
              isShadow: false,
              weight: FontWeight.bold,
              size: 20))),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: PopupMenuButton<int>(
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                  value: 2,
                  child: Text('Regenerate response', style: appText(
                      color: Colors.black,
                      isShadow: false,
                      weight: FontWeight.w600,
                      size: 14),),
                ),
                  PopupMenuItem(
                    value: 1,
                    child: Text('Delete All Messages', style: appText(
                        color: Colors.red,
                        isShadow: false,
                        weight: FontWeight.w600,
                        size: 14),),
                  ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    _showDeleteConfirmation();
                  }
                  if (value == 2) {
                    _regenerateBotAnswer();
                  }
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: _messages.length == 0
                    ? Center(
                  child: Text(
                    'No Messages',
                    style: appText(
                        color: Colors.grey,
                        isShadow: false,
                        weight: FontWeight.w400,
                        size: 24)
                  ),
                )
                    : ListView.builder(
                  reverse: true,
                  padding: Vx.m4,
                  itemCount: _messages.length * 2 - 1, // Adjust the item count
                  itemBuilder: (context, index) {
                    if (index % 2 == 1) {
                      // Add divider between messages
                      return const Divider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 1.5,
                      );
                    } else {
                      final messageIndex = index ~/ 2;
                      return _messages[messageIndex];
                    }
                  },
                ),
              ),
              if (_isTyping) const ThreeDots(),

              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                ),
                child: _buildTextComposer(),
              )
            ],
          ),
        ));
  }
}