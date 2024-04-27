import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gectfma/Complaint_Summary/sergeant_complaint_sergeant.dart';
import 'package:gectfma/Login/forgot_pw.dart';
import 'package:gectfma/NatureOfIssue/comp_verification.dart';
import 'package:gectfma/NatureOfIssue/nature.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import 'package:gectfma/View_Complaints/view_complaint_summary.dart';
import '../Requirements/DetailsField.dart';
import '../Complaint_Summary/complaint_summary.dart';

class Login extends StatefulWidget {
  Login({
    Key? key,
  }) : super(key: key);
  final String plumbingInCharge = "vmeera";
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final paswdController = TextEditingController();
  String deptOrDesignation = "";
  String email = "";
  String pswd = "";

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.brown[50],
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
                  'yes',
                  style: TextStyle(color: Colors.brown[800]),
                ),
              ),
            ],
          ),
        );

        // Return exit if user confirmed, otherwise don't exit
        return exit ?? false;
      },
        child: ListView(
          children: [
            Column(children: <Widget>[
              SizedBox(
                height: 90,
              ),
              Text(
                "Government Engineering College Thrissur".toUpperCase(),
                style: TextStyle(
                    color: Colors.brown[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/images/logo.png")),
              SizedBox(
                height: 20,
              ),
              Text("LOGIN",
                  style: TextStyle(
                    color: Colors.brown[800],
                    fontSize: 25,
                  )),
              SizedBox(
                height: 20,
              ),
              DetailFields(
                hintText: "Enter Email",
                controller: emailController,
              ),
              DetailFields(
                hintText: "Enter Password",
                controller: paswdController,
                obscure: true,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 370,
                  decoration: BoxDecoration(
                      color: Colors.brown[800],
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        email = emailController.text;
                        pswd = paswdController.text;
                        if (email.isNotEmpty)
                          deptOrDesignation = email.split("@")[0].substring(3);
                        if (email.split("@")[0] == "sergeant") {
                          deptOrDesignation = "Sergeant";
                        } else if (email.split("@")[0] == "principal") {
                          deptOrDesignation = "Principal";
                        } else if (email.split("@")[0] ==
                            widget.plumbingInCharge) {
                          deptOrDesignation = widget.plumbingInCharge;
                        }
                      });
                      login(email, pswd, deptOrDesignation, context);
                    },
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              TextButton(
                child: Text("Forgot Password?",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.brown[800],
                    )),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ForgotPasswordPage();
                  }));
                },
              )
            ]),
          ],
        )));
  }

  void login(String email, String password, String deptOrDesignation,
      BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Login successful, navigate to home page
      if (deptOrDesignation == "ee") {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return NatureOfIssue(
            dept: deptOrDesignation,
          );
        }));
      } 
      else if(email=='vmeera@gectcr.ac.in'){
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return complaintVerification(nature: "Plumbing");
        }));
      }
      else if (deptOrDesignation == "Sergeant") {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return SergeantComplaintSummary(
            deptName: deptOrDesignation,
          );
        }));
      }
      // else if (deptOrDesignation != "Sergeant" &&
      //     deptOrDesignation != "Principal") {
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (context) {
      //     return SergeantComplaintSummary(
      //       deptName: deptOrDesignation,
      //     );
      //   }));
      // } 
      else if (deptOrDesignation == "Principal") {
        // Navigator.of(context)
        //     .pushReplacement(MaterialPageRoute(builder: (context) {
        //   return (
        //     deptName: deptOrDesignation,
        //   );
        // }));
      }
      
      else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return ComplaintSummary(
            deptName: deptOrDesignation,
          );
        }));
      }
    } on FirebaseAuthException catch (e) {
      // Login failed, handle error
      print('Error logging in user: $e');
      MyDialog.showCustomDialog(context, "LOGIN FAILED",
          "Incorrect email or password. Please try again.");
    }
  }
}
