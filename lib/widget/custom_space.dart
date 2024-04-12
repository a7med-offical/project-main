import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Divider(color: Colors.grey),
        SizedBox(height: 5),
      ],
    );
  }
}
