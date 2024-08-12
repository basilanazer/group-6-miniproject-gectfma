import 'package:flutter/material.dart';
import 'package:gectfma/Complaint_Summary/complaint_summary.dart';
import 'package:gectfma/Login/logout.dart';
import 'package:gectfma/NatureOfIssue/comp_verification.dart';
import 'package:gectfma/Requirements/Buttons.dart';
import 'package:gectfma/Requirements/TopBar.dart';

class NatureOfIssue extends StatelessWidget {
  final String dept;
  const NatureOfIssue({super.key, required this.dept});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              // Show exit confirmation dialog
              bool exit = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.amber[50],
                  title: const Text('Are you sure you want to exit?'),
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
            child: Scaffold(
              body: Column(
                children: <Widget>[
                  TopBar(
                      goto: () {
                        logout.logOut(context, dept);
                      },
                      iconLabel: "Log Out",
                      title: "navigate to",
                      icon: Icons.logout,
                      dept: "DEPARTMENT OF $dept"),
                  Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Buttons(
                        buttonTitle: "MY COMPLAINTS",
                        fn: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ComplaintSummary(
                              deptName: dept,
                            );
                          }));
                        },
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Buttons(
                          buttonTitle: "COMPLAINTS TO VERIFY",
                          fn: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const complaintVerification(
                                  nature: "Electrical");
                            }));
                          })
                    ],
                  )
                ],
              ),
            )));
  }
}
