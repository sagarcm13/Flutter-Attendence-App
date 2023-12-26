import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
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
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,vertical: 0
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap,minimumSize: Size.zero, // Set this
                      padding: EdgeInsets.zero,),
                    onPressed: () {
                      print('hi');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          fontSize: 10,fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ),
                )),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text(
                  'LOG IN',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                )),
            Center(
              child: TextButton(
                onPressed: (){},
                style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text("New User? Sign Up",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500, color: Colors.black),),
              ),
            )
          ],
        ),
      ),
    );
  }
}