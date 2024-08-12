import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gectfma/Login/logout.dart';
import 'package:gectfma/Requirements/ComplaintType.dart';
import 'package:gectfma/Requirements/TopBar.dart';
import 'package:gectfma/View_Complaints/Sergeant/sergeant_view_all_complaint.dart';

/*
The Sergeant has 3 complaint access
Completed---Refers to completed tasks
Assigned--Refers to ones where staff has been assigned
Pending or Approved refers to the ones approved but staff is not yet assigned
*/

class SergeantComplaintSummary extends StatelessWidget {
  final String role;

  const SergeantComplaintSummary({super.key, required this.role});

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
            title: const Text('Are you sure you want to exit?'),
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
        return exit;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: getCounts(),
          builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              int? total = snapshot.data?['total'];
              int? completed = snapshot.data?['completed'];
              int? assigned = snapshot.data?['assigned'];
              int? approved = snapshot.data?['approved'];

              return Column(
                children: <Widget>[
                  TopBar(
                    dept: "WELCOME $role",
                    iconLabel: "Log Out",
                    title: "TOTAL COMPLAINTS $total",
                    icon: Icons.logout,
                    goto: () {
                      logout.logOut(context, role);
                    },
                  ),
                  ComplaintsType(
                      goto: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SergeantViewAllComplaint(
                            total: completed!,
                            status: "completed",
                          );
                        }));
                      },
                      complainttype: "Completed",
                      complaintstatus: completed),
                  ComplaintsType(
                      goto: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SergeantViewAllComplaint(
                            total: assigned!,
                            status: "assigned",
                          );
                        }));
                      },
                      complainttype: "Assigned",
                      complaintstatus: assigned),
                  ComplaintsType(
                      goto: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SergeantViewAllComplaint(
                            total: approved!,
                            status: "approved",
                          );
                        }));
                      },
                      complainttype: "Pending",
                      complaintstatus: approved),
                  const SizedBox(height: 40),
                  Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return SergeantViewAllComplaint(total: total!);
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

  Future<Map<String, int>> getCounts() async {
    try {
      int completedCount = 0;
      int assignedCount = 0;
      int approvedCount = 0;

      List<String> deptCollection = [
        'cse',
        'che',
        'ece',
        'ee',
        'pe',
        'ce',
        'me',
        'arch'
      ];
      // Get a reference to the collection
      for (int i = 0; i < 8; i++) {
        String dept = deptCollection[i];
        CollectionReference collectionRef =
            FirebaseFirestore.instance.collection(dept);

        // Query the collection for documents with status 'approved'
        QuerySnapshot completedSnapshot =
            await collectionRef.where('status', isEqualTo: 'completed').get();
        completedCount += completedSnapshot.size;
        QuerySnapshot assignedSnapshot =
            await collectionRef.where('status', isEqualTo: 'assigned').get();
        assignedCount += assignedSnapshot.size;

        // Query the collection for documents with status 'accepted'
        QuerySnapshot approvedSnapshot =
            await collectionRef.where('status', isEqualTo: 'approved').get();
        approvedCount += approvedSnapshot.size;
      }
      int totalCount = approvedCount + assignedCount + completedCount;
      return {
        'assigned': assignedCount,
        'approved': approvedCount,
        'completed': completedCount,
        'total': totalCount
      };
    } catch (e) {
      // Handle errors
      // print("Error getting counts: $e");
      return {'assigned': 0, 'approved': 0, 'completed': 0, 'total': 0};
    }
  }
}
