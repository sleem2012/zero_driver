import 'package:flutter/material.dart';

import '../../helpers/constants/constants.dart';
import '../../helpers/reusable/reusables.dart';

/// Place holder widget for cached image widget
class CachedImagePlaceholder extends StatelessWidget {
  /// Constructor
  const CachedImagePlaceholder({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  /// widget height
  final double height;

  /// widget width
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: circular10,
        color: kDefaultColor,
      ),
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: circular10,
        child: Image.asset(
          'assets/images/logo.png',
          // 'assets/images/logo.png',
          height: height,
        ),
      ),
    );
  }
}
