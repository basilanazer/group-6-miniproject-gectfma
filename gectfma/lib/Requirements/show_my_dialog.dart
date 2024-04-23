import 'package:flutter/material.dart';

class MyDialog {
  static void showCustomDialog(BuildContext context, String heading, String body) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.amber.shade50,
          title: 
          Text(
            heading.toUpperCase(),
            style: 
              TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.brown.shade800
              ),
          ),
          content: 
            Text(
              body,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown.shade800
                ),
            ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: 
              Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800]
                ), 
              ),
            ),
          ],
        ),
      );
    
  }
}
