import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piclogmain/PicLog/Login.dart';

class User_sign_up extends StatefulWidget {
  const User_sign_up({super.key});

  @override
  State<User_sign_up> createState() => _User_sign_upState();
}

class _User_sign_upState extends State<User_sign_up> {
  var Name_ctrl = TextEditingController();
  var Phone_ctrl = TextEditingController();
  var Email_ctrl = TextEditingController();
  var Password_ctrl = TextEditingController();

  Future<void> User_signup() async {
    FirebaseFirestore.instance.collection("Piclog_signup_details").add({
      "Name": Name_ctrl.text,
      "Number": Phone_ctrl.text,
      "Email": Email_ctrl.text,
      "Password": Password_ctrl.text,
      "State": 0,
    });
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return User_Login_page();
      },
    ));
  }

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/camarabg.png"),
                height: 200.h,
                width: 200.w,
              ),
              Text(
                'Create PicLog Account',
                style: GoogleFonts.podkova(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'User Name',
                    style: GoogleFonts.podkova(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
        
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Phone no',
                    style: GoogleFonts.podkova(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ), // Add some space between fields
              TextFormField(
                controller: Phone_ctrl,
                decoration: InputDecoration(
                  labelText: 'Enter your phone number',
                  hintText: '123-456-7890',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    TextInputType.phone, // Set keyboard type for phone input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number'; // Error message if empty
                  }
                  // Simple phone number validation (10 digits)
                  const pattern = r'^\d{3}-\d{3}-\d{4}$';
                  final regExp = RegExp(pattern);
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter a valid phone number (e.g., 123-456-7890)'; // Error message if invalid
                  }
                  return null; // Return null if valid
                },
              ),
        
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Email',
                    style: GoogleFonts.podkova(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
        
              TextFormField(
                controller: Email_ctrl,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  hintText: 'example@example.com',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Simple email validation
                  const pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  final regExp = RegExp(pattern);
                  if (!regExp.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Password',
                    style: GoogleFonts.podkova(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ), // Add some space between fields
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
                        _obscurePassword =
                            !_obscurePassword; // Toggle password visibility
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
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: InkWell(
                      onTap: () {
                        User_signup();
                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: Center(
                            child: Text(
                          'Submit',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
