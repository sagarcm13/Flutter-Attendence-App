import 'package:attendece/pages/home.dart';
import 'package:attendece/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MarkAttendence extends StatefulWidget {
  final Map<String, dynamic> user;
  const MarkAttendence(this.user, {super.key});
  @override
  State<MarkAttendence> createState() => _MarkAttendenceState(user);
}

class _MarkAttendenceState extends State<MarkAttendence>
    with TickerProviderStateMixin {
  final Map<String, dynamic> user;
  _MarkAttendenceState(this.user);
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> USN = [];
  List<bool> isMarked = List.filled(50, true);
  bool selectAll = true;

  List<int> seconds = [10, 20, 30, 40, 50, 60];
  List<int> range = [5, 10, 20];
  late int dropdownValue;
  late int dropdownValue2;
  late AnimationController controller;
  double get progress => controller.value;
  bool isActive = false;
  late bool serviceEnabled;
  late LocationPermission permission;
  Position? currentPosition;
  double? latitude;
  double? longitude;
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
    QuerySnapshot querySnapshot = await db
        .collection('Student_Attendance')
        .where('USN', whereIn: USN)
        .get();
    int i = 0;
    for (var doc in querySnapshot.docs) {
      DocumentReference documentReference = doc.reference;
      List<dynamic> currentSubjectInfo  = doc['subjectAttendance'];
      for (var item in currentSubjectInfo) {
        if (item['subject'] == "AA" && isMarked[i] == true) {
          item['total'] = (item['total']! + 1);
          item['attended'] = (item['attended']! + 1);
        }else if(item['subject'] == "AA"){
          item['total'] = (item['total']! + 1);
        }
      }
      print("$currentSubjectInfo");
      await documentReference.update({'subjectAttendance': currentSubjectInfo});
    }
  }

  Future<void> getLocationStatus() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
        setState(() {});
      }
    } else {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print(serviceEnabled);
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          currentPosition = position;
        });
      }
    }
  }

  Future<void> attendanceTrigger() async {
    await getLocationStatus();
    final currentPosition = this.currentPosition;
    if (currentPosition != null) {
      setState(() {
        controller.forward(from: 0);
        isActive = true;
      });
      latitude = currentPosition.latitude;
      longitude = currentPosition.longitude;
      print("latitude: $latitude longitude: $longitude");
      FirebaseFirestore.instance.collection('Attendance_Trigger').add({
        'MarkAttendance': true,
        'latitude': latitude,
        'longitude': longitude,
        'Range': dropdownValue2
      }).then((value) => print(value.id));
      Future.delayed(Duration(seconds: dropdownValue), () {
        FirebaseFirestore.instance
            .collection('Attendance_Trigger')
            .add({'MarkAttendance': false}).then((value) => print(value.id));
        setState(() {});
        FirebaseFirestore.instance
            .collection("Attendance_Trigger")
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
          setState(() {
            isActive=false;
          });
        }).catchError((error) {
          print("Error deleting documents: $error");
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getStudents();
    print(USN);
    dropdownValue = seconds[2];
    dropdownValue2 = range.first;
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: dropdownValue),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
          Container(height: 20,),
          const Text(
            "Attendance Trigger",
            style: TextStyle(fontSize: 30),
          ),
          Container(
            height: 20,
          ),
          const Text("Sub: AA",style: TextStyle(fontSize: 25),),
          Container(height: 20,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "set timer in seconds",
                style: TextStyle(fontSize: 20),
              ),
              Text("set Range in meters",style: TextStyle(fontSize: 20))
            ],
          ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownMenu<int>(
                initialSelection: dropdownValue,
                onSelected: (int? value) {
                  setState(() {
                    dropdownValue = value!;
                    controller.duration = Duration(seconds: dropdownValue);
                  });
                },
                dropdownMenuEntries:
                    seconds.map<DropdownMenuEntry<int>>((int value) {
                  return DropdownMenuEntry<int>(value: value, label: "$value");
                }).toList(),
              ),
              DropdownMenu<int>(
                initialSelection: range.first,
                onSelected: (int? value) {
                  setState(() {
                    dropdownValue2 = value!;
                  });
                },
                dropdownMenuEntries:
                    range.map<DropdownMenuEntry<int>>((int value) {
                  return DropdownMenuEntry<int>(value: value, label: "$value");
                }).toList(),
              ),
            ],
          ),
          Container(
            height: 10,
          ),
          (!isActive)?ElevatedButton(
              onPressed: () => attendanceTrigger(),
              child: const Text(
                'Trigger',
                style: TextStyle(fontSize: 20),
              )):Text(""),
          (isActive)
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Time left to mark Attendance ${dropdownValue - (dropdownValue * progress).floor()}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                          value: progress,
                          semanticsLabel: 'Circular progress indicator',
                        ),
                      ),
                    ],
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Trigger to mark Attendance',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
          const Text("Mark Attendance Manually",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Students",
                style: TextStyle(fontSize: 25),
              ),
              Row(
                children: [
                  const Text(
                    'select all',
                    style: TextStyle(fontSize: 20),
                  ),
                  Checkbox(
                      value: selectAll,
                      onChanged: (bool? value) {
                        setState(() {
                          selectAll = value!;
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
                          if (isMarked.contains(false)) {
                            selectAll = false;
                          } else {
                            selectAll = true;
                          }
                        });
                      },
                    ),
                  );
                }),
          ),
          ElevatedButton(
              onPressed: () => markAttendance(),
              child: const Text('Submit Attendance'))
        ],
      ),
    );
  }
}
