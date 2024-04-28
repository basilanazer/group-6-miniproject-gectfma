import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import 'package:gectfma/View_Complaints/Sergeant/sergeant_view_all_complaint.dart';
import '../../Requirements/DetailFields.dart';
import '../../Requirements/TopBar.dart';

class SergeantApprovedComplaint extends StatefulWidget {
  final String dept;
  final String id;
  final int total;
  const SergeantApprovedComplaint(
      {super.key, required this.dept, this.id = "",required this.total});

  @override
  State<SergeantApprovedComplaint> createState() =>
      _SergeantApprovedComplaintState();
}

/*
This page accessed when complaint approved but staff has not yet been assigned
 */
TextEditingController contactController = TextEditingController();
TextEditingController descController = TextEditingController();
TextEditingController hodController = TextEditingController();
TextEditingController titleController = TextEditingController();
TextEditingController natureController = TextEditingController();
TextEditingController statusController = TextEditingController();
TextEditingController urgencyController = TextEditingController();
TextEditingController assignedstaffNameController = TextEditingController();
TextEditingController assignedstaffNumberController = TextEditingController();
String assignedStaffName = "";
String assignedStaffNumber = "";
String status = "";

class _SergeantApprovedComplaintState extends State<SergeantApprovedComplaint> {
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
            goto: () {
              Navigator.of(context).pop();
            },
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
          Headings(title: "Assigned Staff Details"),
          DetailFields(
            hintText: "Assigned Staff Name",
            controller: assignedstaffNameController,
          ),
          DetailFields(
            hintText: "Assigned Staff Number",
            controller: assignedstaffNumberController,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                assignedStaffName = assignedstaffNameController.text;
                assignedStaffNumber = assignedstaffNumberController.text;
                status = "assigned";
              });
              updateAssignedStaff(widget.id, widget.dept);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.brown[50],
              backgroundColor: Colors.brown[800], // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Corner radius
              ),
              minimumSize: Size(150, 50), // Width and height
            ),
            child: Text('ASSIGN STAFF'),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    )));
  }
  Future<void> updateAssignedStaff(String id, String dept) async {
  try {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(dept);

    // Update the document
    await collectionRef.doc(id).update({
      'assigned_staff': assignedStaffName,
      'assigned_staff_no': assignedStaffNumber,
      'status': status,
    });
    Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
            return SergeantViewAllComplaint(total: widget.total+1,status:'assigned',);
          }),
          (Route<dynamic> route) => false,
        );
    MyDialog.showCustomDialog(context, "Staff Assigned", "$assignedStaffName is assigned to complaint $id");
    
  } catch (e) {
    // Handle errors
    print("Error updating data: $e");
  }
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

