import 'package:attendece/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyAttendance extends StatefulWidget {
  final Map<String, dynamic> userDetail;
  const MyAttendance(this.userDetail, {super.key});
  @override
  _MyAttendanceState createState() => _MyAttendanceState(userDetail);
}

class _MyAttendanceState extends State<MyAttendance> {
  final Map<String, dynamic> user;
  _MyAttendanceState(this.user);
  List<int> totalClasses = [];
  List<int> attendedClasses = [];
  List<String> courses = [];
  List<Map<String,dynamic>> subjectAttendance=[];
  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection('Student_Attendance')
        .where("USN", isEqualTo: user['USN'])
        .get()
        .then((value) => {
      for(var doc in value.docs){
        subjectAttendance.add(doc.data()),
      }
    });
    print(subjectAttendance);
    for(var item in subjectAttendance[0]['subjectAttendance']){
      print(item);
      totalClasses.add(item['total']);
      attendedClasses.add(item['attended']);
      courses.add(item['subject']);
    }
    print(totalClasses);
    print(attendedClasses);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = List.generate(
      totalClasses.length,
      (index) {
        return BarChartGroupData(
          x: index,
          barsSpace: 4,
          barRods: [
            BarChartRodData(
              toY: totalClasses[index].toDouble(),
              color: _getColor(index),
            ),
            BarChartRodData(
              toY: attendedClasses[index].toDouble(),
              color: _getColor(index),
            ),
          ],
        );
      },
    );

    BarChartData myBarData = BarChartData(
      maxY: 50,
      minY: 0,
      barGroups: barGroups,
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: const Color(0xff37434d),
          width: 1,
        ),
      ),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueAccent,
        ),
        handleBuiltInTouches: true,
      ),
    );

    List<PieChartSectionData> pieChartSections = List.generate(
      totalClasses.length,
      (index) {
        double attendedPercentage =
            (attendedClasses[index] / totalClasses[index]) * 100;
        double remainingPercentage = 100 - attendedPercentage;

        return PieChartSectionData(
          color: _getColor(index),
          value: attendedPercentage,
          title: '${attendedClasses[index]}/${totalClasses[index]}',
          radius: 60,
          titleStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        );
      },
    );

    List<Widget> subjectDetailsWidgets = List.generate(
      courses.length,
      (index) {
        double attendedPercentage =
            (attendedClasses[index] / totalClasses[index]) * 100;
        Color textColor = _getPercentageColor(attendedPercentage);

        return ListTile(
          title: Text(
            courses[index],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Total Classes: ${totalClasses[index]}  Attended Classes: ${attendedClasses[index]}\nPercentage: ${attendedPercentage.toStringAsFixed(2)}%',
            style: TextStyle(color: textColor),
          ),
        );
      },
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
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
                SizedBox(
                  height: 450,
                  child: ListView(
                    children: subjectDetailsWidgets,
                  ),
                ),
                Container(
                  height: 10,
                ),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    myBarData,
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: pieChartSections,
                      borderData: FlBorderData(show: false),
                      centerSpaceRadius: 40,
                      sectionsSpace: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(int index) {
    switch (index % 5) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 85) {
      return Colors.green;
    } else if (percentage >= 75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
