import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gectfma/Complaint_Summary/complaint_summary.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import 'package:gectfma/View_Complaints/view_all_complaint.dart';
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
TextEditingController remarkController = TextEditingController();
TextEditingController reviewController = TextEditingController();
String imageURL = '';
double rating_no = 0.0;
String str_rating_no = '0.0';

class _completedReviewState extends State<completedReview> {
  String review = '';
  @override
  void initState() {
    // TODO: implement initState
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
          'verification_remark': documentSnapshot['verification_remark'],
          'rating_no': documentSnapshot['rating_no'],
          'hod_completed_review': documentSnapshot['hod_completed_review'],
        };

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
          Headings(title: "Department Details"),
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
          Headings(title: "Images"),
          //Image To be added
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

          Headings(title: "Verification Remarks"),
          DetailFields(
              isEnable: false,
              controller: remarkController,
              hintText: "No remarks given"),

          SizedBox(
            height: 20,
          ),

          Headings(title: 'Rating and Review'),
          Center(
            child: RatingBar.builder(
              initialRating:
                  str_rating_no == '' ? 0 : double.parse(str_rating_no),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                rating_no = rating;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DetailFields(
            hintText: "Review",
            controller: reviewController,
          ),
          SizedBox(
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
                minimumSize: Size(150, 50), // Width and height
              ),
              child: Text('SAVE'),
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
                minimumSize: Size(150, 50), // Width and height
              ),
              child: Text('CANCEL'),
            ),
          ]),
          SizedBox(
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
          return ViewAllComplaint(
            dept: dept,
            status: 'completed',
          );
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
