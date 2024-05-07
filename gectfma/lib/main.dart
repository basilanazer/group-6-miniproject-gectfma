// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:gectfma/Complaint_Summary/complaint_summary.dart';
// import 'package:gectfma/Complaint_Summary/sergeant_complaint_summary.dart';
// import 'package:gectfma/NatureOfIssue/comp_verification.dart';
// import 'package:gectfma/NatureOfIssue/nature.dart';
// import 'package:gectfma/View_Complaints/Principal/principal_view_all_complaint.dart';
// import 'package:gectfma/firebase_options.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'Login/login_page.dart';
// import 'splash_screen.dart';

// var email;
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   email = preferences.getString('email');
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Use await since Firebase.initializeApp is async
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//    @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(scaffoldBackgroundColor: Colors.white, primarySwatch: Colors.brown),
//       debugShowCheckedModeBanner: false,
//       color: Colors.amberAccent,
//       title: "Facilities Management App",
//       home: SplashScreen(),
//       // Set SplashScreen as the initial screen
//       routes: {
//         '/login': (context) => Login(), // Assuming your Login widget is named Login

//       },
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {

//   Widget _buildbody(){
//     if (email == ''|| email == null) {
//       return Login();
//     }
//     else{
//       return ComplaintSummary(deptName: email.split("@")[0].substring(3));
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.brown[50],
//       body:_buildbody(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gectfma/Complaint_Summary/sergeant_complaint_summary.dart';
import 'package:gectfma/NatureOfIssue/comp_verification.dart';
import 'package:gectfma/NatureOfIssue/nature.dart';
import 'package:gectfma/View_Complaints/Principal/principal_view_all_complaint.dart';
import 'package:gectfma/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:gectfma/Complaint_Summary/complaint_summary.dart';
import 'package:gectfma/Login/login_page.dart';
import 'package:gectfma/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

var email;
var userData;

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage msg) async {
//   print("Bg msg ${msg.messageId}");
// }

// void requestPermission() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     sound: false,
//     provisional: false,
//     criticalAlert: false,
//     carPlay: false,
//   );
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission for notifications');
//   } else if (settings.authorizationStatus ==
//       AuthorizationStatus.provisional) {
//     print('User granted provisional permission');
//   } else {
//     print('User declined or has not granted permission for notifications');
//   }
// }

initInfo() {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidInit = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosInit = const DarwinInitializationSettings();
  var initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
  flutterLocalNotificationsPlugin.initialize(initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? payload) async {
    try {
      if (payload != null) {
      } else {}
    } catch (e) {}
    return;
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage msg) async {
    // print("MSG");
    // print("${msg.notification?.title} and ${msg.notification?.body}");
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        msg.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: msg.notification!.title.toString(),
        htmlFormatContentTitle: true);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('dbfood', 'dbfood',
            importance: Importance.max,
            styleInformation: bigTextStyleInformation,
            priority: Priority.high,
            playSound: false);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        iOS: const DarwinNotificationDetails(),
        android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, msg.notification?.title,
        msg.notification?.body, platformChannelSpecifics,
        payload: msg.data['body']);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  email = preferences.getString('email');
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase
  await FirebaseMessaging.instance.getInitialMessage();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (email != null) {
    // Fetch user data if email is not null
    await fetchUserData();
  }
  await initInfo();
  runApp(MyApp());
}

Future<void> fetchUserData() async {
  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    userData = userDoc.data();
    // print('User Data: $userData');
  } catch (e) {
    // print('Error fetching user data: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,
      title: "Facilities Management App",
      home: SplashScreen(),
      // Set SplashScreen as the initial screen if email is null, otherwise set HomeScreen
      routes: {
        '/login': (context) =>
            Login(), // Assuming your Login widget is named Login
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  Future<Widget> _buildBody() async {
    if (userData != null) {
      var dept = userData['dept'] as String?;
      var role = userData['role'] as String?;
      // print("Dept: $dept, Role: $role");
      if (dept != null && dept != '') {
        await FirebaseMessaging.instance.getToken().then((token) {
          FirebaseFirestore.instance.collection("UserTokens").doc(dept).set({
            'token': token,
          });
        });
        if (dept == 'ee') {
          return NatureOfIssue(dept: dept);
        } else {
          return ComplaintSummary(deptName: dept);
        }
      } else {
        if (role != null && role != '') {
          await FirebaseMessaging.instance.getToken().then((token) {
            FirebaseFirestore.instance.collection("UserTokens").doc(role).set({
              'token': token,
            });
          });
          if (role == 'sergeant') {
            return SergeantComplaintSummary(role: role);
          } else if (role == 'principal') {
            return const PrincipalViewAllComplaint();
          } else {
            return const complaintVerification(nature: "Plumbing");
          }
        }
      }
    }
    // Return a default empty container if userData is null or doesn't match expected structure
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: email == null
          ? Login()
          : FutureBuilder<Widget>(
              future: _buildBody(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return snapshot.data ??
                      Container(); // Return the built widget or a default empty container
                }
              },
            ),
    );
  }
}
