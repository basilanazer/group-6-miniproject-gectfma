import 'package:flutter/material.dart';

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
