import 'package:flutter/material.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/TopBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewComplaintSummary extends StatefulWidget {
  static String status = "Pending";

  final String dept;
  const ViewComplaintSummary({super.key, required this.dept});

  @override
  State<ViewComplaintSummary> createState() => _ViewComplaintSummaryState();
}

class _ViewComplaintSummaryState extends State<ViewComplaintSummary> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>>? temp = [];
  List<Map<String, dynamic>>? filteredData;
  List<String>? filteredIds = [];
  void filterComplaints(String searchText) {
    setState(() {
      // temp?.forEach((element) {
      //   if (element['id'].contains(searchText.toLowerCase())) {
      //     filteredIds?.add(element['id'].toString());
      //   }
      // });
      //01:06
      filteredData = temp!
          .where((complaint) => complaint['id']
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList(); // 29
    });
    // return filteredIds;
  }

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
                title: "Total complaints 1",
                icon: Icons.arrow_back,
                dept: "Welcome ${widget.dept}",
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    filterComplaints(value);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchController.clear();
                        // filterComplaints('');
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: getData(widget.dept),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    temp = snapshot.data;
                    filteredData = temp;
                    return Column(
                      // children: snapshot.data!.map((complaintData) {
                      //   return eachDeptComplaint(complaintData);
                      // }).toList(),
                      children: filteredData!.map((complaintData) {
                        return eachDeptComplaint(complaintData);
                      }).toList(),
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

  Widget eachDeptComplaint(Map<String, dynamic> complaintData) {
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
                  // Handle onTap event
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
                          complaintData['contact'],
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
            Divider(),
          ],
          //   );
          // }).toList(),
        ));
  }
}

Future<List<Map<String, dynamic>>> getData(String dept) async {
  try {
    // Get a reference to the collection
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(dept);

    // Query the collection for all documents
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Extract data from each document
    List<Map<String, dynamic>> data =
        querySnapshot.docs.map((DocumentSnapshot doc) {
      // Access fields within the document
      String title = doc['contact'];
      String id = doc['id'];
      String status = doc['status'];

      // Return a map representing the document's data
      return {
        'contact': title,
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
