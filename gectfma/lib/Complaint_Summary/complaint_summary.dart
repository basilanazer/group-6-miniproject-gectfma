import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/TopBar.dart';
import 'package:gectfma/File_Complaint/file_complaint.dart';
import 'package:gectfma/View_Complaints/view_dept_complaint.dart';

class ComplaintSummary extends StatelessWidget {
  final String deptName;

  const ComplaintSummary({Key? key, required this.deptName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              int? completed = snapshot.data?['completed'];
              int? pending = snapshot.data?['pending'];

              return Column(
                children: <Widget>[
                  TopBar(
                    dept: "DEPARTMENT OF ${deptName}",
                    iconLabel: "Log Out",
                    title: "TOTAL COMPLAINTS $total",
                    icon: Icons.logout,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "resolved complaints".toUpperCase(),
                            style: TextStyle(fontSize: 17, color: Colors.brown[600]),
                          ),
                          Text(
                            "$completed",
                            style: TextStyle(fontSize: 17, color: Colors.brown[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pending complaints".toUpperCase(),
                            style: TextStyle(fontSize: 17, color: Colors.brown[600]),
                          ),
                          Text(
                            "$pending",
                            style: TextStyle(fontSize: 17, color: Colors.brown[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return FileComplaint(
                              dept: deptName,
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return viewDeptComplaints(
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
                        "View Complaints",
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
    );
  }

  Future<Map<String, int>> getCounts(String dept) async {
    try {
      // Get a reference to the collection
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(dept);

      // Query the collection for documents with status 'pending'
      QuerySnapshot pendingSnapshot = await collectionRef.where('status', isEqualTo: 'pending').get();
      int pendingCount = pendingSnapshot.size;

      // Query the collection for documents with status 'completed'
      QuerySnapshot completedSnapshot = await collectionRef.where('status', isEqualTo: 'completed').get();
      int completedCount = completedSnapshot.size;

      int totalCount = pendingCount + completedCount;

      return {'pending': pendingCount, 'completed': completedCount, 'total': totalCount};
    } catch (e) {
      // Handle errors
      print("Error getting counts: $e");
      return {'pending': 0, 'completed': 0, 'total': 0};
    }
  }
}
