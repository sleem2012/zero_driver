import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen() {
  Socket socket = io(
      'http://162.214.191.172:9060',
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection

          .build());
  socket.onConnect((data) => print('connected'));
}

//Step3: Build widgets with streambuilder

class BuildWithSocketStream extends StatefulWidget {
  const BuildWithSocketStream({Key? key}) : super(key: key);

  @override
  State<BuildWithSocketStream> createState() => _BuildWithSocketStreamState();
}

class _BuildWithSocketStreamState extends State<BuildWithSocketStream> {
  @override
  void initState() {
    connectAndListen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: streamSocket.getResponse,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Container(
              child: Text(snapshot.data ?? 'N/A'),
            );
          },
        ),
      ),
    );
  }
}
