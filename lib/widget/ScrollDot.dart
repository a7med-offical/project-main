import 'package:flutter/material.dart';

import '../Colors.dart';

class ScrollDot extends StatelessWidget {
  const ScrollDot({
    super.key,
    required this.indexx,
    required this.index,
  });

  final int indexx;
  final int index;

  @override
  Widget build(BuildContext context) {
    Color _color = index == indexx ? background : Colors.grey;
    return Container(
      margin: EdgeInsets.all(4),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color,
      ),
    );
  }
}
