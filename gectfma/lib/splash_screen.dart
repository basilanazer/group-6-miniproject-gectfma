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
    Future.delayed(Duration(seconds: 7), () {
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
            colors: [Colors.brown,Colors.brown.shade600,Colors.brown.shade700,Colors.brown.shade800],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "GECT FMA",
              style: TextStyle(color: Colors.white, fontSize: 30,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/images/logo2.png")
            ),
            SizedBox(height: 40,),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ), const SizedBox(height: 20),
            const Text(
              "Loading...",
              style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
