import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:flutter/material.dart';

/// Constructor
class CustomTextField extends StatelessWidget {
  /// Customized text field
  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.icon,
    required this.backgroundColor,
    required this.onSubmitted,
    required this.controller,
    required this.validator,
  }) : super(key: key);

  /// label text
  final String labelText;

  /// text field icon
  final Widget icon;

  /// text field background icon
  final Color backgroundColor;

  ///
  final Function onSubmitted;

  /// controller
  final TextEditingController controller;

  /// validator
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: TextFormField(
        // initialValue: controller.text,
        textInputAction: TextInputAction.next,
        validator: validator,
        onFieldSubmitted: (String val) {
          onSubmitted();
        },
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFFCFDFD),
          labelText: labelText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(
                4.0,
              ),
              decoration: BoxDecoration(
                borderRadius: circular24,
                color: backgroundColor,
              ),
              child: icon,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
            borderRadius: BorderRadius.all(
              Radius.circular(
                25,
              ),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
            borderRadius: BorderRadius.all(
              Radius.circular(
                25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
