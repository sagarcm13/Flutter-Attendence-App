import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: 20,
            // ),
            Text(
              "Attendity",
              style: TextStyle(fontSize: 20),
            ),
            Image.asset("assets/Images/logo.png"),
            Container(
              height: 10,
            ),
            Text(
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
                    labelText: "Enter BMSCE Email ID",
                    filled: true,
                    fillColor: Colors.black12,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        // borderSide:
                        //     const BorderSide(color: Colors.black, width: 2)
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Enter Password",
                    filled: true,
                    fillColor: Colors.black12,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        const BorderSide(color: Colors.black, width: 2)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      // borderSide:
                      //     const BorderSide(color: Colors.black, width: 2)
                    )
                ),
              ),
            ),
            Align(alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                  child: Text('forgot password?',style: TextStyle(fontWeight: FontWeight.w300,color: Colors.blue),),
                )),
            ElevatedButton(onPressed: (){}, child: Text('Login',style: TextStyle(color: Colors.white,),))

          ],
        ),
      ),
    );
  }
}
