
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/NatureOfIssue/approve_decline.dart';
import 'package:gectfma/NatureOfIssue/comp_verification.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/TopBar.dart';
import 'package:gectfma/View_Complaints/view_complaint.dart';

class listComplaints extends StatefulWidget {
  final String status;
  final String nature;
  //final int number;
  const listComplaints({super.key, required this.status,required this.nature});

  @override
  State<listComplaints> createState() => _listComplaintsState();
}
class _listComplaintsState extends State<listComplaints> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>>? temp = [];
  List<Map<String, dynamic>>? filteredData;
  List<String>? filteredIds = [];

  @override
  Widget build(BuildContext context) {
    List<String> deptCollection = ['cse','che','ece','ee','pe','ce','me','arch'];
    //String dept = 'cse';
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TopBar(
                iconLabel: "Go Back",
                 title: widget.status == 'pending'? "${widget.status} Complaints To Approve ":"${widget.status} Complaints ", 
                 icon: Icons.arrow_back, 
                 dept: "${widget.nature} in-charge",
                 goto: () {
                   Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                      return complaintVerification(
                        nature: widget.nature,
                      );
                    }),(Route<dynamic> route) => false,
                   );
                 },
              ),
              SizedBox(height: 20),
              //for(var dept in deptCollection)
              for(var dept in deptCollection)
              FutureBuilder<List<Map<String, dynamic>>>(
                future: getData(dept, widget.status,widget.nature),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    temp = snapshot.data;
                    
                    filteredData = temp;
                    return Container(
                      child:Column(
                        children: [
                          if(filteredData!.isNotEmpty)
                          Headings(title: dept,),
                          Column(
                            // children: snapshot.data!.map((complaintData) {
                            //   return eachComplaint(complaintData);
                            // }).toList(),
                            children: filteredData!.map((complaintData) {
                              return eachComplaint(complaintData,dept);
                            }).toList(),
                          ),
                          if(filteredData!.isNotEmpty)
                          Divider()
                        ]
                      )
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget eachComplaint(Map<String, dynamic> complaintData,String dept) {
    //Headings(title: dept);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // children: filteredIds!.map((complaint) {
          //   return Column(
          children: [
            
            Container(
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                onTap: () {
                  if(complaintData['status'] == "pending"){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return approveOrDecline(
                        dept: dept,
                        id: complaintData['id'],
                        //number: widget.number,
                      );
                    }));
                  }
                  else{
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ViewComplaint(
                      dept: dept,
                      id: complaintData['id'],
                    );
                    }));
                  }
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaintData['id'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.brown[600],
                          ),
                        ),
                        Text(
                          complaintData['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Status: ${complaintData['status']}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Divider(),
          ],
        ));
  }
}

Future<List<Map<String, dynamic>>> getData(String dept, String status,String nature) async {
  try {
    // Get a reference to the collection
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(dept);
    Query query = collectionRef;
   // if (status.isNotEmpty) {
      
        query = query.where('status', isEqualTo: status).where('nature', isEqualTo: nature);
   // }
    // Query the collection for all documents
    QuerySnapshot querySnapshot = await query.get();

    // Extract data from each document
    List<Map<String, dynamic>> data =
        querySnapshot.docs.map((DocumentSnapshot doc) {
      // Access fields within the document
      String title = doc['title'];
      String id = doc['id'];
      String status = doc['status'];

      // Return a map representing the document's data
      return {
        'title': title,
        'id': id,
        'status': status,
      };
    }).toList();
    // Return the list of document data
    return data;
  } catch (e) {
    // Handle errors
    print("Error getting data: $e");
    return [];
  }
}