import 'package:attendece/pages/attendanceStatus.dart';
import 'package:attendece/pages/facultyDetails.dart';
import 'package:attendece/pages/home.dart';
import 'package:attendece/pages/login.dart';
import 'package:attendece/pages/markAttendence.dart';
import 'package:attendece/pages/passwordVerify.dart';
import 'package:attendece/pages/signup.dart';
import 'package:attendece/pages/studentsDetails.dart';
import 'package:attendece/pages/splashScreen.dart';
import 'package:attendece/pages/todayClasses.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: PasswordVerify() //(FirebaseAuth.instance.currentUser!=null)?Home():SplashScreen()
        );
  }
}
