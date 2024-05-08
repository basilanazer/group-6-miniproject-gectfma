// ignore_for_file: unused_local_variable, use_build_context_synchronously, non_constant_identifier_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Complaint_Summary/sergeant_complaint_summary.dart';
import 'package:gectfma/Notifications/notification_send.dart';
import 'package:gectfma/Requirements/DateAndTime.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import 'package:gectfma/downloadpdf/pdf_manager.dart';
import '../Requirements/DetailFields.dart';
import '../Requirements/TopBar.dart';

class ViewComplaint extends StatefulWidget {
  final String dept;
  final String id;
  final String designation;
  const ViewComplaint(
      {super.key, required this.dept, this.id = "", this.designation = ""});

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
TextEditingController staffNameController = TextEditingController();
TextEditingController staffNumberController = TextEditingController();
TextEditingController remarkController = TextEditingController();
TextEditingController reviewController = TextEditingController();
TextEditingController fileddateController = TextEditingController();
TextEditingController filedtimeController = TextEditingController();
TextEditingController approveddateController = TextEditingController();
TextEditingController approvedtimeController = TextEditingController();
TextEditingController assigneddateController = TextEditingController();
TextEditingController assignedtimeController = TextEditingController();
TextEditingController completeddateController = TextEditingController();
TextEditingController completedtimeController = TextEditingController();
//TextEditingController sergeantRemarksController = TextEditingController();
TextEditingController declineddateController = TextEditingController();
TextEditingController declinedtimeController = TextEditingController();

String status = "";
String imageURL = '';
String str_rating_no = '';
String pdf_content = '';

class _ViewComplaintState extends State<ViewComplaint> {
  @override
  void initState() {
    // implement initState
    if (widget.id != "") {
      viewComplaint(widget.id, widget.dept);
    }
    super.initState();
  }

