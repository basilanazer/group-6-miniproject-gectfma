import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final IconData icon;
  final String iconLabel;
  final String dept;
  final String title;
  final Function() goto;
  const TopBar({
    super.key,
    required this.iconLabel,
    required this.title,
    required this.icon,
    required this.dept,
    required this.goto,
  });

  @override
  Widget build(BuildContext context) {
    // final screenwdt = MediaQuery.of(context).size.width;
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          SizedBox(
              height: 50,
              width: 50,
              child: Image.asset("assets/images/logo.png")),
          Text(
            "Government Engineering College Thrissur".toUpperCase(),
            style: TextStyle(
                color: Colors.brown[900],
                fontSize: 14,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (dept).toUpperCase(),
              style: TextStyle(
                  color: Colors.brown[600],
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            TextButton.icon(
              label: Text(
                iconLabel,
                selectionColor: Colors.brown[400],
                style: TextStyle(color: Colors.brown[600]),
              ),
              onPressed: goto,
              // {
              //   if (iconLabel == 'Log Out') {
              //     logOut(context);
              //   } else if (dept == "Sergeant") {
              //     //
              //     Navigator.of(context)
              //         .pushReplacement(MaterialPageRoute(builder: (context) {
              //       return SergeantComplaintSummary(
              //         deptName: "Sergeant",
              //       );
              //     }));
              //   } else if (dept == "Principal") {
              //     //
              //     // Navigator.of(context)
              //     //     .pushReplacement(MaterialPageRoute(builder: (context) {
              //     //   return SergeantComplaintSummary(
              //     //     deptName: "Sergeant",
              //     //   );
              //     // }));
              //     // } else {
              //     //   Navigator.of(context)
              //     //       .pushReplacement(MaterialPageRoute(builder: (context) {
              //     //     return ComplaintSummary(
              //     //       deptName: dept.split(' ').last,
              //     // }
              //   }
              //   if ((dept).toUpperCase() == "DEPARTMENT OF EE" &&
              //       iconLabel == 'Home') {
              //     //
              //     Navigator.of(context).pushAndRemoveUntil(
              //       MaterialPageRoute(builder: (context) {
              //         return NatureOfIssue(
              //           dept: "ee",
              //         );
              //       }),
              //       (Route<dynamic> route) => false,
              //     );
              //   } else if (iconLabel == 'Go Back') {
              //     //
              //     Navigator.of(context).pop();
              //   }
              // },
              icon: Icon(
                icon,
                color: Colors.brown[600],
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 25, color: Colors.brown[600]),
          ),
        ),
      ),
      //Size of this line
      const Divider(
        thickness: 1,
        color: Colors.black26,
      ),
    ]);
  }

  // Future<void> logOut(context) async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     // Navigate to your login screen or any other screen you desire
  //     // For example:
  //     Navigator.of(context).pushReplacementNamed('/login');
  //     MyDialog.showCustomDialog(
  //         context, "LOGGING OUT", "you have to log back in");
  //   } catch (e) {
  //     print("Error signing out: $e");
  //   }
  // }
}
