import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Complaint_Summary/complaint_summary.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import '../Requirements/DetailsField.dart';
import '../Requirements/TopBar.dart';
import 'package:file_picker/file_picker.dart';

class ViewComplaint extends StatefulWidget {
  final String dept;
  final String id;
  const ViewComplaint({super.key, required this.dept, this.id = ""});

  @override
  State<ViewComplaint> createState() => _ViewComplaintState();
}

List<String> levels = ["High", "Medium", "Low"];
String urgency = levels[0];
String? nature;
TextEditingController contactController = TextEditingController();
TextEditingController descController = TextEditingController();
TextEditingController hodController = TextEditingController();
TextEditingController titleController = TextEditingController();
TextEditingController natureController = TextEditingController();
TextEditingController statusController = TextEditingController();
TextEditingController urgencyController = TextEditingController();

class _ViewComplaintState extends State<ViewComplaint> {
  @override
  void initState() {
    // TODO: implement initState
    if (widget.id != "") {
      viewComplaint(widget.id, widget.dept);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          TopBar(
            dept: "DEPARTMENT OF " + widget.dept,
            iconLabel: 'Go Back',
            title: "${widget.id}".toUpperCase(),
            icon: Icons.arrow_back,
          ),
          Headings(title: "Department Details*"),
          DetailFields(
            isEnable: false,
            hintText: widget.dept.toUpperCase(),
          ),
          DetailFields(
            isEnable: false,
            hintText: "Name of HOD",
            controller: hodController,
          ),
          DetailFields(
            isEnable: false,
            hintText: "Contact No",
            controller: contactController,
          ),
          Headings(title: "Complaint Details*"),
          DetailFields(
              isEnable: false,
              controller: natureController,
              hintText: "Nature"),
          DetailFields(
              isEnable: false,
              controller: statusController,
              hintText: "Status"),
          DetailFields(
            isEnable: false,
            controller: titleController,
            hintText: "Title",
          ),
          DetailFields(
            isEnable: false,
            controller: descController,
            hintText: "Description",
          ),
          Headings(title: "Additional documents*"),
          //Image To be added
          DetailFields(isEnable: false, hintText: "Image"),
          SizedBox(
            height: 20,
          ),
          Headings(title: "Urgency level*"),
          DetailFields(
            isEnable: false,
            controller: urgencyController,
            hintText: "Level",
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Row(
          //         children: [
          //           Radio<String>(
          //             groupValue: urgency,
          //             value: levels[0],
          //             onChanged: (value) {
          //               setState(() {
          //                 urgency = value.toString();
          //               });
          //             },
          //             activeColor: Colors.brown[600], // Change the color here
          //           ),
          //           Text("High")
          //         ],
          //       ),
          //       Row(
          //         children: [
          //           Radio<String>(
          //             groupValue: urgency,
          //             value: levels[1],
          //             onChanged: (value) {
          //               setState(() {
          //                 urgency = value.toString();
          //               });
          //             },
          //             activeColor: Colors.brown[600], // Change the color here
          //           ),
          //           Text("Medium")
          //         ],
          //       ),
          //       Row(
          //         children: [
          //           Radio<String>(
          //             groupValue: urgency,
          //             value: levels[2],
          //             onChanged: (value) {
          //               setState(() {
          //                 urgency = value.toString();
          //               });
          //             },
          //             activeColor: Colors.brown[600], // Change the color here
          //           ),
          //           Text("Low")
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    )));
  }
}

Future<Map<String, dynamic>> viewComplaint(String id, String dept) async {
  try {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(dept);

    DocumentSnapshot documentSnapshot = await collectionRef.doc(id).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = {
        'contact': documentSnapshot['contact'],
        'desc': documentSnapshot['desc'],
        'hod': documentSnapshot['hod'],
        //image
        'nature': documentSnapshot['nature'],
        'status': documentSnapshot['status'],
        'title': documentSnapshot['title'],
        'urgency': documentSnapshot['urgency'],
      };
      contactController.text = data['contact'];
      descController.text = data['desc'];
      hodController.text = data['hod'];
      natureController.text = data['nature'];
      statusController.text = data['status'];
      titleController.text = data['title'];
      urgencyController.text = data['urgency'];
      return data;
    } else {
      print('Document not found');
      return {};
    }
  } catch (e) {
    // Handle errors
    print("Error getting data: $e");
    return {};
  }
}
