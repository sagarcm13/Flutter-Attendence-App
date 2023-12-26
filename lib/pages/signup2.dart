import 'package:flutter/material.dart';

class SignUp2 extends StatefulWidget {

  @override
  State<SignUp2> createState() => _SignUp2State();
}
class StudentType{
  String USNText="Your USN number";
  String semText="Enter Semester";
  String sectionText="Enter Section";
  String codeText="Enter 6 digit code sent to your email";
}
class FacultyType{
  String phoneText="Enter your phone number";
  String classText="Enter classes you handle";
  String subjectText="Enter subject you handle";
  String codeText="Enter 6 digit code sent to your email";
}
class _SignUp2State extends State<SignUp2> {
  TextEditingController input1 = TextEditingController();
  TextEditingController input2 = TextEditingController();
  TextEditingController input3 = TextEditingController();
  TextEditingController input4 = TextEditingController();
  String selectedOption = 'Student';
  List<String> setText=[];
  @override
  void initState() {
    super.initState();
    setVariables();
  }
  void setVariables(){
    if(selectedOption=='Student'){
      StudentType s=StudentType();
      setText.clear();
      setText.add(s.USNText);
      setText.add(s.semText);
      setText.add(s.sectionText);
      setText.add(s.codeText);
    }else{
      FacultyType s=FacultyType();
      setText.clear();
      setText.add(s.classText);
      setText.add(s.subjectText);
      setText.add(s.phoneText);
      setText.add(s.codeText);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 40,
            ),
            const Text(
              "Attendity",
              style: TextStyle(fontSize: 25),
            ),
            Container(height: 10,),
            const Align(
              alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Sign Up as",style: TextStyle(fontSize: 20),),
                )
            ),
            Container(height: 10,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Student'),
                    value: 'Student',
                    groupValue: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                        setVariables();
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Faculty'),
                    value: 'Faculty',
                    groupValue: selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedOption = value!;
                        setVariables();
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                controller: input1,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: setText[0],
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
                controller: input2,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: setText[1],
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
                controller: input3,
                obscureText: true,
                decoration: InputDecoration(
                    labelText:setText[2],
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
                controller: input4,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: setText[3],
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
            Container(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                )),
          ],
        ),
      ),
    );
  }
}