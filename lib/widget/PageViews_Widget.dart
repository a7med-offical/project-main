// ignore_for_file: prefer_const_constructors, sort_child_properties_last, must_be_immutable

import 'package:flutter/material.dart';

import '../Colors.dart';
import 'Custom_Clipper.dart';
import 'ScrollDot.dart';

class CustomPageView extends StatelessWidget {
  CustomPageView(
      {required this.indexx,
      required this.image,
      required this.onPressed,
      required this.onTap,
      required this.text});

  int indexx;
  Function()? onPressed;
  Function()? onTap;
  String text;
  String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              image,
            ),
          ),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      text,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScrollDot(indexx: indexx, index: 0),
                      ScrollDot(indexx: indexx, index: 1),
                      ScrollDot(indexx: indexx, index: 2),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        indexx > 0
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: background),
                                onPressed: onTap,
                                child: Text(
                                  'Back',
                                  style: TextStyle(color: Colors.white),
                                ))
                            : SizedBox(),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: background),
                            onPressed: onPressed,
                            child: Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  )
                ],
              ),
              height: 300,
              color: Colors.orange[400],
            ),
          ),
        ],
      ),
    );
  }
}
