import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordVerify extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PasswordVerify();
}

class _PasswordVerify extends State<PasswordVerify> {
  TextEditingController email = TextEditingController();
  bool notifier = false;
  String msg = "Reset link sent to your email";
  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim());
      notifier = true;
      msg = 'Reset link sent to your email';
    } catch (e) {
      notifier = true;
      msg = 'User not found';
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              height: 80,
              child: Center(
                child: (notifier)
                    ? Text(
                        msg,
                        style: const TextStyle(fontSize: 20, color: Colors.red),
                      )
                    : null,
              )),
          Container(
            height: 40,
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
            "Enter your email to reset your password",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          Container(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          ElevatedButton(
              onPressed: () => resetPassword(), child: const Text("Reset"))
        ],
      ),
    );
  }
}
