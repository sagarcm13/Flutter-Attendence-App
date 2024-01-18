import 'package:attendece/pages/addSubjectClass.dart';
import 'package:flutter/material.dart';

class SignUp2 extends StatefulWidget {

  @override
  State<SignUp2> createState() => _SignUp2State();
}
class _SignUp2State extends State<SignUp2> {
  String selectedOption = 'Student';
  List<String> setText=[];
  @override
  void initState() {
    super.initState();
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
                      });
                    },
                  ),
                ],
              ),
            ),
            (selectedOption=="Student")?StudentSignUp():FacultySignUp(),
            Container(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if(selectedOption=='Student'){

                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddSubjectClass()));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: (selectedOption=="Student")? const Text(
                  'SUBMIT',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ):const Text("Save and Continue",style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700),),)
          ],
        ),
      ),
    );
  }
}
class FacultySignUp extends StatelessWidget{
  String employeeText="Enter your Employee ID";
  String phoneText="Enter your phone number";
  String courseText="Enter Course";
  String codeText="Enter 6 digit code sent to your email";
  String subjectText="Enter subject you handle";
  TextEditingController employee = TextEditingController();
  TextEditingController course = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController code = TextEditingController();
  Widget build(BuildContext context){
    return Column(
      children: [
        InputField(employeeText,employee),
        InputField(phoneText,phone),
        InputField(courseText,course),
        InputField(codeText, code)
      ],
    );
  }
}
class StudentSignUp extends StatelessWidget{
  TextEditingController USN = TextEditingController();
  TextEditingController course = TextEditingController();
  TextEditingController sem = TextEditingController();
  TextEditingController section = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController code = TextEditingController();
  String USNText="Your USN number";
  String courseText="Enter Course";
  String semText="Enter Semester";
  String sectionText="Enter Section";
  String phoneText="Enter Phone number";
  String codeText="Enter 6 digit code sent to your email";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(USNText,USN),
        InputField(courseText,course),
        InputField(semText,sem),
        InputField(sectionText,section),
        InputField(phoneText,phone),
        InputField(codeText,code),
      ],
    );
  }

}
class InputField extends StatelessWidget{
  TextEditingController input=TextEditingController();
  String setText;
  InputField(this.setText,this.input, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        controller: input,
        obscureText: true,
        decoration: InputDecoration(
            labelText: setText,
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
    );
  }

}