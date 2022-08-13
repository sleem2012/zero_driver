import 'package:driver/ui_layer/widgets/socket_widget.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'google_maps_widget.dart';
import 'package:driver/injection_container.dart' as di;

class PlaceHolderWidget extends StatefulWidget {
  const PlaceHolderWidget({Key? key}) : super(key: key);

  @override
  State<PlaceHolderWidget> createState() => _PlaceHolderWidgetState();
}

class _PlaceHolderWidgetState extends State<PlaceHolderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => ListenLocationWidget(),
                //   ),
                // );
              },
              child: Text(
                "Text",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => GoogleMapsWidget(),
                  ),
                );
              },
              child: Text(
                "Map",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SocketWidget(),
                  ),
                );
              },
              child: Text(
                "socket",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
