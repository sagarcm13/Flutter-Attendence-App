import 'package:attendece/pages/markAttendence.dart';
import 'package:attendece/pages/myAttendance.dart';
import 'package:attendece/pages/studentDetails.dart';
import 'package:attendece/pages/todayClasses.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "Kirthan";
  String email = "kirthan.cse21@bmsce.ac.in";
  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
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
                  style: const TextStyle(fontSize: 18),
                ),
              )),
          Container(
            height: 30,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Hi, Kirthan.",
                style: TextStyle(
                  fontSize: 38,
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
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     width: 1,
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TodayClasses()));
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
                    onPressed: () {if(email.contains('.cse')){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const MarkAttendence()));
                    }
    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (email.contains('.cse'))
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentDetails()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (email.contains('.cse'))
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyAttendance()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Attendance",
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                        Icon(Icons.play_arrow)
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
