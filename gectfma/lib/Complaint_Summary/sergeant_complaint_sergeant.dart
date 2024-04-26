import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gectfma/Requirements/TopBar.dart';
import 'package:gectfma/File_Complaint/file_complaint.dart';
import 'package:gectfma/View_Complaints/view_complaint_summary.dart';

class SergeantComplaintSummary extends StatelessWidget {
  final String deptName;

  const SergeantComplaintSummary({Key? key, required this.deptName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        // Show exit confirmation dialog
        bool exit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.amber[50],
            title: Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Close the dialog and return false
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.brown[800]),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Close the dialog and return true
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'yes',
                  style: TextStyle(color: Colors.brown[800]),
                ),
              ),
            ],
          ),
        );

        // Return exit if user confirmed, otherwise don't exit
        return exit ?? false;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: getCounts(deptName),
          builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              int? total = snapshot.data?['total'];
              int? accepted = snapshot.data?['accepted'];
              int? pending = snapshot.data?['pending'];

              return Column(
                children: <Widget>[
                  TopBar(
                    dept: "WELCOME ${deptName}",
                    iconLabel: "Log Out",
                    title: "TOTAL COMPLAINTS $total",
                    icon: Icons.logout,
                  ),
                  ComplaintsType(
                      goto: () {},
                      complainttype: "Assigned",
                      complaintstatus: accepted),
                  ComplaintsType(
                      goto: () {},
                      complainttype: "Pending",
                      complaintstatus: pending),
                  // Column(
                  //   children: <Widget>[
                  //     InkWell(
                  //       onTap: () {
                  //         Navigator.of(context).pushReplacement(
                  //             MaterialPageRoute(builder: (context) {
                  //           return FileComplaint(
                  //             dept: deptName,
                  //           );
                  //         }));
                  //       },
                  //       child: Icon(
                  //         size: 80.0,
                  //         Icons.note_add_outlined,
                  //         color: Colors.brown[600],
                  //       ),
                  //     ),
                  //     Text(
                  //       "File New Complaint",
                  //       style: TextStyle(color: Colors.brown[700]),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 40),
                  Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return ViewComplaintSummary(
                              dept: deptName,
                            );
                          }));
                        },
                        child: Icon(
                          size: 80.0,
                          Icons.manage_search,
                          color: Colors.brown[600],
                        ),
                      ),
                      Text(
                        "View All Complaints",
                        style: TextStyle(color: Colors.brown[700]),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    ));
  }

  Future<Map<String, int>> getCounts(String dept) async {
    try {
      // Get a reference to the collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(dept);

      // Query the collection for documents with status 'pending'
      QuerySnapshot pendingSnapshot =
          await collectionRef.where('status', isEqualTo: 'pending').get();
      int pendingCount = pendingSnapshot.size;

      // Query the collection for documents with status 'accepted'
      QuerySnapshot acceptedSnapshot =
          await collectionRef.where('status', isEqualTo: 'accepted').get();
      int acceptedCount = acceptedSnapshot.size;

      int totalCount = pendingCount + acceptedCount;

      return {
        'pending': pendingCount,
        'accepted': acceptedCount,
        'total': totalCount
      };
    } catch (e) {
      // Handle errors
      print("Error getting counts: $e");
      return {'pending': 0, 'accepted': 0, 'total': 0};
    }
  }
}

class ComplaintsType extends StatelessWidget {
  final String complainttype;
  final Function goto;
  final int? complaintstatus;
  const ComplaintsType({
    super.key,
    required this.complainttype,
    required this.complaintstatus,
    required this.goto,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goto(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.brown[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$complainttype complaints".toUpperCase(),
                style: TextStyle(fontSize: 17, color: Colors.brown[600]),
              ),
              Text(
                "$complaintstatus",
                style: TextStyle(fontSize: 17, color: Colors.brown[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
