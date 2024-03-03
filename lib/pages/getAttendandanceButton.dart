import 'package:attendece/pages/home.dart';
import 'package:attendece/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'dart:math';

class GetAttendanceButton extends StatefulWidget {
  Map<String, dynamic> user;
  GetAttendanceButton(this.user,{super.key});

  @override
  State<GetAttendanceButton> createState() => _GetAttendanceButtonState(user);
}

class _GetAttendanceButtonState extends State<GetAttendanceButton> {
  Map<String, dynamic> user;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  _GetAttendanceButtonState(this.user);
  List<Map<String, dynamic>> data = [];
  bool status = false;
  String subject = "AA";
  double? latitude;
  double? longitude;
  late bool serviceEnabled;
  late LocationPermission permission;
  Position? currentPosition;
  @override
  void initState() {
    super.initState();
    getDbUpdate();
  }
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Radius of the Earth in meters
    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }
  bool isWithin10Meters(double currentLat, double currentLon, double targetLat, double targetLon) {
    double distance = calculateDistance(currentLat, currentLon, targetLat, targetLon);
    return distance <= 10;
  }

  Future<void> getDbUpdate() async {
    db
        .collection('Attendance_Trigger')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          print("New document added: ${change.doc.data()}");
          setState(() {
            status = change.doc.data()?['MarkAttendance'] ?? false;
            latitude=change.doc.data()?['latitude'] ?? 0.0;
            longitude=change.doc.data()?['longitude'] ?? 0.0;
          });
        }
      }
    });
  }
  Future<void> getLocationStatus() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Location permissions are permanently denied, we cannot request permissions.')));
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
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          currentPosition = position;
        });
      }
    }
  }
  Future<void> markAttendance() async {
    getLocationStatus();
    bool validLocation=isWithin10Meters(currentPosition!.latitude,currentPosition!.longitude,latitude!,longitude!);
    QuerySnapshot querySnapshot = await db
        .collection('Student_Attendance')
        .where('USN', isEqualTo: user["USN"])
        .get();
    for (var doc in querySnapshot.docs) {
      DocumentReference documentReference = doc.reference;
      Map<String, dynamic> currentSubjectInfo = doc['AA-Status'];
      currentSubjectInfo['total_classes'] =
          (currentSubjectInfo['total_classes']! + 1);
      currentSubjectInfo['Attended'] = (currentSubjectInfo['Attended']! + 1);
      print(currentSubjectInfo);
      await documentReference.update({'AA-Status': currentSubjectInfo});
    }
    status = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00BCD4), Color(0xFF2196F3)],
          ),
        ),
        child: Column(
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
                  onPressed: () {Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile(user)));},
                )
              ],
            ),
            (status)
                ? Column(
                    children: [
                      Container(
                        height: 50,
                      ),
                      Text(
                        "Sub: $subject",
                        style: TextStyle(fontSize: 30),
                      ),
                      Container(
                        height: 100,
                      ),
                      ElevatedButton(
                        onPressed: () => failedStatus(context),
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(8),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: const Text(
                          'Mark Attendance',
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        Container(height: 50,),
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning,
                                size: 64,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Attendance Marking Unavailable',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Attendance marking is currently unavailable.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void successStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 10),
              Text("Attendity"),
            ],
          ),
          content: Text("Your Attendance Marked successfully."),
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void failedStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // This is the dialog content for failure
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 32), // Error icon
              SizedBox(width: 10),
              Text("Attendity"),
            ],
          ),
          content: const Text("Failed to mark your Attendance, try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }
}
