import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gectfma/main.dart'; // Import main.dart where MyApp is defined

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}); // Fix syntax of the constructor

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
      // Navigate to MyApp instead of MyHomePage
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pink],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "GECT FMA",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: 50,
              child: Image.asset("assets/images/logo.png"),
            ),
          ],
        ),
      ),
    );
  }
}
