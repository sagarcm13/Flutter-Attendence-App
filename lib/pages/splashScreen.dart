import 'dart:async';
import 'package:attendece/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => (FirebaseAuth.instance.currentUser!=null)?const Home():Login()));
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
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("A",style: TextStyle(fontFamily: 'MyFont',fontSize: 130),),
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

