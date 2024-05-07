import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Complaint_Summary/complaint_summary.dart';
import 'package:gectfma/Notifications/notification_send.dart';
import 'package:gectfma/Requirements/Headings.dart';
import 'package:gectfma/Requirements/show_my_dialog.dart';
// import 'package:googleapis/androidenterprise/v1.dart';
import '../Requirements/DetailFields.dart';
import '../Requirements/TopBar.dart';
import 'package:file_picker/file_picker.dart';

class FileComplaint extends StatefulWidget {
  final String dept;

  const FileComplaint({super.key, required this.dept});

  @override
  State<FileComplaint> createState() => _FileComplaintState();
}

List<String> levels = ["High", "Medium", "Low"];

class _FileComplaintState extends State<FileComplaint> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String urlDownload = '';

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      // print("file didnt selected");
    }
    setState(() {
      pickedFile = result?.files.first;
    });
  }

  Future uploadFile() async {
    if (pickedFile == null) {
      // print("No file selected for upload.");
      return;
    }

    try {
      String fname = await generateDeptId(widget.dept);
      final path = '${widget.dept}/$fname';

      final file = File(pickedFile!.path!);
      final contentType = pickedFile!.extension ?? 'octet-stream';

      final ref = FirebaseStorage.instance.ref().child(path);
      final metadata = SettableMetadata(contentType: 'image/$contentType');

      uploadTask = ref.putFile(file, metadata);

      final snapshot = await uploadTask!.whenComplete(() {});
      urlDownload = await snapshot.ref.getDownloadURL();

      // print('Download link - $urlDownload');
      MyDialog.showCustomDialog(
          context, 'image uploaded', 'The image was successfully uploaded.');
    } catch (e) {
      // print(e);
    }
  }

  String urgency = levels[0];
  String? nature;
  String? mtoken = "";

  TextEditingController contactController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController hodController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    titleController.dispose();
    contactController.dispose();
    descController.dispose();
    hodController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // requestPermission();
  //   // getToken();
  //   // initInfo();
  // }

  void addComplaints(String dept, String hod, String contact, String? nature,
      String desc, String title, String urgency) async {
    try {
      if (dept == '' ||
          hod == '' ||
          title == '' ||
          contact == '' ||
          nature == null ||
          desc == '' ||
          urlDownload == '') {
        MyDialog.showCustomDialog(
          context,
          "ERROR!!",
          "None of the fields can be empty",
        );
      } else {
        // Generate the custom ID
        String customDocId = await generateDeptId(dept);

        // Get a reference to the specific document with the custom ID
        DocumentReference docRef =
            FirebaseFirestore.instance.collection(dept).doc(customDocId);

        // Set the data in the document with the custom ID
        await docRef.set({
          'id': customDocId,
          'dept': dept,
          'hod': hod,
          'contact': contact,
          'nature': nature,
          'desc': desc,
          'title': title,
          'urgency': urgency,
          'status': 'pending',
          'filed_date': DateTime.now(),
          'image': urlDownload,
          'assigned_staff': '',
          'assigned_staff_no': '',
          'verification_remark': '',
          'rating_no': '',
          'hod_completed_review': '',
        });
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
            return ComplaintSummary(
              deptName: dept,
            );
          }),
          (Route<dynamic> route) => false,
        );
        MyDialog.showCustomDialog(context, "NEW COMPLAINT REGISTERED",
            "Your complaint ID is $customDocId");
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection("UserTokens")
            .doc(nature == "Electrical" ? "ee" : "p-in-charge")
            .get();
        String token = snap['token'];
        sendPushMessage(token, customDocId, "Waiting for your approval");

        // print("Document added with ID: $customDocId");
      } // Optionally, confirm document was added
    } catch (e) {
      // print("Error adding document: $e");
      MyDialog.showCustomDialog(
        context,
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
    String paddedNumber = (numberOfDocuments + 1)
        .toString()
        .padLeft(3, '0'); // +1 for the next document
    return '$dept$paddedNumber';
  }

  void showImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber.shade50,
          content: Container(
            // You might want to constrain the size here depending on your design needs
            width: double.maxFinite,
            child: Image.file(
              File(pickedFile!.path!),
              fit: BoxFit.cover,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text(
                'Close',
                style: TextStyle(color: Colors.brown),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String contact = "";
    String desc = "";
    String hod = "";
    String title = "";
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          TopBar(
            dept: "DEPARTMENT OF " + widget.dept,
            iconLabel: 'Go Back',
            title: "NEW COMPLAINT",
            icon: Icons.arrow_back,
            goto: () {
              Navigator.of(context).pop();
            },
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
            controller: titleController,
            hintText: "Title",
          ),
          DetailFields(
            controller: descController,
            hintText: "Description",
          ),
          Headings(title: "Additional documents*"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (pickedFile == null)
                TextButton.icon(
                  onPressed: () {
                    selectFile();
                  },
                  label: Text(
                    "select file",
                    selectionColor: Colors.brown[400],
                    style: TextStyle(
                      color: Colors.brown[600],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  icon: Icon(
                    Icons.file_open_outlined,
                    color: Colors.brown[600],
                  ),
                ),
              if (pickedFile != null)
                TextButton(
                    onPressed: () => showImageDialog(),
                    child: Text(pickedFile!.name,
                        style: TextStyle(
                            color: Colors.brown,
                            decoration: TextDecoration.underline))),
              if (pickedFile != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      pickedFile = null;
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.brown,
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  uploadFile();
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
          SizedBox(
            height: 20,
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
                title = titleController.text;
              });
              addComplaints(
                  widget.dept, hod, contact, nature, desc, title, urgency);
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
}
