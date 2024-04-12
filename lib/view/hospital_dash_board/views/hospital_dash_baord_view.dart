import 'package:flutter/material.dart';

class HospitalDashBoardView extends StatelessWidget {
  const HospitalDashBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              Text('DashBoard'),
              IconButton(
                icon: Icon(Icons.search_outlined),
                onPressed: () {},
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
          )
        ],
      ),
    );
  }
}
