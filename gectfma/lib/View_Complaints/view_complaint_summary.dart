import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/TopBar.dart';

class ViewComplaintSummary extends StatelessWidget {
  static String status = "Pending";
  final String dept;
  const ViewComplaintSummary({super.key, required this.dept});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TopBar(
                iconLabel: "LogOut",
                title: "Total complaints 7",
                icon: Icons.logout,
                dept: "Welcome ${dept}"),
            Headings(title: "Latest:"),
            EachComplaint(
                title: "DEPT OF CSE",
                content:
                    "3 fused electric bulbs in S6 class,\nwhich needs to be replaced as ..."),
            SizedBox(
              height: 10,
            ),
            EachComplaint(
                title: "DEPT OF CHE",
                content:
                    "Some water pipes in the chemical\nlab arenot working properly. ...."),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
              color: Colors.black26,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.search),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(fontSize: 17),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      status = "Pending";
                    },style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.brown[50], 
                          backgroundColor: Colors.brown[800], // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Corner radius
                          ),
                          minimumSize: Size(185, 50), // Width and height
                        ),
                    child: Text("PENDING")),
                ElevatedButton(
                    onPressed: () {
                      status = "Completed";
                    },style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.brown[50], 
                          backgroundColor: Colors.brown[200], // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Corner radius
                          ),
                          minimumSize: Size(185, 50), // Width and height
                        ),
                    child: Text("COMPLETED"))
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.brown,
            ),
            SizedBox(
              height: 10,
            ),
            EachDeptComplaint(
              dept: "CSE",
              status: status,
              id: "CS0001",
            ),
            EachDeptComplaint(
              dept: "CHE",
              status: status,
              id: "CH0001",
            ),
            EachDeptComplaint(
              dept: "CE",
              status: status,
              id: "CE0001",
            ),
          ],
        ),
      ),
    ));
  }
}

class EachDeptComplaint extends StatelessWidget {
  const EachDeptComplaint({
    super.key,
    required this.status,
    required this.id,
    required this.dept,
  });
  final String dept;
  final String id;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Headings(title: "Department of ${dept}"),
        Container(
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: ComplaintIdStatus(status: status, id: id),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.black26,
        ),
      ],
    );
  }
}

class ComplaintIdStatus extends StatelessWidget {
  const ComplaintIdStatus({
    super.key,
    required this.status,
    required this.id,
  });
  final String id;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Headings(title: "ID:${id}"),
        Text("STATUS : ${status}")
      ],
    );
  }
}

class EachComplaint extends StatelessWidget {
  final String content;
  final String title;
  const EachComplaint({
    super.key,
    required this.content,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.brown[200], borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(content)
          ],
        ),
      ),
    );
  }
}
