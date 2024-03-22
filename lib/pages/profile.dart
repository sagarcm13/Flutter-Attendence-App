import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:attendece/pages/login.dart';

import 'home.dart';

class Profile extends StatefulWidget{
  Map<String, dynamic> user;
  Profile(this.user,{super.key});
  @override
  State<Profile> createState() => _ProfileState(user);
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> user;
  _ProfileState(this.user);
  Future<void> signout() async{
    await FirebaseAuth.instance.signOut();
    routeToLogin();
  }
  void routeToLogin(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => Login()),
          (Route<dynamic> route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.blue.shade700],
          ),
        ),
        child: Column(
          children: [
            Container(height: 35,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const Home()),
                          (Route<dynamic> route) => false,
                    );
                  },
                ),
                const Text(
                  "Attendity",
                  style: TextStyle(fontSize: 35),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    size: 35,
                  ),
                  onPressed: () => signout(),
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            const CircleAvatar(
              radius: 100.0,
              backgroundImage: AssetImage('assets/Images/logo.png'), // Add your image path
            ),
            const SizedBox(height: 20.0),
            Text(
              user['name'],
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            (user['email'].contains('cs21'))?getStudentDetails():getFaclutyDetails()
          ],
        ),
      ),
    );
  }
  Widget getStudentDetails(){
    return Column(
      children: [
        getValueWidget('USN',user['USN']),
        getValueWidget("Email",user['email']),
        getValueWidget("Phone","${user['phone']}"),
        getValueWidget("Course",user['course']),
        getValueWidget("Semester","${user['sem']}"),
        getValueWidget("Section",user['sec']),
      ],
    );
  }
  Widget getFaclutyDetails(){
    return Column(
      children: [
        getValueWidget("Employee ID","BM21CS422"),
        getValueWidget("Email",user['email']),
        getValueWidget("Phone no", "${user['phone']}"),
        getValueWidget("Course",user['course']),
      ],
    );
  }
  Widget getValueWidget(String key,String value){
    return Column(
      children:[ const SizedBox(height: 10.0),
        Text(
          '$key: $value',
          style: const TextStyle(fontSize: 20.0),
        ),
      ]
    );
  }
}