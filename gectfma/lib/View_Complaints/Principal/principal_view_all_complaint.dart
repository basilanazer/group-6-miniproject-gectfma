import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/TopBar.dart';
import 'package:gectfma/View_Complaints/view_complaint.dart';
import 'package:gectfma/Login/logout.dart';

class PrincipalViewAllComplaint extends StatefulWidget {
  final String status;

  const PrincipalViewAllComplaint({super.key, this.status = ""});

  @override
  State<PrincipalViewAllComplaint> createState() =>
      _PrincipalViewAllComplaintState();
}

class _PrincipalViewAllComplaintState extends State<PrincipalViewAllComplaint> {
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
              logout.logOut(context);
            },
            dept: "WELCOME Principal",
            iconLabel: "Log Out",
            title: "TOTAL COMPLAINTS ",
            icon: Icons.logout,
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
                Headings(title: "Department Of ${dept.toUpperCase()}"),
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
                      return Column(
                        children: filteredData!.map((complaintData) {
                          return eachComplaint(dept, complaintData);
                        }).toList(),
                      );
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
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return ViewComplaint(
                      dept: dept,
                      id: complaintData['id'],
                    );
                  }));
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
    print("Error getting data: $e");
    return [];
  }
}
