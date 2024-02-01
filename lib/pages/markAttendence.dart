import 'package:attendece/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarkAttendence extends StatefulWidget {
  Map<String, dynamic> user;
  MarkAttendence(this.user, {super.key});

  @override
  State<MarkAttendence> createState() => _MarkAttendenceState(user);
}

class _MarkAttendenceState extends State<MarkAttendence> {
  Map<String, dynamic> user;
  _MarkAttendenceState(this.user);
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> USN = [];
  List<bool> isMarked = List.filled(50, true);
  bool selectAll=true;
  Future<void> getStudents() async {
    await db
        .collection("Student_Info")
        .where("sec", isEqualTo: 'C')
        .where("sem", isEqualTo: 5)
        .get()
        .then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()['USN']}");
        USN.add(doc.data()['USN']);
      }
    });
    print(USN);
    setState(() {});
  }

  Future<void> markAttendance() async {
    List isPresent = [];
    List isAbsent = [];
    for (int i = 0; i < USN.length; i++) {
      if (isMarked[i] == true) {
        isPresent.add(USN[i]);
      } else {
        isAbsent.add(USN[i]);
      }
    }
    QuerySnapshot querySnapshot=await db.collection('Student_Attendance').where('USN',whereIn: USN).get();
    int i=0;
      for (var doc in querySnapshot.docs) {
        DocumentReference documentReference = doc.reference;
        Map<String, dynamic> currentSubjectInfo = doc['AA-Status'];
        if(isMarked[i]==true){
          currentSubjectInfo['total_classes']=(currentSubjectInfo['total_classes']!+1);
          currentSubjectInfo['Attended']=(currentSubjectInfo['Attended']!+1);
        }else{
          currentSubjectInfo['total_classes']=(currentSubjectInfo['total_classes']!+1);
        }
        print("$currentSubjectInfo");
        await documentReference.update({'AA-Status': currentSubjectInfo});
      }
  }

  @override
  void initState() {
    super.initState();
    getStudents();
    print(USN);
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
          const Text("Mark Attendance",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [const Text("Students",style: TextStyle(fontSize: 25),),
            Row(
              children: [
                const Text('select all',style: TextStyle(fontSize: 20),),
                Checkbox(value: selectAll, onChanged: (bool? value){
                  setState(() {
                    selectAll=value!;
                    isMarked = List.filled(50, selectAll);
                  });
                }),
              ],
            )
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: USN.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(USN[index].substring(7)),
                    ),
                    title: Text(USN[index]),
                    subtitle: Row(
                      children: [
                        const Text('Marked as '),
                        (isMarked[index])
                            ? const Text(
                                'Present',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                "Absent",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                      ],
                    ),
                    trailing: Checkbox(
                      value: isMarked[index],
                      onChanged: (bool? value) {
                        setState(() {
                          isMarked[index] = value!;
                          if(isMarked.contains(false)){
                            selectAll=false;
                          }else{
                            selectAll=true;
                          }
                        });
                      },
                    ),
                  );
                }),
          ),
          ElevatedButton(
              onPressed: () => markAttendance(), child: const Text('Submit Attendance'))
        ],
      ),
    );
  }
}
