import 'package:flutter/material.dart';

import '../../../../../core/utils/styles.dart';

class CustomTextFormFiled extends StatelessWidget {
  const CustomTextFormFiled({super.key, required this.textEditingController, required this.label, this.obscureText, required this.suffixIcon});

  final TextEditingController textEditingController;
  final String label;
  final Widget suffixIcon;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      controller: textEditingController,
      style: Styles.fontStyle26.copyWith(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white,),
          borderRadius: BorderRadius.circular(12),
        ),
        label: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: Styles.fontStyle26.copyWith(color: Colors.white, fontSize: 18),
          ),
        ),
        suffix: suffixIcon
      ),
    );
  }
}
