
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';

class logout {
  static void logOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to your login screen or any other screen you desire
      // For example:
      Navigator.of(context).pushReplacementNamed('/login');
      MyDialog.showCustomDialog(
          context, "LOGGING OUT", "you have to log back in");
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}