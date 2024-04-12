import 'package:flutter/material.dart';

import '../Colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.text, this.onTap});

  final String? text;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.amber[400], borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            text!,
            style: const TextStyle(
                color: background, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
    );
  }
}
