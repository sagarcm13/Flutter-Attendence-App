import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:attendece/pages/home.dart';

class FacultyDetails extends StatefulWidget {
  const FacultyDetails({super.key});

  @override
  State<FacultyDetails> createState() => _FacultyDetailsState();
}

class _FacultyDetailsState extends State<FacultyDetails> {
  List<Map<String, dynamic>> facultyDetails = [];
  List<Map<String, dynamic>> subjectEmailMap = [];
  List<String> email = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    getFacultyDetails();
  }

  Future<void> getFacultyDetails() async {
    await db
        .collection('Subjects_Handling')
        .where("sec", isEqualTo: 'C')
        .where("sem", isEqualTo: 5)
        .get()
        .then((value) => {
              for (var doc in value.docs)
                {
                  email.add(doc.data()['email']),
                  subjectEmailMap.add({
                    "subject": doc.data()['subject'],
                    "email": doc.data()['email']
                  })
                }
            });
    await db
        .collection("Faculty_Info")
        .where('email', whereIn: email)
        .get()
        .then((value) => {
              for (var doc in value.docs) {facultyDetails.add(doc.data())}
            });
    for (var item in facultyDetails) {
      for (var map in subjectEmailMap) {
        if (map['email'] == item['email']) {
          item['subject'] = map['subject'];
          break; // Once found, break the loop
        }
      }
    }
    print(facultyDetails);
    setState(() {});
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
                onPressed: () {},
              )
            ],
          ),
          Container(
            height: 20,
          ),
          const Text(
            "Faculty Details",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
          const Text(
            'SEM 5 Section C',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: facultyDetails.length,
                itemBuilder: (context, index) {
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
                            child: Text(facultyDetails[index]['name'][0]),
                          ),
                          title: Text(facultyDetails[index]['name'],
                              style: const TextStyle(fontSize: 22)),
                          subtitle: Text(
                              "email: ${facultyDetails[index]['email']}\nSubject Handling: ${facultyDetails[index]['subject']}",
                              style: const TextStyle(fontSize: 18))),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
