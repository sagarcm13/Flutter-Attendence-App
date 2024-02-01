import 'package:attendece/pages/signup2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  bool visible = true;
  var icon = Icons.visibility_off;
  bool invalid=false;
  String invalidNotifier = "";

  Future<void> createNewUser() async{
    if(password.text.trim()!=cpassword.text.trim()){
      invalid=true;
      invalidNotifier="password and confirm password are not same";
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        invalid=true;
        print('The password provided is too weak.');
        invalidNotifier='The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        invalid=true;
        print('The account already exists for that email.');
        invalidNotifier='The account already exists for that email.';
      }
    } catch (e) {
      invalid=true;
      invalidNotifier='Something went wrong $e';
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              child: (invalid)
                  ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(invalidNotifier,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ))
                  : null,
            ),
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
                obscureText: visible,
                decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.black12,
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
                obscureText: visible,
                decoration: InputDecoration(
                    labelText: "Confirm Password",
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
            Container(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  createNewUser();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp2()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
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
