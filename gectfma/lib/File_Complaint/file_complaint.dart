import 'package:flutter/material.dart';

import '../Requirements/DetailsField.dart';
import '../Requirements/TopBar.dart';

class FileComplaint extends StatefulWidget {
  final String dept;

  const FileComplaint({super.key, required this.dept});

  @override
  State<FileComplaint> createState() => _FileComplaintState();
}

List<String> levels = ["H", "M", "L"];

class _FileComplaintState extends State<FileComplaint> {
  String currentLevel = levels[0];
  String? dropVal;
  DateTime _dateTime = DateTime.now();
  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final contactController = TextEditingController();
    String contact = "";
    final descController = TextEditingController();
    String desc = "";
    final hodController = TextEditingController();
    String hod = "";
    submit() {
      setState(() {
        contact = contactController.text;
        // widget.dept,widget.hodName,currentLevel,dropVal,
        // time,clock
        //dropval not getting..use textfiled??
        //splashscreen of success
        hod = hodController.text;
        desc = descController.text;
      });

      Navigator.of(context).pop();
    }

    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          TopBar(
            dept: "DEPARTMENT OF " + widget.dept,
            iconLabel: "Home",
            title: "new issue",
            icon: Icons.home_filled,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text("Complaint ID: CS008")),
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
                  value: dropVal,
                  onChanged: ((String? newVal) {
                    setState(() {
                      dropVal = newVal!;
                    });
                  })),
            ),
          ),
          DetailFields(
            controller: descController,
            hintText: "Description",
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
                      groupValue: currentLevel,
                      value: levels[0],
                      onChanged: (value) {
                        setState(() {
                          currentLevel = value.toString();
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
                      groupValue: currentLevel,
                      value: levels[1],
                      onChanged: (value) {
                        setState(() {
                          currentLevel = value.toString();
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
                      groupValue: currentLevel,
                      value: levels[2],
                      onChanged: (value) {
                        setState(() {
                          currentLevel = value.toString();
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
          Headings(title: "Additional documents*"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Docs"),
              Buttons(
                buttonTitle: "UPLOAD",
                fn: () {},
              )
            ],
          ),
          Headings(title: "Preffered date and time"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: _showDatePicker,
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.brown[600],
                    size: 40,
                  )),
              Text(
                _dateTime.toUtc().toString(),
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 20,
          ),
          Buttons(
            buttonTitle: "SUBMIT",
            fn: submit,
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    )));
  }
}

class Buttons extends StatelessWidget {
  final String buttonTitle;
  final Function() fn;
  const Buttons({
    Key? key,
    required this.buttonTitle,
    required this.fn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        width: 150,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.brown[600], borderRadius: BorderRadius.circular(10)),
        child: TextButton(
          onPressed: fn,
          child: Text(
            buttonTitle,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ));
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
