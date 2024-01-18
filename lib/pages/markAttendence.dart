import 'package:attendece/pages/home.dart';
import 'package:flutter/material.dart';

class MarkAttendence extends StatefulWidget {
  const MarkAttendence({super.key});

  @override
  State<MarkAttendence> createState() => _MarkAttendenceState();
}

class _MarkAttendenceState extends State<MarkAttendence> {
  List<Map<String, String>> USNList = [
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
    {'USN': '1BM21CS181'},
  ];
  List<bool> isMarked = List.filled(50, true);
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
                onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));},
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
          Expanded(
            child: ListView.builder(
                itemCount: USNList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(USNList[index]['USN']![0]),
                    ),
                    title: Text(USNList[index]['USN']!),
                    subtitle: Row(
                      children: [
                        const Text('Marked as '),
                        (isMarked[index])
                            ? const Text(
                                'Present',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : const Text("Absent",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)
                      ],
                    ),
                    trailing: Checkbox(
                      value: isMarked[index],
                      onChanged: (bool? value) {
                        setState(() {
                          isMarked[index] = value!;
                        });
                      },
                    ),
                  );
                }),
          ),
          ElevatedButton(onPressed: (){}, child: const Text('Submit Attendance'))
        ],
      ),
    );
  }
}
