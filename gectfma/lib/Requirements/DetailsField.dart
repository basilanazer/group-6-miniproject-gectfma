import 'package:flutter/material.dart';

class DetailFields extends StatefulWidget {
  final String hintText;
  final bool isEnable;
  bool obscure;
  final String obscureChar;
  final controller;
  DetailFields({
    Key? key,
    required this.hintText,
    this.obscureChar = "•",
    this.isEnable = true,
    this.obscure = false,
    this.controller,
  }) : super(key: key);

  @override
  State<DetailFields> createState() => _DetailFieldsState();
}

class _DetailFieldsState extends State<DetailFields> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscure,
        obscuringCharacter: widget.obscureChar,
        enabled: widget.isEnable,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.brown),
            ),
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}
