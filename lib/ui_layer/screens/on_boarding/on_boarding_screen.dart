import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:nations/nations.dart';

///
class OnBoardingScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  /// On Boarding Screen
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: IntroductionScreen(
          pages: <PageViewModel>[
            PageViewModel(
              title: 'kTitle',
              decoration: const PageDecoration(
                titleTextStyle: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              bodyWidget: Text('longText'.tr),
              image: Image.asset(
                'assets/images/welcome1_icon.png',
                fit: BoxFit.cover,
              ),
            ),
            PageViewModel(
              title: 'kTitle',
              decoration: const PageDecoration(
                titleTextStyle: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              bodyWidget: Text('longText'.tr),
              image: Image.asset(
                'assets/images/welcome2_icon.png',
              ),
            ),
            PageViewModel(
              title: 'kTitle',
              decoration: const PageDecoration(
                titleTextStyle: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              bodyWidget: Text('longText'.tr),
              image: Image.asset(
                'assets/images/welcome3_icon.png',
              ),
            ),
          ],
          onDone: () async {},
          onSkip: () {
            // You can also override onSkip callback
          },
          showSkipButton: false,
          skip: const Icon(
            Icons.arrow_forward,
          ),
          next: const Icon(Icons.arrow_forward),
          done:
              const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: circular24,
            ),
          ),
        ),
      ),
    );
  }
}
