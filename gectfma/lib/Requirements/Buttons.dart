import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final String buttonTitle;
  final Function() fn;
  const Buttons({
    Key? key,
    required this.buttonTitle,
    required this.fn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        width: 300,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.brown[600], borderRadius: BorderRadius.circular(10)),
        child: TextButton(
          onPressed: fn,
          child: Text(
            buttonTitle,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ));
  }
}
