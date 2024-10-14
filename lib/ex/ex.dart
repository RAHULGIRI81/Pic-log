import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  var Name_ctrl = TextEditingController();

  Future<void> Mechanic_signup() async {
    FirebaseFirestore.instance.collection("Mechanic_signup_details").add({
      "Name": Name_ctrl.text,
    });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(mainAxisAlignment:MainAxisAlignment.center,children: [

      TextFormField(controller: Name_ctrl,),
      InkWell(
        onTap: () {
          Mechanic_signup();

        },
        child: Container(
          height: 50,
          width: 220,
          decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
                'SIGN UP',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
        ),
      ),
    ],),);
  }
}
