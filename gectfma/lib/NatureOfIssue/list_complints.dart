import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/TopBar.dart';

class listComplaints extends StatefulWidget {
  final String status;
  final String nature;
  final int number;
  const listComplaints({super.key, required this.status,required this.nature,required this.number});

  @override
  State<listComplaints> createState() => _listComplaintsState();
}

class _listComplaintsState extends State<listComplaints> {
  List<String> deptCollection = ['cse','che','ece','ee','pe','ce','me','arch'];
    @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              for(var i in deptCollection)
              Headings(title: i)
            ],
          ),
        ),
      )
    );
  }
  
}
