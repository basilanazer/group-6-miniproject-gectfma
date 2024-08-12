import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Complaint_Summary/sergeant_complaint_summary.dart';
import 'package:gectfma/Notifications/notification_send.dart';
import 'package:gectfma/Requirements/DateAndTime.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import 'package:gectfma/downloadpdf/pdf_manager.dart';
import '../../Requirements/DetailFields.dart';
import '../../Requirements/TopBar.dart';

class SergeantApprovedComplaint extends StatefulWidget {
  final String dept;
  final String id;
  //final int total;
  const SergeantApprovedComplaint(
      {super.key, required this.dept, this.id = ""});

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
TextEditingController remarkController = TextEditingController();

TextEditingController fileddateController = TextEditingController();
TextEditingController filedtimeController = TextEditingController();
TextEditingController approveddateController = TextEditingController();
TextEditingController approvedtimeController = TextEditingController();
String assignedStaffName = "";
String assignedStaffNumber = "";
String status = "";
String imageURL = '';
String pdf_content = '';

class _SergeantApprovedComplaintState extends State<SergeantApprovedComplaint> {
  @override
  void initState() {
    
    if (widget.id != "") {
      viewComplaint(widget.id, widget.dept);
    }
    assignedstaffNameController = TextEditingController();
    assignedstaffNumberController = TextEditingController();
    super.initState();
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
          'image': documentSnapshot['image'],
          'nature': documentSnapshot['nature'],
          'status': documentSnapshot['status'],
          'title': documentSnapshot['title'],
          'urgency': documentSnapshot['urgency'],
          'verification_remark': documentSnapshot['verification_remark'],
          'filed_date': documentSnapshot['filed_date'],
          'approved_date': documentSnapshot['approved_date'],
        };
        DateTime filed, approved;
        setState(() {
          contactController.text = data['contact'];
          descController.text = data['desc'];
          hodController.text = data['hod'];
          natureController.text = data['nature'];
          statusController.text = data['status'];
          titleController.text = data['title'];
          urgencyController.text = data['urgency'];
          imageURL = data['image'];
          remarkController.text = data['verification_remark'];
          filed = data['filed_date'].toDate();
          fileddateController.text = formatDate(filed);
          filedtimeController.text = formatTime(filed);
          approved = data['approved_date'].toDate();
          approveddateController.text = formatDate(approved);
          approvedtimeController.text = formatTime(approved);

          pdf_content = '''
Complaint_id :  $id


DEPARTMENT DETAILS 

Department   :  Department Of $dept

HOD          :  ${data['hod']}

Contact      :  ${data['contact']}


COMPLAINT DETAILS

Nature of complaint :  ${data['nature']}

Current status      :  ${data['status']}

Title               :  ${data['title']}

Urgency             :  ${data['urgency']}


COMPLAINT DESCRIPTION

${data['desc']}

Verification Remarks : ${data['verification_remark']}


DATE AND TIME

Filed     :  ${formatDate(filed)}    ${formatTime(filed)}

Approved  :  ${formatDate(data['approved_date'].toDate())}    ${formatTime(data['approved_date'].toDate())} 

''';


        });

        return data;
      } else {
        // print('Document not found');
        return {};
      }
    } catch (e) {
      // Handle errors
      // print("Error getting data: $e");
      return {};
    }
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
            dept: "DEPARTMENT OF ${widget.dept}",
            iconLabel: 'Go Back',
            title: widget.id.toUpperCase(),
            icon: Icons.arrow_back,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Headings(title: "Department Details"),
              TextButton.icon(
                  onPressed: () {
                    final pdfManager = PDFManager();
                      pdfManager.generateAndDownloadPDF(
                        "${widget.id}-${statusController.text}.pdf",
                        pdf_content,
                        imageURL
                      );
                  },
                  label: Text(
                    "View as PDF",
                    selectionColor: Colors.brown[400],
                    style: TextStyle(
                      color: Colors.brown[600],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  icon: Icon(
                    Icons.open_in_new,
                    color: Colors.brown[600],
                  ),
                ),
                
            ],
          ),
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
          const Headings(title: "Complaint Details"),
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
          const Headings(title: "Image"),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Image.network(
              imageURL,
              key: ValueKey(widget.id),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Text('loading image');
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Headings(title: "Urgency level*"),
          DetailFields(
            isEnable: false,
            controller: urgencyController,
            hintText: "Level",
          ),
          const SizedBox(
            height: 20,
          ),
          const Headings(title: "Filed Date and Time"),
          DetailFields(
            isEnable: false,
            hintText: "Date",
            controller: fileddateController,
          ),
          DetailFields(
            isEnable: false,
            hintText: "Time",
            controller: filedtimeController,
          ),
          const SizedBox(
            height: 20,
          ),
          const Headings(title: "Approved Date and Time"),
          DetailFields(
            isEnable: false,
            hintText: "Date",
            controller: approveddateController,
          ),
          DetailFields(
            isEnable: false,
            hintText: "Time",
            controller: approvedtimeController,
          ),
          const SizedBox(
            height: 20,
          ),
          const Headings(title: "Assigned Staff Details"),
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
              minimumSize: const Size(150, 50), // Width and height
            ),
            child: const Text('ASSIGN STAFF'),
          ),
          const SizedBox(
            height: 30,
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
        'assigned_date': DateTime.now()
      });
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("UserTokens")
          .doc(dept)
          .get();
      String token = snap['token'];
      sendPushMessage(token, id.toUpperCase(), "Staff has been assigned");
      int completedCount = 0;
      List<String> depts = [
        'arch',
        'ce',
        'che',
        'cse',
        'ece',
        'ee',
        'me',
        'pe'
      ];
      for (var d in depts) {
        CollectionReference collectionRef =
            FirebaseFirestore.instance.collection(d);
        QuerySnapshot completedSnapshot =
            await collectionRef.where('status', isEqualTo: 'assigned').get();
        completedCount += completedSnapshot.size;
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return const SergeantComplaintSummary(role: "sergeant");
        }),
        (Route<dynamic> route) => false,
      );
      MyDialog.showCustomDialog(context, "Staff Assigned",
          "$assignedStaffName is assigned to complaint $id");
    } catch (e) {
      // Handle errors
      // print("Error updating data: $e");
    }
  }
}
