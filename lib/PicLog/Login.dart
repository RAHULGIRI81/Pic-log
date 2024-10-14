import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piclogmain/PicLog/Add_data.dart';
import 'package:piclogmain/PicLog/Signup.dart';
import 'package:piclogmain/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User_Login_page extends StatefulWidget {
  const User_Login_page({super.key});

  @override
  State<User_Login_page> createState() => _User_Login_pageState();
}

class _User_Login_pageState extends State<User_Login_page> {
  var Name_ctrl = TextEditingController();
  var Password_ctrl = TextEditingController();


  String id = "";

  void Login() async {
    final user = await FirebaseFirestore.instance
        .collection('Piclog_signup_details')
        .where('Name', isEqualTo: Name_ctrl.text)
        .where('Password', isEqualTo: Password_ctrl.text)
        .get();
    if (user.docs.isNotEmpty) {
      id = user.docs[0].id;

      SharedPreferences data = await SharedPreferences.getInstance();
      data.setString('id', id);

      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return User_Add_Data();
        },
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Email And Password Error",
            style: TextStyle(color: Colors.red),
          )));
    }
  }


  final formkey = GlobalKey<FormState>();
  bool _obscurePassword = true;


  @override
  Widget build(BuildContext context) {
    return Form(key: formkey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/camarabg.png"),
                height: 200.h,
                width: 200.w,
              ),
              Text('PIC LOG',
              style: GoogleFonts.dancingScript(
              fontSize: 30, fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'User Name',
                            style: GoogleFonts.podkova(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        controller: Name_ctrl,
                        decoration: InputDecoration(
                          labelText: 'Enter your name',
                          hintText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name'; // Error message if empty
                          }
                          return null; // Return null if valid
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Password',
                            style: GoogleFonts.podkova(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        controller: Password_ctrl,
                        decoration: InputDecoration(
                          labelText: 'Enter your password',
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword; // Toggle password visibility
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword, // Use the state variable
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password'; // Error message if empty
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long'; // Error message if too short
                          }
                          return null; // Return null if valid
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Get capture your \n favrote momments',
                style: GoogleFonts.podkova(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Login();
                },
                child: Container(
                  height: 70.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.blue),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 30.sp),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Do you have account ?",
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return User_sign_up();
                      },));
                    },
                    child: Text(
                      " Sign up",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
