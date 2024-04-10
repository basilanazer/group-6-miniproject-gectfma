import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/TopBar.dart';
import 'package:gectfma/File_Complaint/file_complaint.dart';
import 'package:gectfma/View_Complaints/view_complaint_summary.dart';

class ComplaintSummary extends StatelessWidget {
  final String deptName;
  const ComplaintSummary({super.key, required this.deptName});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            TopBar(
                dept: (deptName == "Sergeant" || deptName == "Principal")
                    ? "Welcome ${deptName}"
                    : "DEPARTMENT OF ${deptName}",
                iconLabel: "Log Out",
                title: "Total complaints 7",
                icon: Icons.logout),
            Container(
              margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("resolved complaints".toUpperCase(),
                        style:
                            TextStyle(fontSize: 17, color: Colors.brown[600])),
                    Text("5",
                        style:
                            TextStyle(fontSize: 17, color: Colors.brown[600]))
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pending complaints".toUpperCase(),
                        style:
                            TextStyle(fontSize: 17, color: Colors.brown[600])),
                    Text("2",
                        style:
                            TextStyle(fontSize: 17, color: Colors.brown[600]))
                  ],
                ),
              ),
            ),
            Column(children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
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
              )
            ]),
            SizedBox(
              height: 40,
            ),
            Column(children: <Widget>[
              InkWell(
                onTap: (() {
                  // if (deptName == "Sergeant" || deptName == "Principal") {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ViewComplaintSummary(
                      dept: deptName,
                    );
                  }));
                  // } else
                  //   () {};
                }),
                child: Icon(
                  size: 80.0,
                  Icons.manage_search,
                  color: Colors.brown[600],
                ),
              ),
              Text(
                "View Complaints",
                style: TextStyle(color: Colors.brown[700]),
              )
            ])
          ],
        ),
      ),
    );
  }
}
