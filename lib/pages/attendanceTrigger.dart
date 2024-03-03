import 'package:attendece/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceTrigger extends StatefulWidget {
  const AttendanceTrigger({super.key});
  @override
  State<AttendanceTrigger> createState() => _AttendanceTriggerState();
}

class _AttendanceTriggerState extends State<AttendanceTrigger>
    with TickerProviderStateMixin {
  List<int> seconds = [10, 20, 30, 40, 50, 60];
  late int dropdownValue;
  late AnimationController controller;
  double get progress => controller.value;
  bool isActive = false;
  late bool serviceEnabled;
  late LocationPermission permission;
  Position? currentPosition;
  double? latitude;
  double? longitude;

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
      FirebaseFirestore.instance
          .collection('Attendance_Trigger')
          .add({
        'MarkAttendance': true,
        'Location': {'latitude': latitude, 'longitude': longitude}
      }).then((value) => print(value.id));
      Future.delayed(Duration(seconds: dropdownValue), () {
        FirebaseFirestore.instance
            .collection('Attendance_Trigger')
            .add({'MarkAttendance': false}).then((value) => print(value.id));
        setState(() {});
      });
    }
    FirebaseFirestore.instance.collection("Attendance_Trigger").get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    }).catchError((error) {
      print("Error deleting documents: $error");
    });
  }
  @override
  void initState() {
    dropdownValue = seconds[2];
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
                onPressed: () {},
              )
            ],
          ),
          Container(
            height: 40,
          ),
          const Text(
            "Attendance Trigger",
            style: TextStyle(fontSize: 30),
          ),
          Container(
            height: 20,
          ),
          const Text(
            "set timer in seconds",
            style: TextStyle(fontSize: 20),
          ),
          Container(
            height: 10,
          ),
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
          Container(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () => attendanceTrigger(),
              child: const Text(
                'Trigger',
                style: TextStyle(fontSize: 20),
              )),
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
                    'Press Trigger to allow students to mark Attendance',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
        ],
      ),
    );
  }
}
