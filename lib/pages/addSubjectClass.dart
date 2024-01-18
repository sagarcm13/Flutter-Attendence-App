import 'package:attendece/pages/home.dart';
import 'package:flutter/material.dart';

class AddSubjectClass extends StatefulWidget {
  @override
  State<AddSubjectClass> createState() => _AddSubjectClassState();
}

class _AddSubjectClassState extends State<AddSubjectClass> {
  List<Map<String, dynamic>> addedSubjects = [];
  static List<String> sem = ["1", '2', '3', '4', '5', '6', '7', '8'];
  static List<String> subject = ["DBMS", "DSA", "OS", "AI", "IOT", "CN"];
  static List<String> section = ['A', 'B', 'C', 'D'];
  String dropdownSem = sem.first;
  String dropdownSection = section.first;
  String dropdownSubject = subject.first;
  void addSubjects() {
    Map<String, String> sub = {
      'Sem': dropdownSem,
      'Section': dropdownSection,
      'Subject': dropdownSubject
    };
    for (var item in addedSubjects) {
      if (item['Sem'] == dropdownSem &&
          item['Section'] == dropdownSection &&
          item['Subject'] == dropdownSubject) {
        return;
      }
    }
    addedSubjects.add(sub);
    setState(() {});
  }

  void removeSubject(var item) {
    addedSubjects.remove(item);
    setState(() {});
    print(addedSubjects);
  }
  void handleSubmit(){
    print("submit");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Home()),
          (Route<dynamic> route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 40,
          ),
          const Text("ATTENDITY"),
          const Text('Add Subjects'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("SEMESTER"), Text("SECTION"), Text("SUBJECTS")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownMenu<String>(
                width: 100,
                initialSelection: sem.first,
                onSelected: (String? value) {
                  setState(() {
                    dropdownSem = value!;
                  });
                },
                dropdownMenuEntries:
                    sem.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              DropdownMenu<String>(
                width: 100,
                initialSelection: section.first,
                onSelected: (String? value) {
                  setState(() {
                    dropdownSection = value!;
                  });
                },
                dropdownMenuEntries:
                    section.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              DropdownMenu<String>(
                width: 130,
                initialSelection: subject.first,
                onSelected: (String? value) {
                  setState(() {
                    dropdownSubject = value!;
                  });
                },
                dropdownMenuEntries:
                    subject.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () => addSubjects(), child: const Text("Add")),
          Expanded(
            child: addedSubjects.isEmpty
                ? const Text("No subjects added yet.")
                : ListView.builder(
                    itemCount: addedSubjects.length,
                    itemBuilder: (context, index) {
                      String sem = addedSubjects[index]['Sem'];
                      String section = addedSubjects[index]['Section'];
                      String subject = addedSubjects[index]['Subject'];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sem: $sem, Section: $section, Subject: $subject',
                              style: const TextStyle(fontSize: 17),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () =>
                                  removeSubject(addedSubjects[index]),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: () {
               handleSubmit();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: const Text(
              'Sign Up',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}
