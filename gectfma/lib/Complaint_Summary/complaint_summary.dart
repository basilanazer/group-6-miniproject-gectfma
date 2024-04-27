import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:gectfma/Requirements/TopBar.dart';
import 'package:gectfma/File_Complaint/file_complaint.dart';
import 'package:gectfma/View_Complaints/view_all_complaint.dart';
import 'package:gectfma/View_Complaints/view_all_complaint.dart';

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
          future: getCounts(widget.deptName),
          builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              int? total = snapshot.data?['total'];
              int? approved = snapshot.data?['approved'];
              int? declined = snapshot.data?['declined'];
              int? pending = snapshot.data?['pending'];
              int? completed = snapshot.data?['completed'];

              return Column(
                children: <Widget>[
                  TopBar(
                    dept: "DEPARTMENT OF ${widget.deptName}",
                    iconLabel: widget.deptName == 'ee' ? "Home" : "Log Out",
                    title: "TOTAL COMPLAINTS $total",
                    icon: widget.deptName == 'ee'
                        ? Icons.home_outlined
                        : Icons.logout,
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
                      complaintstatus: (pending! + approved!)),
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
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
    try {
      // Get a reference to the collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(dept);

      // Query the collection for documents with status 'pending'
      QuerySnapshot pendingSnapshot =
          await collectionRef.where('status', isEqualTo: 'pending').get();
      int pendingCount = pendingSnapshot.size;

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

      int totalCount =
          pendingCount + approvedCount + declinedCount + completedCount;

      return {
        'pending': pendingCount,
        'approved': approvedCount,
        'declined': declinedCount,
        'completed': completedCount,
        'total': totalCount
      };
    } catch (e) {
      // Handle errors
      print("Error getting counts: $e");
      return {'pending': 0, 'completed': 0, 'declined': 0, 'total': 0};
    }
  }
}

class ComplaintsType extends StatelessWidget {
  final String complainttype;
  final Function() goto;
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
      onTap: goto,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.brown[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
