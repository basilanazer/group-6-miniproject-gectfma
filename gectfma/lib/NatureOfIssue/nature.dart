import 'package:flutter/material.dart';
import 'package:gectfma/Complaint_Summary/complaint_summary.dart';
import 'package:gectfma/File_Complaint/file_complaint.dart';
import 'package:gectfma/Requirements/Buttons.dart';
import 'package:gectfma/Requirements/TopBar.dart';

class NatureOfIssue extends StatelessWidget {
  final String deptOrDesignation;
  const NatureOfIssue({super.key, required this.deptOrDesignation});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: <Widget>[
          TopBar(
              iconLabel: "Logout",
              title: "navigate to",
              icon: Icons.logout,
              dept: "Welcome ${deptOrDesignation}"),
          Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Buttons(
                buttonTitle: "MY COMPLAINTS",
                fn: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ComplaintSummary(
                      deptName: deptOrDesignation,
                    );
                  }));
                },
              ),
              SizedBox(
                height: 100,
              ),
              Buttons(
                  buttonTitle: "TO BE APPROVED",
                  fn: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ComplaintSummary(
                        deptName: deptOrDesignation,
                      );
                    }));
                  })
            ],
          )
        ],
      ),
    ));
  }
}
