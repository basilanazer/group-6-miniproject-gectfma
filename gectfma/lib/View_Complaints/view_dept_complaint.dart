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
                iconLabel: "Go Back",
                title: "ALL COMPLAINTS",
                icon: Icons.arrow_back,
                dept:  "DEPARTMENT OF $widget.dept",
          )],
          ),
        )
      )
    );
  }
  
}