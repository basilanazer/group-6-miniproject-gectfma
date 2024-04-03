import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/TopBar.dart';

class ForgotPaswd extends StatelessWidget {
  const ForgotPaswd({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TopBar(
            dept: "",
            iconLabel: "Go Back",
            title: "Forgot Password",
            icon: Icons.arrow_back_sharp),
      ),
    );
  }
}
