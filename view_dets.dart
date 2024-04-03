import 'package:flutter/material.dart';
import 'package:splash/detsfield.dart';
import 'package:splash/topbar.dart';

class ViewComplaint extends StatelessWidget {
  const ViewComplaint({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TopBar(
                iconLabel: "Back",
                title: "Complaint ID: CS001",
                icon: Icons.subdirectory_arrow_left,
                dept: "Department Of CSE"),
            Text("STATUS:COMPLETD",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            Headings(title: "Department Details"),
            DetailFields(hintText: "Computer Science and Engineering"),
            SizedBox(
              height: 10,
            ),
            DetailFields(hintText: "Dr. AJAY JAMES"),
            SizedBox(
              height: 10,
            ),
            DetailFields(hintText: "9xxxxxxxxx"),
            SizedBox(
              height: 20,
            ),
            Headings(title: "Complaint Details"),
            DetailFields(hintText: "Plumbing"),
            SizedBox(
              height: 10,
            ),
            DetailFields(hintText: "Brocken flush tank in ladies toilet"),
            SizedBox(
              height: 10,
            ),
            Headings(title: "Current Status"),
            SizedBox(
              height: 20,
            ),
            DetailFields(hintText: "Work completed"),
            SizedBox(
              height: 10,
            ),
            Headings(title: "Current Status"),
            SizedBox(
              height: 20,
            ),
            DetailFields(hintText: "Brocken flush tank in ladies toilet"),
            SizedBox(
              height: 10,
            ),
            Headings(title: "Assigned staff"),
            SizedBox(
              height: 20,
            ),
            DetailFields(hintText: "John doe"),
            SizedBox(
              height: 10,
            ),
            DetailFields(hintText: "8xxxxxxxxx"),
            SizedBox(
              height: 10,
            ),
            Headings(title: "Remarks"),
            SizedBox(
              height: 20,
            ),
            DetailFields(hintText: "Fund allocated and approved by abc."),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }
}

class Headings extends StatelessWidget {
  final String title;
  const Headings({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(title.toUpperCase(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.brown[600])),
      ),
    );
  }
}
