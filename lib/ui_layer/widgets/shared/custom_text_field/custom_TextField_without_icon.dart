import 'package:flutter/material.dart';

/// Custom text form field without icon
class CustomTextFieldWithoutIcon extends StatelessWidget {
  ///

  const CustomTextFieldWithoutIcon({
    Key? key,
    required this.hintLabel,
    required this.controller,
    required this.textInputType,
    required this.validator,
    required this.textInputAction,
    this.obsecureText,
  }) : super(key: key);

  /// hint text
  final String hintLabel;

  /// Text Editing Controller
  final TextEditingController controller;

  /// keyboard input type
  final TextInputType textInputType;

  /// validator
  final String? Function(String?) validator;

  /// text input action
  final TextInputAction textInputAction;

  /// obsecure text
  final bool? obsecureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: obsecureText ?? false,
        validator: validator,
        keyboardType: textInputType,
        controller: controller,
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: hintLabel,
          filled: true,
          fillColor: Colors.white,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.circular(24.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.circular(24.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.circular(24.0),
          ),
        ),
      ),
    );
  }
}
