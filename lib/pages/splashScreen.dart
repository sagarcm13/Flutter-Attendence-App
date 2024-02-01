import 'dart:async';
// import 'package:attendease/main.dart';
import 'package:attendece/pages/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'AttendEase')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.blue.shade300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Images/attendity.png',),
              Text("Loading...", style: TextStyle(fontSize: 30, fontFamily: 'MyFont'),),
              SizedBox(height: 30,),
              Text("Mark your attendence at", style: TextStyle(fontSize: 20),),
              Text("Attendity", style: TextStyle(fontSize: 30, fontFamily: 'MyFont'),),
              SizedBox(height: 50,),
              Text("There is no time like the", style: TextStyle(fontSize: 15, color: Colors.white),),
              Text("PRESENT", style: TextStyle(fontSize: 15, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

