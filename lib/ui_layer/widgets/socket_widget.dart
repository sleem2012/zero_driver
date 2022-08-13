import 'dart:convert';

import 'package:driver/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketWidget extends StatefulWidget {
  const SocketWidget({Key? key}) : super(key: key);

  @override
  _SocketWidgetState createState() => _SocketWidgetState();
}

class _SocketWidgetState extends State<SocketWidget> {
  @override
  void initState() {
    // di.sl<Socket>().on('driver', (data) => print(data));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Socket socket = io(
            //     'http://162.214.191.172:9060',
            //     OptionBuilder()
            //         .setTransports(['websocket']) // for Flutter or Dart VM
            //         // .enableForceNewConnection()
            //         .disableAutoConnect() // disable auto-connection
            //         .build());

            // socket.on('driver', (data) => print(data));

            // socket.onConnect((data) => "connected");
            // socket.onConnectError((data) => "connection error");
            // socket.onDisconnect((data) => "disconnected");
            // socket.emit(
            //   'update_location',
            //   {"id": 55, "lng": 33.5, "lat": 35.5},
            // );
            // socket.on('driver', (data) => print(data));
          },
          child: Text(
            "data",
          ),
        ),
      ),
    );
  }
}
