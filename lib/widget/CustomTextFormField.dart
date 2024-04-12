// ignore_for_file: unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {this.text,
      this.suffixIcon,
      this.isVisable = false,
      this.onChanged,
      this.validator,
      this.onPressed,
      this.textInputType = TextInputType.emailAddress,
      this.controller});

  final String? text;
  final IconData? suffixIcon;
  final bool? isVisable;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Function()? onPressed;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      onChanged: onChanged,
      obscureText: isVisable!,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              suffixIcon,
              color: background,
            ),
          ),
        ),
        errorStyle: TextStyle(color: Colors.white),
        hintText: text,
        hintStyle: const TextStyle(color: background, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 5,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 5,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
