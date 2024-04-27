import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/TopBar.dart';

class listComplaints extends StatefulWidget {
  final String status;
  final String nature;
  final int number;
  const listComplaints({super.key, required this.status,required this.nature,required this.number});

  @override
  State<listComplaints> createState() => _listComplaintsState();
}

class _listComplaintsState extends State<listComplaints> {
  List<String> deptCollection = ['cse','che','ece','ee','pe','ce','me','arch'];
    @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TopBar(
                iconLabel: "Go Back",
                 title: widget.status == 'pending'? "Pending Complaints To Approve ${widget.number}":"${widget.status} Complaints ${widget.number}", 
                 icon: Icons.arrow_back, 
                 dept: "${widget.nature} in-charge"),
              for(var i in deptCollection)
              Column(
                children:[
                  Headings(title: i),
                  Complaint(status: widget.status, id: "{$i}001"),
                ]
              )
            ],
          ),
        ),
      )
    );
  }
}
class Complaint extends StatelessWidget {
  final String status;
  final String id;
  const Complaint({
    super.key,
    required this.status,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            TextButton(onPressed: (){
              
            },
             child: Text(
              id.toUpperCase(),
              style: TextStyle(fontSize: 17, color: Colors.brown[600]),
            ),),
          
            Text(
              status,
              style: TextStyle(fontSize: 17, color: Colors.brown[600]),
            ),
          ],
        ),
      ),
    );
  }
}