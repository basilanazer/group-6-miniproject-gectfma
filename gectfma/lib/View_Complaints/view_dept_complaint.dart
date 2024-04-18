import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/TopBar.dart';

class viewDeptComplaints extends StatefulWidget {
  final String dept; // Declare dept variable here

  const viewDeptComplaints({super.key, required this.dept});

  @override
  State<viewDeptComplaints> createState() => _viewDeptComplaintsState(); 
  
}

class _viewDeptComplaintsState extends State<viewDeptComplaints> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TopBar(
                iconLabel: "Home",
                title: "ALL COMPLAINTS",
                icon: Icons.home,
                dept: "DEPARTMENT OF ${widget.dept}"),
            ],
          ),
        )
      )
    );
  }
  
}