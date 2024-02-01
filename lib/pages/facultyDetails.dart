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
  List subject = [];
  List email = [];
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
                  print("${doc.id} => ${doc.data()}"),
                  email.add(doc.data()['email']),subject.add(doc.data()['subject'])
                }
            });
    email=email.toSet().toList();
    subject=subject.toSet().toList();
    print(email);
    await db.collection("Faculty_Info").where('email',whereIn: email).get().then((value) => {
      for(var doc in value.docs){
        facultyDetails.add(doc.data())
      }
    });
    print(facultyDetails);
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
                itemCount: facultyDetails.length,
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
                        Text(facultyDetails[index]['name'],style: const TextStyle(fontSize: 25),),
                        Text('Subjects handling: ${subject[index]}',style: const TextStyle(fontSize: 20)),
                        Text("email: ${email[index]}",style:const TextStyle(fontSize: 20)),
                        Text("phone: ${facultyDetails[index]['phone']}",style:const TextStyle(fontSize: 20))
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
