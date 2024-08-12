import 'package:flutter/material.dart';

class Headings extends StatelessWidget {
  final String title;
  const Headings({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(title.toUpperCase(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.brown[600])),
      ),
    );
  }
}
