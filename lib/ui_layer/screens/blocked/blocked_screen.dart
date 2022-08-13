import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nations/nations.dart';

import '../complete_registration/complete_registeration.dart';
import '../support/support_screen.dart';

class BlockedScreen extends StatefulWidget {
  static const routeName = '/blocked-screen';
  const BlockedScreen({Key? key}) : super(key: key);

  @override
  State<BlockedScreen> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'blocked_account'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(
                  FontAwesomeIcons.userCheck,
                ),
                title: Text(
                  "completeRegistration".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, CompleteRegisteration.routeName);
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.help_center,
                ),
                title: Text(
                  "support".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, SupportScreen.routeName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
