import 'package:flutter/material.dart';

import 'custom_text_field/custom_TextField_without_icon.dart';

class BuildLoginSignUpTextBox extends StatelessWidget {
  const BuildLoginSignUpTextBox({
    Key? key,
    required this.hintLabel,
    required this.controller,
    required this.textInputType,
    required this.validator,
    required this.function,
    required this.obsecureText,
  }) : super(key: key);

  /// hint text
  final String hintLabel;

  /// Text Editing Controller
  final TextEditingController controller;

  /// keyboard input type
  final TextInputType textInputType;

  /// validator
  final String? Function(String?) validator;

  ///
  final VoidCallback? function;
  final bool obsecureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: CustomTextFieldWithoutIcon(
                obsecureText: obsecureText,
                textInputAction: TextInputAction.next,
                validator: validator,
                controller: controller,
                hintLabel: hintLabel,
                textInputType: textInputType,
              ),
            ),
          ),
          InkWell(
            onTap: function,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                //    color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/icons/clear_icon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
    );
  }
}
