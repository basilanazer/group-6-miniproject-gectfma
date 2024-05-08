import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/NatureOfIssue/comp_verification.dart';
import 'package:gectfma/NatureOfIssue/list_complints.dart';
import 'package:gectfma/Notifications/notification_send.dart';
import 'package:gectfma/Requirements/DateAndTime.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import 'package:gectfma/downloadpdf/pdf_manager.dart';
import '../Requirements/DetailFields.dart';
import '../Requirements/TopBar.dart';

class approveOrDecline extends StatefulWidget {
  final String dept;
  final String id;
  //final int number;
  const approveOrDecline({super.key, required this.dept, this.id = ""});

  @override
  State<approveOrDecline> createState() => _approveOrDeclineState();
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
TextEditingController remarkController = TextEditingController();
TextEditingController fileddateController = TextEditingController();
TextEditingController filedtimeController = TextEditingController();
String imageURL = '';
String pdf_content = '';

class _approveOrDeclineState extends State<approveOrDecline> {
  String remark = '';
  @override
  void initState() {
    // TODO: implement initState
    if (widget.id != "") {
      viewComplaint(widget.id, widget.dept);
    }
    remarkController = TextEditingController();
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
          'filed_date': documentSnapshot['filed_date']
        };
        DateTime filed;

        setState(() {
          imageURL = data['image'];
          contactController.text = data['contact'];
          descController.text = data['desc'];
          hodController.text = data['hod'];
          natureController.text = data['nature'];
          statusController.text = data['status'];
          titleController.text = data['title'];
          urgencyController.text = data['urgency'];
          filed = data['filed_date'].toDate();
          fileddateController.text = formatDate(filed);
          filedtimeController.text = formatTime(filed);
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


DATE AND TIME

Filed     :  ${formatDate(filed)}    ${formatTime(filed)}


''';


        });
        // print(data);
        // print(imageURL);
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
            dept: "DEPARTMENT OF " + widget.dept,
            iconLabel: 'Go Back',
            title: "${widget.id}".toUpperCase(),
            icon: Icons.arrow_back,
            goto: () {
              Navigator.of(context).pop();
            },
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
            hintText: "Name of HOD",
            controller: hodController,
          ),
          DetailFields(
            isEnable: false,
            hintText: "Contact No",
            controller: contactController,
          ),
          Headings(title: "Complaint Details"),
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
          Headings(title: "Image"),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
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
                return Text('Error loading image');
              },
            ),
          ),
          Headings(title: "Urgency level"),
          DetailFields(
            isEnable: false,
            controller: urgencyController,
            hintText: "Level",
          ),
          SizedBox(
            height: 20,
          ),
          Headings(title: "Complaint Filed Date and Time"),
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
          SizedBox(
            height: 20,
          ),
          Headings(title: "Remarks*"),
          DetailFields(
            hintText: "Remarks",
            controller: remarkController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    remark = remarkController.text;
                  });
                  addRemark(widget.dept, widget.id, remark, "approved");
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.green[100], // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Corner radius
                  ),
                  minimumSize: Size(150, 50), // Width and height
                ),
                child: Text('APPROVE'),
              ),
              ElevatedButton(
                onPressed: () {
                  addRemark(widget.dept, widget.id, remarkController.text,
                      "declined");
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.red[100], // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Corner radius
                  ),
                  minimumSize: Size(150, 50), // Width and height
                ),
                child: Text('DECLINE'),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    )));
  }

  void addRemark(String dept, String id, String remark, String status) async {
    try {
      if (remark == '') {
        MyDialog.showCustomDialog(
          context,
          "ERROR!!",
          "Remark should be given",
        );
      } else {
        // Get a reference to the specific document with the custom ID
        DocumentReference docRef =
            FirebaseFirestore.instance.collection(dept).doc(id);

        // Set the data in the document with the custom ID
        await docRef.update({
          'verification_remark': remark,
          'status': status,
          if (status == 'approved')
            'approved_date': DateTime.now()
          else
            'declined_date': DateTime.now()
        });
        // Navigator.of(context)
        //     .pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
        //       return complaintVerification(nature: natureController.text);
        //     }),(Route<dynamic> route) => false,);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return complaintVerification(nature: natureController.text);
        }), (route) => route is complaintVerification);
        MyDialog.showCustomDialog(
            context, "STATUS UPDATED", "Remarks added and Status is updated");
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection("UserTokens")
            .doc(dept)
            .get();
        String token = snap['token'];
        sendPushMessage(token, "${id.toUpperCase()}",
            "${id.toUpperCase()} has been $status");
        if (status == "approved") {
          DocumentSnapshot snap2 = await FirebaseFirestore.instance
              .collection("UserTokens")
              .doc("sergeant")
              .get();
          String token2 = snap2['token'];
          sendPushMessage(token2, "${id.toUpperCase()}",
              "${id.toUpperCase()} has been $status");
        }
      }
    } catch (e) {
      // print("Error adding document: $e");
      MyDialog.showCustomDialog(
        context,
        "ERROR!!",
        "Some error occured. Please try again",
      ); // Handle errors here
    }
  }
}
