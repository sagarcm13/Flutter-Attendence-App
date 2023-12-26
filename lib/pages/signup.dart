import 'package:attendece/pages/signup2.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget{
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController cpassword=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 80,
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
              "SIGN UP TO CREATE NEW ACCOUNT",
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
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
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
                controller: cpassword,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Confirm Password",
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
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp2()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                )),
          ],
        ),
      ),
    );
  }
  
}