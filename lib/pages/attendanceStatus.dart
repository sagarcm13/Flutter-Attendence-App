import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:attendece/pages/home.dart';

class AttendaceStatus extends StatefulWidget {
  const AttendaceStatus({super.key});

  @override
  State<AttendaceStatus> createState() => _AttendaceStatusState();
}

class _AttendaceStatusState extends State<AttendaceStatus> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> getAttendance = [];
  List USN = [];
  @override
  void initState() {
    super.initState();
    getAttendanceStatus();
  }

  Future<void> getAttendanceStatus() async {
    await db
        .collection('Student_Info')
        .where('sem', isEqualTo: 5)
        .where('sec', isEqualTo: 'C')
        .get()
        .then((value) => {
              for (var doc in value.docs) {USN.add(doc.data()['USN'])}
            });
    List<dynamic> list = [];
    await db
        .collection('Student_Attendance')
        .where('USN', whereIn: USN)
        .get()
        .then((value) => {
              for (var doc in value.docs)
                {print(doc.data()), list.add(doc.data()['subjectAttendance'])}
            });
    for (var listItem in list) {
      for (var item in listItem) {
        if (item['subject'] == 'AA') {
          getAttendance.add(
              {"total_classes": item['total'], 'Attended': item['attended']});
        }
      }
    }
    print(getAttendance);
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
            height: 50,
          ),
          const Text(
            "AA-Attendance Status",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: getAttendance.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(USN[index]),
                    subtitle: Text(
                        'Total Classes: ${getAttendance[index]['total_classes']} Attended: ${getAttendance[index]['Attended']}'),
                    leading: CircleAvatar(
                        radius: 30,
                        child: Text(
                            '${(getAttendance[index]['Attended'] / getAttendance[index]['total_classes'] * 100).floor()}%')),
                  );
                }),
          )
        ],
      ),
    );
  }
}
