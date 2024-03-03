import 'package:attendece/pages/attendanceStatus.dart';
import 'package:attendece/pages/facultyDetails.dart';
import 'package:attendece/pages/getAttendandanceButton.dart';
import 'package:attendece/pages/markAttendence.dart';
import 'package:attendece/pages/myAttendance.dart';
import 'package:attendece/pages/profile.dart';
import 'package:attendece/pages/studentsDetails.dart';
import 'package:attendece/pages/todayClasses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "";
  String email = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> user = [];
  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    final User? userDetail = auth.currentUser;
    email=userDetail!.email!;
    if (!email.contains('cs21')) {
      print('get $email');
      await db
          .collection("Faculty_Info")
          .where("email", isEqualTo: email)
          .get()
          .then((event) {
        for (var doc in event.docs) {
          print("${doc.id} => ${doc.data()}");
          user.add(doc.data());
        }
      });
      name = user[0]["name"];
    } else {
      await db
          .collection("Student_Info")
          .where("email", isEqualTo: email)
          .get()
          .then((event) {
        for (var doc in event.docs) {
          print("${doc.id} => ${doc.data()}");
          user.add(doc.data());
        }
      });
      name = user[0]["name"];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (user.isNotEmpty) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    size: 40,
                  ),
                  onPressed: () {},
                ),
                const Text(
                  "Attendity",
                  style: TextStyle(fontSize: 40),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.person_pin,
                    size: 40,
                  ),
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(user[0])));},
                )
              ],
            ),
            Container(
              height: 40,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                )),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Text(
                    email,
                    style: const TextStyle(fontSize: 15),
                  ),
                )),
            Container(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Hi, $name.",
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "Welcome to your Class",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
            ),
            Container(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        try{
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodayClasses(user[0])));
                        }catch(e){
                          print(e);
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Classes",
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                          Icon(Icons.play_arrow)
                        ],
                      ),
                    ),
                  )),
            ),
            Container(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        if (!email.contains('.cs21')) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MarkAttendence(user[0])));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyAttendance()));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (!email.contains('.cs21'))
                              ? const Text(
                                  'Mark Attendence',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                )
                              : const Text(
                                  "Check Attendance Report",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                ),
                          const Icon(Icons.play_arrow)
                        ],
                      ),
                    ),
                  )),
            ),
            Container(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        if (email.contains('.cs21')) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FacultyDetails()));
                        }else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const StudentsDetails()));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (!email.contains('.cs21'))
                              ? const Text(
                                  'Student Details',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                )
                              : const Text(
                                  'Faculty Details',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                ),
                          const Icon(Icons.play_arrow)
                        ],
                      ),
                    ),
                  )),
            ),
            Container(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        if (!email.contains("cs21")) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AttendaceStatus()));
                        }else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  GetAttendanceButton(user[0])));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (email.contains('cs21'))
                              ? const Text(
                                  "Mark Attendance",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                )
                              : const Text(
                                  'Attendance Status',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                ),
                          const Icon(Icons.play_arrow)
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      );
    } else {
      return const Scaffold(body: Center(child: Text('User Data Loading')));
    }
  }
}
