import 'package:bldapp/Colors.dart';
import 'package:flutter/material.dart';

Widget CustomCard(
    {required String path,
    required String name,
    required VoidCallback fun,
    required int select,
    required int index}) {
  return GestureDetector(
    onTap: fun,
    child: Card(
      color: (select == index) ? Colors.amber[400] : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                path,
                height: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (select == index) ? background : Colors.white,
                    fontSize: 20),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
