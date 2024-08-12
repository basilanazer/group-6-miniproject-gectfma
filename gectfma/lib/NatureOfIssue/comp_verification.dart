import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Login/logout.dart';
import 'package:gectfma/NatureOfIssue/list_complints.dart';
import 'package:gectfma/NatureOfIssue/nature.dart';
import 'package:gectfma/Requirements/TopBar.dart';

class complaintVerification extends StatefulWidget {
  final String nature;
  const complaintVerification({super.key, required this.nature});
  @override
  State<complaintVerification> createState() => _complaintVerificationState();
}

class _complaintVerificationState extends State<complaintVerification> {
  @override
  Widget build(BuildContext context) {
    Widget body = SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: getCounts(widget.nature),
          builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              int? total = snapshot.data?['total'];
              int? approved = snapshot.data?['approved'];
              int? declined = snapshot.data?['declined'];
              int? pending = snapshot.data?['pending'];

              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TopBar(
                          iconLabel: widget.nature == 'Electrical'
                              ? "Home"
                              : "Log Out",
                          title: "Total ${widget.nature} complaints $total",
                          icon: widget.nature == 'Electrical'
                              ? Icons.home
                              : Icons.logout,
                          dept: "${widget.nature} in-charge",
                          goto: () {
                            if (widget.nature == 'Electrical') {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                                  return const NatureOfIssue(
                                    dept: "ee",
                                  );
                                }),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              logout.logOut(
                                  context,
                                  'p-in-charge');
                            }
                          },
                        ),
                        Column(children: [
                          const SizedBox(
                            height: 70,
                          ),
                          ComplaintsType(
                              nature: widget.nature,
                              status: "approved",
                              number: approved),
                          ComplaintsType(
                              nature: widget.nature,
                              status: "pending",
                              number: pending),
                          ComplaintsType(
                              nature: widget.nature,
                              status: "declined",
                              number: declined),
                        ])
                      ]));
            }
          },
        ),
      ),
    );
    // Check if nature is 'Plumbing' and wrap with WillPopScope
  if (widget.nature == 'Plumbing') {
    body = WillPopScope(
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
      child: body,
    );
  }

  return body;
  }

  Future<Map<String, int>> getCounts(String nature) async {
    try {
      int pendingCount = 0;
      int approvedCount = 0;
      int declinedCount = 0;
      int completedCount = 0;
      int assignedCount = 0;
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

        // Query the collection for documents with status 'pending'
        QuerySnapshot pendingSnapshot = await collectionRef
            .where('status', isEqualTo: 'pending')
            .where('nature', isEqualTo: nature)
            .get();
        pendingCount += pendingSnapshot.size;
        QuerySnapshot completedSnapshot = await collectionRef
            .where('status', isEqualTo: 'completed')
            .where('nature', isEqualTo: nature)
            .get();
        completedCount += completedSnapshot.size;
        QuerySnapshot assignedSnapshot = await collectionRef
            .where('status', isEqualTo: 'assigned')
            .where('nature', isEqualTo: nature)
            .get();
        assignedCount += assignedSnapshot.size;
        // Query the collection for documents with status 'accepted'
        QuerySnapshot acceptedSnapshot = await collectionRef
            .where('status', isEqualTo: 'approved')
            .where('nature', isEqualTo: nature)
            .get();
        approvedCount += acceptedSnapshot.size;

        // Query the collection for documents with status 'declined'
        QuerySnapshot declinedSnapshot = await collectionRef
            .where('status', isEqualTo: 'declined')
            .where('nature', isEqualTo: nature)
            .get();
        declinedCount += declinedSnapshot.size;
      }
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
        'assigned': assignedCount,
        'total': totalCount
      };
    } catch (e) {
      // Handle errors
      // print("Error getting counts: $e");
      return {'pending': 0, 'accepted': 0, 'declined': 0, 'total': 0};
    }
  }
}

class ComplaintsType extends StatelessWidget {
  final String nature;
  final String status;
  final int? number;
  const ComplaintsType({
    super.key,
    required this.status,
    required this.nature,
    required this.number,
    //required this.goto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return listComplaints(status: status, nature: nature);
                }));
              },
              child: Text(
                "$status complaints".toUpperCase(),
                style: TextStyle(fontSize: 17, color: Colors.brown[600]),
              ),
            ),
            Text(
              "$number",
              style: TextStyle(fontSize: 17, color: Colors.brown[600]),
            ),
          ],
        ),
      ),
    );
  }
}
