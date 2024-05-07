import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gectfma/NatureOfIssue/nature.dart';
import 'package:gectfma/Requirements/ComplaintType.dart';
import 'package:gectfma/Requirements/TopBar.dart';
import 'package:gectfma/File_Complaint/file_complaint.dart';
import 'package:gectfma/View_Complaints/view_all_complaint.dart';
import 'package:gectfma/Login/logout.dart';

class ComplaintSummary extends StatefulWidget {
  final String deptName;

  const ComplaintSummary({Key? key, required this.deptName}) : super(key: key);

  @override
  State<ComplaintSummary> createState() => _ComplaintSummaryState();
}

class _ComplaintSummaryState extends State<ComplaintSummary> {
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
                  'Yes',
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
          future: getCounts(widget.deptName),
          builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              int total = snapshot.data?['total'] ?? 0;
              int approved = snapshot.data?['approved'] ?? 0;
              int declined = snapshot.data?['declined'] ?? 0;
              int pending = snapshot.data?['pending'] ?? 0;
              int completed = snapshot.data?['completed'] ?? 0;
              int assigned = snapshot.data?['assigned'] ?? 0;

              return Column(
                children: <Widget>[
                  TopBar(
                    dept: "DEPARTMENT OF ${widget.deptName}",
                    iconLabel: widget.deptName == 'ee' ? "Go Back" : "Log Out",
                    title: "TOTAL COMPLAINTS $total",
                    icon: widget.deptName == 'ee'
                        ? Icons.arrow_back
                        : Icons.logout,
                    goto: () {
                      if (widget.deptName == 'ee') {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) {
                            return NatureOfIssue(
                              dept: "ee",
                            );
                          }),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        logout.logOut(context, widget.deptName);
                      }
                    },
                  ),
                  ComplaintsType(
                      goto: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ViewAllComplaint(
                            status: "completed",
                            dept: widget.deptName,
                          );
                        }));
                      },
                      complainttype: "Completed",
                      complaintstatus: completed),
                  ComplaintsType(
                      goto: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ViewAllComplaint(
                            status: "pending",
                            dept: widget.deptName,
                          );
                        }));
                      },
                      complainttype: "Pending",
                      complaintstatus: (pending + approved + assigned)),
                  ComplaintsType(
                      goto: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ViewAllComplaint(
                            status: "declined",
                            dept: widget.deptName,
                          );
                        }));
                      },
                      complainttype: "Declined",
                      complaintstatus: declined),
                  Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return FileComplaint(
                              dept: widget.deptName,
                            );
                          }));
                        },
                        child: Icon(
                          size: 80.0,
                          Icons.note_add_outlined,
                          color: Colors.brown[600],
                        ),
                      ),
                      Text(
                        "File New Complaint",
                        style: TextStyle(color: Colors.brown[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ViewAllComplaint(
                              dept: widget.deptName,
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
    int pendingCount = 0;
    try {
      // Get a reference to the collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(dept);

      // Query the collection for documents with status 'pending'
      QuerySnapshot pendingSnapshot =
          await collectionRef.where('status', isEqualTo: 'pending').get();
      pendingCount = pendingSnapshot.size;

      // Query the collection for documents with status 'accepted'
      QuerySnapshot approvedSnapshot =
          await collectionRef.where('status', isEqualTo: 'approved').get();
      int approvedCount = approvedSnapshot.size;

      // Query the collection for documents with status 'declined'
      QuerySnapshot declinedSnapshot =
          await collectionRef.where('status', isEqualTo: 'declined').get();
      int declinedCount = declinedSnapshot.size;

      QuerySnapshot completedSnapshot =
          await collectionRef.where('status', isEqualTo: 'completed').get();
      int completedCount = completedSnapshot.size;

      QuerySnapshot assignedSnapshot =
          await collectionRef.where('status', isEqualTo: 'assigned').get();
      int assignedCount = assignedSnapshot.size;

      int totalCount = pendingCount +
          approvedCount +
          declinedCount +
          completedCount +
          assignedCount;

      return {
        'pending': pendingCount,
        'approved': approvedCount,
        'declined': declinedCount,
        'completed': completedCount,
        'total': totalCount,
        'assigned': assignedCount
      };
    } catch (e) {
      // Handle errors
      // print("Error getting counts: $e");
      return {'pending': 0, 'completed': 0, 'declined': 0, 'total': 0};
    }
  }
}
