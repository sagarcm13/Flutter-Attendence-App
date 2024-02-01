import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:attendece/pages/home.dart';

class StudentsDetails extends StatefulWidget {
  const StudentsDetails({super.key});

  @override
  State<StudentsDetails> createState() => _StudentsDetails();
}

class _StudentsDetails extends State<StudentsDetails> {
  List<Map<String, dynamic>> studentDetails = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    getFacultyDetails();
  }

  Future<void> getFacultyDetails() async {
    await db
        .collection('Student_Info')
        .where("sec", isEqualTo: 'C')
        .where("sem", isEqualTo: 5)
        .get()
        .then((value) => {
      for (var doc in value.docs)
        {
          print("${doc.id} => ${doc.data()}"),
          studentDetails.add(doc.data()),
        }
    });
    print(studentDetails);
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
            "Faculty Details",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
          ),
          const Text('SEM 5 Section C',style: TextStyle(fontSize: 25),),
          Expanded(
            child: ListView.builder(
                itemCount: studentDetails.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(studentDetails[index]['name'],style: const TextStyle(fontSize: 25),),
                            Text('Sem: ${studentDetails[index]['sem']} Section: ${studentDetails[index]['sec']}',style: const TextStyle(fontSize: 20)),
                            Text("email: ${studentDetails[index]['email']}",style:const TextStyle(fontSize: 20)),
                            Text("phone: ${studentDetails[index]['phone']}",style:const TextStyle(fontSize: 20))
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )

        ],
      ),
    );
  }
}