import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Complaint_Summary/complaint_summary.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
import '../Requirements/DetailsField.dart';
import '../Requirements/TopBar.dart';

class FileComplaint extends StatefulWidget {
  final String dept;

  const FileComplaint({super.key, required this.dept});

  @override
  State<FileComplaint> createState() => _FileComplaintState();
}

List<String> levels = ["High", "Medium", "Low"];

class _FileComplaintState extends State<FileComplaint> {
  String urgency = levels[0];
  String? nature;
  TextEditingController contactController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController hodController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    contactController.dispose();
    descController.dispose();
    hodController.dispose();
    super.dispose();
  }
  // DateTime _dateTime = DateTime.now();
  // void _showDatePicker() {
  //   showDatePicker(
  //           context: context,
  //           initialDate: DateTime.now(),
  //           firstDate: DateTime.now(),
  //           lastDate: DateTime(2025))
  //       .then((value) {
  //     setState(() {
  //       _dateTime = value!;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    String contact = "";
    String desc = "";
    String hod = "";
    

    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          TopBar(
            dept: "DEPARTMENT OF " + widget.dept,
            iconLabel: "Home",
            title: "NEW COMPLAINT",
            icon: Icons.home_filled,
          ),
          Headings(title: "Department Details*"),
          DetailFields(
            isEnable: false,
            hintText: widget.dept,
          ),
          DetailFields(
            hintText: "Name of HOD",
            controller: hodController,
          ),
          DetailFields(
            hintText: "Contact No",
            controller: contactController,
          ),
          Headings(title: "Complaint Details*"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton(
                  hint: Text("Nature Of Issue"),
                  isExpanded: true,
                  underline: SizedBox(),
                  items: const [
                    DropdownMenuItem<String>(
                      child: Text(
                        "Plumbing",
                      ),
                      value: "Plumbing",
                    ),
                    DropdownMenuItem<String>(
                      child: Text(
                        "Electrical",
                      ),
                      value: "Electrical",
                    )
                  ],
                  value: nature,
                  onChanged: ((String? newVal) {
                    setState(() {
                      nature = newVal!;
                    });
                  })),
            ),
          ),
          DetailFields(
            controller: descController,
            hintText: "Description",
          ),
          Headings(title: "Additional documents*"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Docs"),
              ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.brown[50], 
                  backgroundColor: Colors.brown[800], // Text color
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Corner radius
                  ),
                  minimumSize: Size(150, 50), // Width and height
                ),
                child: Text('UPLOAD'),
              ),
            ],
            
          ),
          Headings(title: "Urgency level*"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Radio<String>(
                      groupValue: urgency,
                      value: levels[0],
                      onChanged: (value) {
                        setState(() {
                          urgency = value.toString();
                        });
                      },
                      activeColor: Colors.brown[600], // Change the color here
                    ),
                    Text("High")
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      groupValue: urgency,
                      value: levels[1],
                      onChanged: (value) {
                        setState(() {
                          urgency = value.toString();
                        });
                      },
                      activeColor: Colors.brown[600], // Change the color here
                    ),
                    Text("Medium")
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      groupValue: urgency,
                      value: levels[2],
                      onChanged: (value) {
                        setState(() {
                          urgency = value.toString();
                        });
                      },
                      activeColor: Colors.brown[600], // Change the color here
                    ),
                    Text("Low")
                  ],
                ),
              ],
            ),
          ),
          
          // Headings(title: "Preffered date and Time"),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     IconButton(
          //         onPressed: _showDatePicker,
          //         icon: Icon(
          //           Icons.calendar_month_outlined,
          //           color: Colors.brown[600],
          //           size: 40,
          //         )),
          //     Text(
          //       _dateTime.toUtc().toString(),
          //       style: TextStyle(fontSize: 15),
          //     )
          //   ],
          // ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                hod = hodController.text;
                contact = contactController.text;
                desc = descController.text;

              });
              addComplaints(widget.dept, hod, contact, nature, desc, urgency);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.brown[50], 
              backgroundColor: Colors.brown[800], // Text color
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Corner radius
              ),
                          minimumSize: Size(150, 50), // Width and height
                        ),
                        child: Text('SUBMIT'),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    )));
  }
  

  void addComplaints(String dept, String hod, String contact, String? nature, String desc, String urgency) async {
    try {
      if(dept=='' || hod == '' || contact == '' || nature == null || desc == ''){
        MyDialog.showCustomDialog(context,
          "ERROR!!",
          "None of the fields can be empty",
        );
      }
      else{
          // Generate the custom ID
          String customDocId = await generateDeptId(dept);

          // Get a reference to the specific document with the custom ID
          DocumentReference docRef = FirebaseFirestore.instance.collection(dept).doc(customDocId);

          // Set the data in the document with the custom ID
          await docRef.set({
            'hod': hod,
            'contact': contact,
            'nature': nature,
            'desc': desc,
            'urgency': urgency,
            'status' : 'pending'
          });
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ComplaintSummary(
            deptName: dept,
          );
        }));
          MyDialog.showCustomDialog(context,
          "NEW COMPLAINT REGISTERED", 
          "Your complaint ID is $customDocId"
          );
          print("Document added with ID: $customDocId");
          
      } // Optionally, confirm document was added
    } catch (e) {
      print("Error adding document: $e");
       MyDialog.showCustomDialog(context,
         "ERROR!!",
        "Some error occured. Please try again",
      ); // Handle errors here
    }
  }

  Future<String> generateDeptId(String dept) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Reference to the department's collection
  CollectionReference deptCollection = firestore.collection(dept);

  // Retrieve all documents to count them
  QuerySnapshot snapshot = await deptCollection.get();
  int numberOfDocuments = snapshot.docs.length;

  // Generate the ID with padding to ensure it is always three digits
  String paddedNumber = (numberOfDocuments + 1).toString().padLeft(3, '0'); // +1 for the next document
  return '$dept$paddedNumber';
}
}

// class Buttons extends StatelessWidget {
//   final String buttonTitle;
//   final Function() fn;
//   const Buttons({
//     Key? key,
//     required this.buttonTitle,
//     required this.fn,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: const EdgeInsets.all(8.0),
//         width: 150,
//         height: 50,
//         decoration: BoxDecoration(
//             color: Colors.brown[600], borderRadius: BorderRadius.circular(10)),
//         child: TextButton(
//           onPressed: (){
//             addComplaints(widget.dept, hod, contact, nature, desc, urgency)
//           },
//           child: Text(
//             buttonTitle,
//             style: TextStyle(color: Colors.white, fontSize: 17),
//           ),
//         ));
//   }

  

