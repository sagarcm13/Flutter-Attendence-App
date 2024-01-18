import 'package:flutter/material.dart';

class TodayClasses extends StatefulWidget {
  const TodayClasses({super.key});

  @override
  State<TodayClasses> createState() => _TodayClassesState();
}

class _TodayClassesState extends State<TodayClasses> {
  String name = "Kirthan";
  String email = "kirthan.cs21@bmsce.ac.in";
  List<Map<String, String>> subjects = [
    {"subject": "DSA", 'AttendenceStatus': 'present', 'time': '9:30am'},
    {"subject": "DBMS", 'AttendenceStatus': 'absent', 'time': '10:30am'},
    {
      "subject": "Computer Network",
      'AttendenceStatus': 'absent',
      'time': '11:30am'
    }
  ];
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
            height: 50,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Text(
                  email,
                  style: const TextStyle(fontSize: 20),
                ),
              )),
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
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  String s = subjects[index]['subject']!;
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
                            Text(subjects[index]['subject']!),
                            Text(subjects[index]['time']!)
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            const Text("you are marked as "),
                            (subjects[index]['AttendenceStatus'] == 'present')
                                ? Text(
                                    subjects[index]['AttendenceStatus']!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(subjects[index]['AttendenceStatus']!,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold))
                          ],
                        ),
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
