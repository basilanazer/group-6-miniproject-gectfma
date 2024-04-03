import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Requirements/DetailsField.dart';
import '../Complaint_Summary/complaint_summary.dart';
import 'forgot_pswd.dart';

class Login extends StatefulWidget {
  Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final paswdController = TextEditingController();
  String dept = "";
  String email = "";
  String pswd = "";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(children: <Widget>[
          SizedBox(
            height: 90,
          ),
          Text(
            "Government Engineering College Thrissur".toUpperCase(),
            style: TextStyle(color: Colors.brown[600],fontWeight: FontWeight.bold, fontSize: 16),
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
                  color: Colors.brown[300],
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    email = emailController.text;
                    pswd = paswdController.text;
                    if (email.isNotEmpty)
                      dept = email.split("@")[0].substring(3);
                  });
                  login(email, pswd,dept,context);
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) {
                  //   return ComplaintSummary(
                  //     deptName: dept,
                  //   );
                  // }));
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
                  color: Colors.blue,
                )),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ForgotPaswd();
              }));
            },
          )
        ]),
      ],
    );
  }
  void login(String email, String password,String dept, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Login successful, navigate to home page
      Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ComplaintSummary(
                      deptName: dept,
                    );
                  }));
    } catch (e) {
      // Login failed, handle error
      print('Error logging in user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please try again.'),
        ),
      );
    }
  }
}