  void clearAll() {
    // implement dispose
    hodController.clear();
    contactController.clear();
    titleController.clear();
    descController.clear();
    natureController.clear();
    statusController.clear();
    urgencyController.clear();
    staffNameController.clear();
    staffNumberController.clear();
    assigneddateController.clear();
    assignedtimeController.clear();
    fileddateController.clear();
    filedtimeController.clear();
    completeddateController.clear();
    completedtimeController.clear();
    approveddateController.clear();
    approvedtimeController.clear();
    //sergeantRemarksController.clear();
    declineddateController.clear();
    declinedtimeController.clear();
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
            dept: "DEPARTMENT OF ${widget.dept}",
            iconLabel: 'Go Back',
            title: widget.id.toUpperCase(),
            icon: Icons.arrow_back,
            goto: () {
              clearAll();
              Navigator.of(context).pop();
            },
          ),
          //const SizedBox(height: 10,),
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
          const Headings(title: "Urgency level"),
          DetailFields(
            isEnable: false,
            controller: urgencyController,
            hintText: "Level",
          ),
          const SizedBox(
            height: 20,
          ),
          //Complaint Filed Date And Time
          const Headings(title: "Complaint Filed Date and Time"),
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
          //Verification Remarks
          if (['approved', 'assigned', 'completed','declined']
              .contains(statusController.text))
            Column(children: [
              const Headings(title: "Verification remarks"),
              DetailFields(
                isEnable: false,
                hintText: "no remarks given",
                controller: remarkController,
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          //Approved Date and Time
          if (['approved', 'assigned', 'completed']
              .contains(statusController.text))
            Column(
              children: [
                const Headings(title: "Complaint Approved Date and Time"),
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
              ],
            ),
          if (['declined'].contains(statusController.text))
            Column(
              children: [
                const Headings(title: "Declined Date and Time"),
                DetailFields(
                  isEnable: false,
                  hintText: "Date",
                  controller: declineddateController,
                ),
                DetailFields(
                  isEnable: false,
                  hintText: "Time",
                  controller: declinedtimeController,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),

          //Staff Details
          if (['assigned', 'completed'].contains(statusController.text))
            Column(
              children: [
                const Headings(title: "Assigned Staff Details"),
                DetailFields(
                  isEnable: false,
                  hintText: "Assigned Staff Name",
                  controller: staffNameController,
                ),
                DetailFields(
                  isEnable: false,
                  hintText: "Assigned Staff Number",
                  controller: staffNumberController,
                ),
              ],
            ),

          //Staff Assigned Date And Time
          if (['assigned', 'completed'].contains(statusController.text))
            Column(
              children: [
                const Headings(title: "Staff Assigned Date and Time"),
                DetailFields(
                  isEnable: false,
                  hintText: "Date",
                  controller: assigneddateController,
                ),
                DetailFields(
                  isEnable: false,
                  hintText: "Time",
                  controller: assignedtimeController,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          
          //Completed Date And Time
          if (['completed'].contains(statusController.text))
            Column(
              children: [
                const Headings(title: "Completed Date and Time"),
                DetailFields(
                  isEnable: false,
                  hintText: "Date",
                  controller: completeddateController,
                ),
                DetailFields(
                  isEnable: false,
                  hintText: "Time",
                  controller: completedtimeController,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          // if (widget.designation == "sergeant" && statusController.text == 'assigned')
          //   Column(
          //     children: [
          //     DetailFields(
          //       hintText: "remarks",
          //       controller: sergeantRemarksController,
          //     ),
          //     SizedBox(height: 20,),  
          //     ],
          //   ),
          // if (statusController.text == "completed")
          //   Column(children: [
          //     DetailFields(
          //       isEnable: false,
          //       hintText: "remarks",
          //       controller: sergeantRemarksController,
          //     ),
          //     SizedBox(height: 20,),  
              
          //   ],),
            
          //Rating and Review
          if (statusController.text == "completed")
            Column(
              children: [
                const Headings(title: 'Rating and Review'),
                if (str_rating_no == '')
                  Center(
                      child: Text(
                    "NO RATINGS OR REVIEW GIVEN YET",
                    style: TextStyle(
                      color: Colors.brown[600],
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                if (str_rating_no != '')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (int i = 0;
                          i < double.parse(str_rating_no).round();
                          i++)
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 50,
                        )
                    ],
                  ),
                if (str_rating_no != '')
                  DetailFields(
                    isEnable: false,
                    hintText: "review",
                    controller: reviewController,
                  ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          /*
          Handles the case of sergeant assigned complaints to be marked as completed
           */

          if (widget.designation == "sergeant")
            ElevatedButton(
              onPressed: () {
                setState(() {
                  status = "completed";
                });
                updateStatus(widget.id, widget.dept);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.brown[50],
                backgroundColor: Colors.brown[800], // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Corner radius
                ),
                minimumSize: const Size(150, 50), // Width and height
              ),
              child: const Text('MARK AS COMPLETED'),
            ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    )));
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
          'assigned_staff': documentSnapshot['assigned_staff'],
          'assigned_staff_no': documentSnapshot['assigned_staff_no'],
          'verification_remark': documentSnapshot['verification_remark'],
          'rating_no': documentSnapshot['rating_no'],
          'hod_completed_review': documentSnapshot['hod_completed_review'],
          'filed_date': documentSnapshot['filed_date'],
          // if (['completed'].contains(documentSnapshot['status']))
          //     'sergeant_remarks' : documentSnapshot['sergeant_remarks'],
          if (['approved', 'assigned', 'completed']
              .contains(documentSnapshot['status']))
            'approved_date': documentSnapshot['approved_date'],
          if (['assigned', 'completed'].contains(documentSnapshot['status']))
            'assigned_date': documentSnapshot['assigned_date'],
          if (['completed'].contains(documentSnapshot['status']))
            'completed_date': documentSnapshot['completed_date'],
          if (['declined'].contains(documentSnapshot['status']))
            'declined_date': documentSnapshot['declined_date']
        };

        DateTime filed, approved, assigned, completed, declined;

        setState(() {
          contactController.text = data['contact'];
          descController.text = data['desc'];
          hodController.text = data['hod'];
          natureController.text = data['nature'];
          statusController.text = data['status'];
          titleController.text = data['title'];
          urgencyController.text = data['urgency'];
          staffNameController.text = data['assigned_staff'];
          staffNumberController.text = data['assigned_staff_no'];
          imageURL = data['image'];
          remarkController.text = data['verification_remark'];
          reviewController.text = data['hod_completed_review'];
          str_rating_no = data['rating_no'];

          filed = data['filed_date'].toDate();
          fileddateController.text = formatDate(filed);
          // print(fileddateController.text);
          filedtimeController.text = formatTime(filed);
          if (['approved', 'assigned', 'completed']
              .contains(documentSnapshot['status'])) {
            approved = data['approved_date'].toDate();
            approveddateController.text = formatDate(approved);
            approvedtimeController.text = formatTime(approved);
          }
          if (['assigned', 'completed'].contains(statusController.text)) {
            assigned = data['assigned_date'].toDate();
            assigneddateController.text = formatDate(assigned);
            assignedtimeController.text = formatTime(assigned);
          }
          if (['completed'].contains(statusController.text)) {
            //sergeantRemarksController.text = data['sergeant_remarks'];
            completed = data['completed_date'].toDate();
            completeddateController.text = formatDate(completed);
            completedtimeController.text = formatTime(completed);
          }
          if (['declined'].contains(statusController.text)) {
            declined = data['declined_date'].toDate();
            declineddateController.text = formatDate(declined);
            declinedtimeController.text = formatTime(declined);
          }


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


''';

if (['approved', 'assigned', 'completed','declined'].contains(documentSnapshot['status'])){
  pdf_content += '''
VERIFICATION REMARKS 

${data['verification_remark']}


''';
}

if (['assigned', 'completed'].contains(documentSnapshot['status'])){
  pdf_content += '''

STAFF

Assigned Staff :  ${data['assigned_staff']}

Staff Contact  :  ${data['assigned_staff_no']}
 
''';
}

// if (['completed'].contains(documentSnapshot['status'])){
//   pdf_content += '''
// Sergeant Remarks :  ${data['sergeant_remarks']}
// ''';
// }

if(str_rating_no != ''){
  pdf_content += '''

RATING AND REVIEW BY HOD

Rating :  ${(data['rating_no'])}

Review :  ${data['hod_completed_review']}

''';
}

pdf_content += '''

DATE AND TIME

Filed     :  ${formatDate(filed)}    ${formatTime(filed)}

''';

if (['approved', 'assigned', 'completed'].contains(documentSnapshot['status'])){
  pdf_content += '''
Approved  :  ${formatDate(data['approved_date'].toDate())}    ${formatTime(data['approved_date'].toDate())} 

''';
}

if (['declined'].contains(documentSnapshot['status'])){
  pdf_content += '''
Declined  :  ${formatDate(data['declined_date'].toDate())}    ${formatTime(data['declined_date'].toDate())}   

''';
}




if (['assigned', 'completed'].contains(documentSnapshot['status'])){
  pdf_content += '''
Assigned  :  ${formatDate(data['assigned_date'].toDate())}    ${formatTime(data['assigned_date'].toDate())}

''';
}

if (['completed'].contains(documentSnapshot['status'])){
  pdf_content += '''
Completed :  ${formatDate(data['completed_date'].toDate())}    ${formatTime(data['completed_date'].toDate())}

''';
}

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

  Future<int> count() async {
    int completedCount = 0;
    List<String> depts = ['arch', 'ce', 'che', 'cse', 'ece', 'ee', 'me', 'pe'];
    for (var d in depts) {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(d);
      QuerySnapshot completedSnapshot =
          await collectionRef.where('status', isEqualTo: 'completed').get();
      completedCount += completedSnapshot.size;
    }
    return completedCount;
  }

  Future<void> updateStatus(String id, String dept) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(dept);

      // Update the document
      await collectionRef
          .doc(id)
          .update({'status': status,
          //'sergeant_remarks' : sergeantRemarksController.text, 
          'completed_date': DateTime.now()});
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("UserTokens")
          .doc(dept)
          .get();
      String token = snap['token'];
      sendPushMessage(token, id.toUpperCase(),
          "Complaint ${id.toUpperCase()} has been resolved");
      // int completedCount = 0;
      // List<String> depts = [
      //   'arch',
      //   'ce',
      //   'che',
      //   'cse',
      //   'ece',
      //   'ee',
      //   'me',
      //   'pe'
      // ];
      // for (var d in depts) {
      //   CollectionReference collectionRef =
      //       FirebaseFirestore.instance.collection(d);
      //   QuerySnapshot completedSnapshot =
      //       await collectionRef.where('status', isEqualTo: 'completed').get();
      //   completedCount += completedSnapshot.size;
      // }
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const SergeantComplaintSummary(
          role: "sergeant",
        );
      }), (route) => false);
      MyDialog.showCustomDialog(
          context, "Completed", "The complaint is marked as completed");
    } catch (e) {
      // Handle errors
      // print("Error updating data: $e");
    }
  }
}
