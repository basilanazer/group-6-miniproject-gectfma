import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gectfma/Login/forgot_pw.dart';
import 'package:gectfma/firebase_options.dart';

import 'Login/login_page.dart';
import 'splash_screen.dart'; // Import splash_screen.dart where SplashScreen is defined

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Use await since Firebase.initializeApp is async
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.brown[50], primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,
      color: Colors.amberAccent,
      title: "Facilities Management App",
      home: SplashScreen(), 
      // Set SplashScreen as the initial screen
      routes: {
        '/login': (context) => Login(), // Assuming your Login widget is named Login
        
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Login(),
    );
  }
}
