import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gectfma/main.dart'; // Import main.dart where MyApp is defined

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // Fix syntax of the constructor

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
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
              const SizedBox(height: 90), // Add space at the top
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                "FACILITIES MANAGEMENT APP FOR GEC THRISSUR",
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center align the text
              ),
              ),
              // const Text(
              //   "FACILITIES MANAGEMENT APP FOR GEC THRISSUR",
              //   style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              //   textAlign: TextAlign.center, // Center align the text
              // ),
              const Spacer(), // Takes up remaining space
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset("assets/images/logo2.png"),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                "Loading...",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(), // Takes up remaining space
              const Text(
                "Maintained By PTA\nDeveloped By Students of CSE",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center align the text
              ),
              const SizedBox(height: 50), // Add space at the bottom
            ],
          ),
      ),
    );
  }
}
