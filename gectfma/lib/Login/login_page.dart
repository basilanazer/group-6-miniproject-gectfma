import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Complaint_Summary/complaint_summary.dart';
import 'package:gectfma/Complaint_Summary/sergeant_complaint_summary.dart';
import 'package:gectfma/Login/forgot_pw.dart';
import 'package:gectfma/NatureOfIssue/comp_verification.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import 'package:gectfma/NatureOfIssue/nature.dart';
import 'package:gectfma/View_Complaints/Principal/principal_view_all_complaint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save email to SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('email', email);

      // Fetch user role and department from Firestore
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      final dept = userDoc['dept'] as String?;
      final role = userDoc['role'] as String?;

      // print("email : $email");
      // print("dept : $dept");
      // print("role : $role");
      if (dept != null && dept != '') {
        await FirebaseMessaging.instance.getToken().then((token) {
          FirebaseFirestore.instance.collection("UserTokens").doc(dept).set({
            'token': token,
          });
        });
        if (dept == 'ee') {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return NatureOfIssue(dept: dept);
          }));
        } else {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return ComplaintSummary(deptName: dept);
          }));
        }
      } else {
        if (role != null && role != '') {
          await FirebaseMessaging.instance.getToken().then((token) {
            FirebaseFirestore.instance.collection("UserTokens").doc(role).set({
              'token': token,
            });
          });
          if (role == 'sergeant') {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return SergeantComplaintSummary(role: role);
            }));
          } else if (role == 'principal') {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return const PrincipalViewAllComplaint();
            }));
          } else {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return const complaintVerification(nature: "Plumbing");
            }));
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      // print('Error logging in user: $e');
      MyDialog.showCustomDialog(context, "Login Failed",
          "Incorrect email or password. Please try again.");
    } catch (e) {
      // print('Error: $e');
      MyDialog.showCustomDialog(
          context, "Error", "An error occurred. Please try again later.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: WillPopScope(
        onWillPop: () async {
          // Show exit confirmation dialog
          bool exit = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.amber[50],
              title: Text('Are you sure you want to exit?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Close the dialog and return false
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.brown[800]),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Close the dialog and return true
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.brown[800]),
                  ),
                ),
              ],
            ),
          );

          // Return exit if user confirmed, otherwise don't exit
          return exit;
        },
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                SizedBox(height: 90),
                Text(
                  "Government Engineering College Thrissur".toUpperCase(),
                  style: TextStyle(
                      color: Colors.brown[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(height: 20),
                Container(
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/images/logo.png"),
                ),
                SizedBox(height: 20),
                Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.brown[800], fontSize: 25),
                ),
                SizedBox(height: 20),
                _buildTextField("Enter Email", emailController),
                _buildTextField("Enter Password", passwordController,
                    obscureText: true),
                SizedBox(height: 10),
                _buildLoginButton(context),
                SizedBox(height: 10),
                _buildForgotPasswordButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.brown.shade800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.brown[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () => _login(context),
          child: Text(
            "LOGIN",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      child: Text(
        "Forgot Password?",
        style: TextStyle(
            decoration: TextDecoration.underline, color: Colors.brown[800]),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ForgotPasswordPage();
        }));
      },
    );
  }
}















