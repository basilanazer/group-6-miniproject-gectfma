import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Complaint_Summary/complaint_summary.dart';
import 'package:gectfma/Requirements/DateAndTime.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import 'package:gectfma/downloadpdf/pdf_manager.dart';
import '../Requirements/DetailFields.dart';
import '../Requirements/TopBar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class completedReview extends StatefulWidget {
  final String dept;
  final String id;
  //final int number;
  const completedReview({super.key, required this.dept, this.id = ""});

  @override
  State<completedReview> createState() => _completedReviewState();
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

String imageURL = '';
double rating_no = 0.0;
String str_rating_no = '0.0';
String pdf_content = '' ;

class _completedReviewState extends State<completedReview> {
  String review = '';
  @override
  void initState() {
    //implement initState
    if (widget.id != "") {
      viewComplaint(widget.id, widget.dept);
    }
    reviewController = TextEditingController();
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
          'assigned_staff': documentSnapshot['assigned_staff'],
          'assigned_staff_no': documentSnapshot['assigned_staff_no'],
          'verification_remark': documentSnapshot['verification_remark'],
          'rating_no': documentSnapshot['rating_no'],
          'hod_completed_review': documentSnapshot['hod_completed_review'],
          'filed_date': documentSnapshot['filed_date'],
          'approved_date': documentSnapshot['approved_date'],
          'assigned_date': documentSnapshot['assigned_date'],
          'completed_date': documentSnapshot['completed_date'],

        };
        DateTime filed, approved, assigned, completed;

        setState(() {
          contactController.text = data['contact'];
          descController.text = data['desc'];
          hodController.text = data['hod'];
          natureController.text = data['nature'];
          statusController.text = data['status'];
          titleController.text = data['title'];
          urgencyController.text = data['urgency'];
          remarkController.text = data['verification_remark'];
          reviewController.text = data['hod_completed_review'];
          str_rating_no = data['rating_no'];
          imageURL = data['image'];
          staffNameController.text = data['assigned_staff'];
          staffNumberController.text = data['assigned_staff_no'];
          filed = data['filed_date'].toDate();
          fileddateController.text = formatDate(filed);
          filedtimeController.text = formatTime(filed);
          approved = data['approved_date'].toDate();
            approveddateController.text = formatDate(approved);
            approvedtimeController.text = formatTime(approved);
          assigned = data['assigned_date'].toDate();
            assigneddateController.text = formatDate(assigned);
            assignedtimeController.text = formatTime(assigned);
          completed = data['completed_date'].toDate();
            completeddateController.text = formatDate(completed);
            completedtimeController.text = formatTime(completed);

            pdf_content = '''
Complaint_id :  ${id.toUpperCase()}


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

VERIFICATION REMARKS 

${data['verification_remark']}


STAFF 

Assigned Staff :  ${data['assigned_staff']}

Staff Contact  :  ${data['assigned_staff_no']}

''';


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

Approved  :  ${formatDate(data['approved_date'].toDate())}    ${formatTime(data['approved_date'].toDate())} 

Assigned  :  ${formatDate(data['assigned_date'].toDate())}    ${formatTime(data['assigned_date'].toDate())}

Completed :  ${formatDate(data['completed_date'].toDate())}    ${formatTime(data['completed_date'].toDate())}
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
            dept: "DEPARTMENT OF ${widget.dept}",
            iconLabel: 'Go Back',
            title: widget.id.toUpperCase(),
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
          const Headings(title: "Images"),
          //Image To be added
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
                return const Text('Error loading image');
              },
            ),
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
          const Headings(title: "Verification Remarks"),
          DetailFields(
              isEnable: false,
              controller: remarkController,
              hintText: "No remarks given"),

          const SizedBox(
            height: 20,
          ),
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
          const SizedBox(
            height: 20,
          ),
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
          const Headings(title: 'Rating and Review'),
          Center(
            child: RatingBar.builder(
              initialRating:
                  str_rating_no == '' ? 0 : double.parse(str_rating_no),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                rating_no = rating;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DetailFields(
            hintText: "Review",
            controller: reviewController,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  review = reviewController.text;
                  str_rating_no = rating_no.toString();
                });
                rateAndReview(widget.dept, widget.id, review, str_rating_no);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.brown[50],
                backgroundColor: Colors.brown[800], // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Corner radius
                ),
                minimumSize: const Size(150, 50), // Width and height
              ),
              child: const Text('SAVE'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.brown[50],
                backgroundColor: Colors.brown[800], // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Corner radius
                ),
                minimumSize: const Size(150, 50), // Width and height
              ),
              child: const Text('CANCEL'),
            ),
          ]),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    )));
  }

  void rateAndReview(
      String dept, String id, String review, String rating) async {
    try {
      if (review == '' || rating == '0.0') {
        MyDialog.showCustomDialog(
          context,
          "ERROR!!",
          "Review should be given and a minimum rating of 1 star",
        );
      } else {
        // Get a reference to the specific document with the custom ID
        DocumentReference docRef =
            FirebaseFirestore.instance.collection(dept).doc(id);

        // Set the data in the document with the custom ID
        await docRef.update({
          'hod_completed_review': review,
          'rating_no': rating,
        });
        // Navigator.of(context)
        //     .pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
        //       return complaintVerification(nature: natureController.text);
        //     }),(Route<dynamic> route) => false,);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return ComplaintSummary(deptName: dept);
        }), (route) => false);
        MyDialog.showCustomDialog(
            context, "Thank you", "Your rating and review are added");
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
