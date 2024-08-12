import 'package:flutter/material.dart';

class DetailFields extends StatefulWidget {
  final String hintText;
  final bool isEnable;
  final bool obscure;
  final String obscureChar;
  final  controller;  // Updated to explicitly require a TextEditingController

  const DetailFields({
    super.key,
    required this.hintText,
    this.obscureChar = "●",
    this.isEnable = true,
    this.obscure = false,
    this.controller, 
  });

  @override
  State<DetailFields> createState() => _DetailFieldsState();
}

class _DetailFieldsState extends State<DetailFields> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(color: widget.isEnable ? Colors.black : Colors.black87),
        controller: widget.controller,
        obscureText: widget.obscure,
        obscuringCharacter: widget.obscureChar,
        enabled: widget.isEnable,
        maxLines: widget.obscure ? 1 : null, // Disable multiline when obscure is true
        keyboardType: widget.obscure ? TextInputType.visiblePassword : TextInputType.multiline,
        decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black45),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.brown),
          ),
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
