import 'package:attendece/pages/home.dart';
import 'package:attendece/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class GetAttendanceButton extends StatefulWidget {
  final Map<String, dynamic> user;
  const GetAttendanceButton(this.user, {super.key});

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
  double? latitude = 12.9450;
  double? longitude = 77.5650;
  late int? range = 0;
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
    print("$lat1 $lon1 $lat2 $lon2");
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

  bool isWithinRange(double currentLat, double currentLon, double targetLat,
      double targetLon) {
    double distance =
        calculateDistance(currentLat, currentLon, targetLat, targetLon);
    print(distance);
    return distance <= range!;
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
            print(change.doc.data());
            status = change.doc.data()?['MarkAttendance'] ?? false;
            latitude = change.doc.data()?['latitude'] ?? 0.0;
            longitude = change.doc.data()?['longitude'] ?? 0.0;
            range = change.doc.data()?['Range'] ?? 0.0;
            print('lat-$latitude  long-$longitude range-$range');
          });
        }
        if (change.type == DocumentChangeType.removed) {
          setState(() {
            status = false;
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
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
        setState(() {});
      }
    } else {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print('${position.latitude} ${position.longitude}');
        setState(() {
          currentPosition = position;
        });
      }
    }
  }

  Future<void> markAttendance() async {
    await getLocationStatus();
    bool locationInRange = isWithinRange(currentPosition!.latitude,
        currentPosition!.longitude, latitude!, longitude!);
    print(locationInRange);
    if (locationInRange) {
      QuerySnapshot querySnapshot = await db
          .collection('Student_Attendance')
          .where('USN', isEqualTo: user["USN"])
          .get();
      for (var doc in querySnapshot.docs) {
        DocumentReference documentReference = doc.reference;
        List<dynamic> currentSubjectInfo = doc['subjectAttendance'];
        for (var item in currentSubjectInfo) {
          if (item['subject'] == "AA") {
            item['total'] = (item['total']! + 1);
            item['attended'] = (item['attended']! + 1);
          }
        }
        print(currentSubjectInfo);
        await documentReference
            .update({'subjectAttendance': currentSubjectInfo});
      }
      status = false;
      successStatus(context);
    } else {
      failedStatus(context);
    }
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
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile(user)));
                  },
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
                        onPressed: () => markAttendance(),
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
                        Container(
                          height: 50,
                        ),
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
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 10),
              Text("Attendity"),
            ],
          ),
          content: const Text("Your Attendance Marked successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
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
          content: const Text(
              "Failed to mark your Attendance, because of location mismatch"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
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
