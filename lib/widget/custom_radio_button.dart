import 'package:bldapp/Colors.dart';
import 'package:bldapp/Provider/ProvidetUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomRadioButton extends StatelessWidget {
  CustomRadioButton({
    super.key,
    required this.index,
    required this.selected,
    required this.text,
    required this.fun,
  });
  String text;
  int index;
  int selected;
  VoidCallback fun;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        decoration: BoxDecoration(
            color: (selected == index) ? Colors.amber[400] : Colors.grey,
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color:
                        (selected == index) ? Colors.amber : Colors.white70)),
            onPressed: fun,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                text,
                style: TextStyle(
                    color: (selected == index) ? background : Colors.black,
                    fontSize: 20),
              ),
            ),
          ),
        ));
  }
}
