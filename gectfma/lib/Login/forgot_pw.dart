// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/DetailFields.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    String email = "";
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 80,
                          width: 800,
                          child: Image.asset("assets/images/tiny-lock.png")),
                      const SizedBox(height: 20),
                      Text("Trouble logging in?",
                          style: TextStyle(
                            color: Colors.brown[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Enter your email and we'll send you a link to get back into your account.",
                          style: TextStyle(
                            color: Colors.brown[800],
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center, // Center align the text
                        ),
                      ),

                      const SizedBox(height: 20),
                      DetailFields(
                        hintText: "Enter Email",
                        controller: emailController,
                      ),
                      const SizedBox(height: 10),
                      // Add spacing between text field and button
                      if (isloading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                        onPressed: () {
                          setState(() {
                            email = emailController.text.trim();
                          });
                          resetpswd(email, context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.brown[50],
                          backgroundColor: Colors.brown[800], // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Corner radius
                          ),
                          minimumSize: const Size(350, 60), // Width and height
                        ),
                        child: const Text('Reset Password'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Back to Login',
                          style: TextStyle(
                            color: Colors.brown[800],
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ), // Add additional spacing below the container
          ],
        ),
      ),
    );
  }

  void resetpswd(String email, BuildContext context) async {
    setState(() {
      isloading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      MyDialog.showCustomDialog(
        context,
        "EMAIL SENT",
        "An email containing instructions to reset your password has been sent to your email address. Please check your inbox and follow the instructions provided.If you don't receive the email, check your spam folder.",
      );
    } on FirebaseAuthException {
      // print(e);
      MyDialog.showCustomDialog(
          context, 'ERROR!!', "Incorrect email. Please try again.");
    }
    finally{
      setState(() {
        isloading = false;
      });
    }
  }
}
