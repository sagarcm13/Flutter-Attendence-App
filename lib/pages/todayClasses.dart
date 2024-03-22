import 'package:attendece/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:attendece/pages/home.dart';

class TodayClasses extends StatefulWidget {
  final Map<String, dynamic> userDetail;
  const TodayClasses(this.userDetail, {super.key});
  @override
  State<TodayClasses> createState() => _TodayClassesState(userDetail);
}

class _TodayClassesState extends State<TodayClasses> {
  Map<String, dynamic> user;
  _TodayClassesState(this.user);
  bool isStudent = false;
  List<Map<String, dynamic>> classes = [];
  List<Map<String, dynamic>> subTimeSec = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List attendanceStatus = ['present', 'absent', 'absent', 'present', 'present'];
  late List<String> facultyNames=[];
  @override
  void initState() {
    super.initState();
    isStudent = user['email'].contains('cs21');
    print(user);
    if (isStudent) {
      studentGetClasses();
    } else {
      facultyGetClasses();
    }
  }

  Future<void> facultyGetClasses() async {
    // final User? user = auth.currentUser;
    // email=user!.email!;
    await db
        .collection("Subjects_Handling")
        .where("email", isEqualTo: user['email'])
        .get()
        .then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
        subTimeSec.add(doc.data());
      }
    });
    print(subTimeSec);
    setState(() {});
  }

  Future<void> studentGetClasses() async {
    // final User? user = auth.currentUser;
    // email=user!.email!;
    await db
        .collection("Class_Time_Table")
        .where("sec", isEqualTo: user['sec'])
        .where("day", isEqualTo: "tuesday")
        .get()
        .then((value) => {
              for (var doc in value.docs)
                {print("${doc.id} => ${doc.data()}"), classes.add(doc.data())}
            });
    var subjects = classes[0]['subjects'];
    print(subjects);
    var emails = [];
    await db
        .collection("Subjects_Handling")
        .where("subject", whereIn: subjects)
        .get()
        .then((value) => {
              for (var doc in value.docs) {emails.add(doc.data()["email"])}
            });
    print(emails);
    await db
        .collection("Faculty_Info")
        .where("email", whereIn: emails)
        .get()
        .then((value) => {
              for (var doc in value.docs) {facultyNames.add(doc.data()["name"])}
            });
    print(facultyNames);
    setState(() {
    });
  }

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
                style: TextStyle(fontSize: 40),
              ),
              IconButton(
                icon: const Icon(
                  Icons.person_pin,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile(user)));
                },
              )
            ],
          ),
          const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 30),
                child: Text(
                  "Today's Classes",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
            child: ListView.builder(
                itemCount: (isStudent && classes.isNotEmpty)
                    ? classes[0]['subjects'].length
                    : subTimeSec.length,
                itemBuilder: (context, index) {
                  String s = (isStudent)
                      ? classes[0]['subjects'][index]!
                      : subTimeSec[index]['subject'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(s[0]),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text((isStudent)
                                ? classes[0]['subjects'][index]!
                                : subTimeSec[index]['subject']),
                            Text((isStudent)
                                ? classes[0]['subjectTime'][index]!
                                : subTimeSec[index]['time'])
                          ],
                        ),
                        subtitle: (isStudent)
                            ? Row(
                                children: [
                                  Text("Subject handled by ${facultyNames[index]}"),
                                ],
                              )
                            : Text(
                                "you have a Class for ${subTimeSec[index]['sem']}${subTimeSec[index]['sec']}"),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
