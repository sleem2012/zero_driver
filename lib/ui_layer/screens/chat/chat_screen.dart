import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/ui_layer/widgets/current_trip_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nations/nations.dart';

import '../../helpers/constants/constants.dart';

final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    _firestore.clearPersistence();
    intl.Intl.defaultLocale = 'en';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ChatParams;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kDefaultColor,
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "chat_observed".tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Body(chatParams: args),
            ),
          ),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  final ChatParams chatParams;
  const Body({
    Key? key,
    required this.chatParams,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    _firestore
        .collection(
      "${widget.chatParams.tripInfo.requestId}",
    )
        .add({
      'text': "",
      'sender': getUserPhone(),
    }).then((_) {
      print("collection created");
    }).catchError((_) {
      print("an error occured");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MessagesStream(
      chatParams: widget.chatParams,
    );
  }
}

class MessagesStream extends StatefulWidget {
  final ChatParams chatParams;
  const MessagesStream({
    Key? key,
    required this.chatParams,
  }) : super(key: key);

  @override
  State<MessagesStream> createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  ChatUser user = ChatUser(
    id: getUserPhone()!,
    // firstName: 'Charles',
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(
            widget.chatParams.tripInfo.requestId.toString(),
          )
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        log(snapshot.data!.docs.reversed.toString());
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        log("messages: ${messages.length}");
        log("userPhone${getUserPhone().toString()}");
        List<ChatMessage> dashMessages = [];
        for (var message in messages) {
          log('message: ${message.data()}');
          final messageText = (message.data() as Map)['text'];
          log("messageText: $messageText");
          // ['text'];
          final messageSender = (message.data() as Map)['sender'];
          log("messageSender: $messageSender");
          // !['sender'];
          final timeStamp = (message.data() as Map)['timestamp'];
          log("timeStamp: $timeStamp");
          final chatMessage = ChatMessage(
              user: ChatUser(id: messageSender),
              createdAt: DateTime.now(),
              // (timeStamp as Timestamp).toDate()
              text: messageText);
          if (chatMessage.text.isNotEmpty || chatMessage.text != null) {
            dashMessages.add(chatMessage);
          }
        }

        return DashChat(
          currentUser: user,
          onSend: (ChatMessage m) {
            setState(() {
              dashMessages.insert(0, m);
            });
            //  messageTextController.clear();
            _firestore
                .collection(
              widget.chatParams.tripInfo.requestId.toString(),
            )
                .add({
              'text': m.text,
              'sender': getUserPhone(),
              'timestamp': FieldValue.serverTimestamp(),
            });
          },
          messages: dashMessages,
        );
        // return Expanded(
        //   child: ListView(
        //     reverse: true,
        //     padding:
        //         const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        //     children: messageBubbles,
        //   ),
        // );
      },
    );
  }
}
