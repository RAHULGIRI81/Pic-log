import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:piclogmain/PicLog/Login.dart';
import 'package:piclogmain/PicLog/View data.dart';
import 'package:piclogmain/main.dart';

class User_Add_Data extends StatefulWidget {
  const User_Add_Data({super.key});

  @override
  State<User_Add_Data> createState() => _page_2State();
}

class _page_2State extends State<User_Add_Data> {
  var location_ctrl = TextEditingController();
  var ocation_ctrl = TextEditingController();

  String formattedDate =
      DateFormat('dd-MM-yyyy - kk:mm').format(DateTime.now());

  Future<void> user_detail() async {
    FirebaseFirestore.instance.collection('Add_user_detail').add({
      'Location': location_ctrl.text,
      "Ocation": ocation_ctrl.text,
      'Date': formattedDate,
    });
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return User_View_data();
      },
    ));
  }

  File? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {

    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);


    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
      _uploadImage();
    });
  }

  final formkey = GlobalKey<FormState>();


Future<void> _uploadImage() async {
  if (_image == null) return;
  try {
    await _storage.ref('uploads/${DateTime.now().toString()}.jpg').putFile(_image!);
    print('Upload complete');
  } catch (e) {
    print('Error: $e');
  }}


  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20,top: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Image(image: AssetImage('assets/User.jpg')),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Row(
                      children: [
                        Text("Hi ",style: GoogleFonts.dancingScript(fontSize: 30,fontWeight: FontWeight.bold),),
                        Text("User",style: GoogleFonts.dancingScript(fontSize: 30,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.waving_hand,
                      color: Colors.yellow.shade700,
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20.h),
                    Container(
                      width: 350.w,
                      height: 350.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.black),
                      ),
                      child:
                          _image == null
                              ? Center(child: Text('Click the Moment'))
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () => _pickImage(),
                  child: Container(
                    height: 50.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.blue.shade900),
                    child: Center(
                        child: Row(
                      children: [
                        Text(
                          '  Click the Moment',
                          style: GoogleFonts.abrilFatface(
                              color: Colors.white, fontSize: 20.sp),
                        ),
                        Icon(
                          Icons.camera,
                          color: Colors.white,
                        )
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Text(
                      'Enter the Location',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    controller: location_ctrl,
                    decoration: InputDecoration(
                      labelText: "Location",
                      hintText: "Enter your Location",
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(0)),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Location'; // Error message if empty
                      }
                      return null; // Return null if valid
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      'Enter the Occasion',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    controller: ocation_ctrl,
                    decoration: InputDecoration(
                      labelText: "Occasion",
                        hintText: "Enter your Occasion",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(0)),
                        fillColor: Colors.grey.shade200,
                        filled: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Occasion'; // Error message if empty
                      }
                      return null; // Return null if valid
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                InkWell(
                  onTap: () {
                    if (formkey.currentState!.validate()) {
                      user_detail();
                    }
                  },
                  child: Container(
                    height: 50.h,
                    width: 400.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.red.shade900),
                    child: Center(
                        child: Text(
                      'Add your Memmory',
                      style: GoogleFonts.abrilFatface(
                          color: Colors.white, fontSize: 20),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
