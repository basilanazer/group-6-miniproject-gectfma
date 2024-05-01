import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Complaint_Summary/sergeant_complaint_summary.dart';
import 'package:gectfma/View_Complaints/Sergeant/sergeant_approved_complaint.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/TopBar.dart';
import 'package:gectfma/View_Complaints/view_complaint.dart';

class SergeantViewAllComplaint extends StatefulWidget {
  final String status;
  final int total;
  const SergeantViewAllComplaint(
      {super.key, required this.total, this.status = ""});

  @override
  State<SergeantViewAllComplaint> createState() =>
      _SergeantViewAllComplaintState();
}

class _SergeantViewAllComplaintState extends State<SergeantViewAllComplaint> {
  List<Map<String, dynamic>>? temp = [];
  List<Map<String, dynamic>>? filteredData;
  List<String>? filteredIds = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          TopBar(
            goto: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
                  return SergeantComplaintSummary(deptName: "Sergeant");
                }),
                (Route<dynamic> route) => false,
              );
            },
            dept: "WELCOME Sergeant",
            iconLabel: 'Go Back',
            title: "TOTAL " +
                "${widget.status == "" ? "" : widget.status}" +
                " COMPLAINTS ${widget.total}",
            icon: Icons.arrow_back,
          ),
          SizedBox(height: 10),
          for (String dept in [
            "arch",
            "ce",
            "che",
            "cse",
            "ece",
            "ee",
            "me",
            "pe"
          ])
            Column(
              children: [
                //Headings(title: "Department Of ${dept.toUpperCase()}"),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: getData(dept, widget.status),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else {
                      temp = snapshot.data;
                      filteredData = temp;
                      return Container(
                        child: Column(
                          children: [
                            if (filteredData!.isNotEmpty)
                              Headings(
                                title: 'department of $dept',
                              ),
                            Column(
                              children: filteredData!.map((complaintData) {
                                return eachComplaint(dept, complaintData);
                              }).toList(),
                            )
                          ],
                        ),
                      );
                      // return Column(
                      //   children: filteredData!.map((complaintData) {
                      //     return eachComplaint(dept, complaintData);
                      //   }).toList(),
                      // );
                    }
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
        ],
      ),
    )));
  }

  Widget eachComplaint(String dept, Map<String, dynamic> complaintData) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // children: filteredIds!.map((complaint) {
          //   return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                onTap: () {
                  if (widget.status == 'approved') {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return SergeantApprovedComplaint(
                          dept: dept,
                          id: complaintData['id'],
                          total: widget.total);
                    }));
                  } else {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ViewComplaint(
                        designation:
                            widget.status == "assigned" ? "sergeant" : "",
                        dept: dept,
                        id: complaintData['id'],
                      );
                    }));
                  }
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaintData['id'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.brown[600],
                          ),
                        ),
                        Text(
                          complaintData['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Status: ${complaintData['status']}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        ));
  }
}

Future<List<Map<String, dynamic>>> getData(String dept, String status) async {
  try {
    // Get a reference to the collection
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(dept);
    Query query = collectionRef;
    query =
        query.where('status', whereIn: ['assigned', 'approved', 'completed']);
    if (status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }
    // Query the collection for all documents
    QuerySnapshot querySnapshot = await query.get();

    // Extract data from each document
    List<Map<String, dynamic>> data =
        querySnapshot.docs.map((DocumentSnapshot doc) {
      // Access fields within the document
      String title = doc['title'];
      String id = doc['id'];
      String status = doc['status'];

      // Return a map representing the document's data
      return {
        'title': title,
        'id': id,
        'status': status,
      };
    }).toList();
    // Return the list of document data
    return data;
  } catch (e) {
    // Handle errors
    // print("Error getting data: $e");
    return [];
  }
}
