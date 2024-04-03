import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final IconData icon;
  final String iconLabel;
  final String dept;
  final String title;
  const TopBar({
    Key? key,
    required this.iconLabel,
    required this.title,
    required this.icon,
    required this.dept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final screenwdt = MediaQuery.of(context).size.width;
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Container(
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
      SizedBox(
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
              onPressed: () {
                Navigator.pop(context);
              },
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
      Divider(
        thickness: 1,
        color: Colors.black26,
      ),
    ]);
  }
}
