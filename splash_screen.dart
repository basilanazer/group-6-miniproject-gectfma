import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MyHomePage()));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
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
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "GEC FMA",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          Container(
              height: 50,
              width: 50,
              child: Image.asset("assets/images/logo.png")),
        ],
      ),
    ));
  }
}
