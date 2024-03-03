import 'package:attendece/pages/passwordVerify.dart';
import 'package:attendece/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:attendece/pages/home.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool invalidNotifier = false;
  bool visible = true;
  var icon = Icons.visibility_off;
  Future<void> handleLogin() async {
    String e = email.text.trim();
    String p = password.text.trim();
    print('$e $p');
    if (e == "" || p == "") {
      print("fill all fields");
    } else {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: e, password: p);
        print('success');
        _completeLogin();
      } catch (er) {
        print('error login $er');
        invalidNotifier = true;
        setState(() {});
      }
    }
  }

  void _completeLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => const Home()),
          (Route<dynamic> route) => false,
    );
  }
  Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: (invalidNotifier)
                  ? const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Invalid Email or Password',
                          style: TextStyle(color: Colors.red),
                        ),
                      ))
                  : null,
            ),
            const Text(
              "Attendity",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  "assets/Images/logo.png",
                  fit: BoxFit.cover,
                )),
            Container(
              height: 10,
            ),
            const Text(
              "LOGIN TO YOUR ACCOUNT",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Container(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                    labelText: "Your BMSCE Email ID",
                    filled: true,
                    fillColor: Colors.black12,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                controller: password,
                obscureText: visible,
                decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(icon),
                      onPressed: () {
                        if (visible == true) {
                          visible = false;
                          icon = Icons.visibility;
                        } else {
                          visible = true;
                          icon = Icons.visibility_off;
                        }
                        setState(() {});
                      },
                    ),
                    fillColor: Colors.black12,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1))),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero, // Set this
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PasswordVerify()));
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                )),
            ElevatedButton(
                onPressed: () => handleLogin(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text(
                  'LOG IN',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                )),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text(
                  "New User? Sign Up",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
