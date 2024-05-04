import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gectfma/Login/login_page.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class logout {
  static Future<void> logOut(BuildContext context) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('email'); // Remove email from SharedPreferences
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase Auth
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      ); // Navigate to Login screen
      MyDialog.showCustomDialog(
        context,
        "LOGGING OUT",
        "You have been logged out.",
      ); // Show logout confirmation dialog
    } catch (e) {
      print("Error signing out: $e");
      MyDialog.showCustomDialog(
        context,
        "Error",
        "Failed to log out. Please try again.",
      ); // Show error dialog if sign-out fails
    }
  }
}
