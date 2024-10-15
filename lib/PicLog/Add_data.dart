import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:piclogmain/PicLog/View data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User_Add_Data extends StatefulWidget {
  const User_Add_Data({super.key});

  @override
  State<User_Add_Data> createState() => _page_2State();
}

class _page_2State extends State<User_Add_Data> {
  var id;
  DocumentSnapshot? Profile;
  File? _image;
  bool isloading = false;
  final location_ctrl = TextEditingController();
  final ocation_ctrl = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final formkey = GlobalKey<FormState>();
  String formattedDate = DateFormat('dd-MM-yyyy - kk:mm').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    Get_data_sp();
  }

  Future<void> Get_data_sp() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    setState(() {
      id = data.getString("id");
    });
  }

  Future<void> Getbyid() async {
    Profile = await FirebaseFirestore.instance
        .collection("Piclog_signup_details")
        .doc(id)
        .get();
  }

  Future<void> _pickImage() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Image Source'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                _handleImageSelection(pickedFile);
              },
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                _handleImageSelection(pickedFile);
              },
              child: Text('Gallery'),
            ),
          ],
        );
      },
    );
  }

  void _handleImageSelection(XFile? pickedFile) {
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    setState(() {
      isloading = true;
    });
    try {
      if (_image != null) {
        final ref = _storage.ref().child('user_images').child(DateTime.now().millisecondsSinceEpoch.toString());
        await ref.putFile(_image!);
        final imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('Add_user_detail').add({
          'Location': location_ctrl.text,
          "Ocation": ocation_ctrl.text,
          'Date': formattedDate,
          "url": imageUrl,
          "Name": Profile!["Name"],
        });

        setState(() {
          isloading = false;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo updated successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No image selected')));
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error updating profile')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: FutureBuilder(
        future: Getbyid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: Colors.blue);
          }
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Image(image: AssetImage('assets/User.jpg')),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          Profile!["Name"],
                          style: GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.waving_hand, color: Colors.yellow.shade700)
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: 350.w,
                      height: 350.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.black),
                      ),
                      child: _image == null
                          ? Center(child: Text('Click the Moment'))
                          : Image.file(_image!, fit: BoxFit.cover),
                    ),
                    SizedBox(height: 10.h),
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        height: 50.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.blue.shade900,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '  Click the Moment',
                                style: GoogleFonts.abrilFatface(color: Colors.white, fontSize: 20.sp),
                              ),
                              Icon(Icons.camera, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text('Enter the Location', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: location_ctrl,
                        decoration: InputDecoration(
                          labelText: "Location",
                          hintText: "Enter your Location",
                          border: OutlineInputBorder(borderSide: BorderSide.none),
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
                    Text('Enter the Occasion', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: ocation_ctrl,
                        decoration: InputDecoration(
                          labelText: "Occasion",
                          hintText: "Enter your Occasion",
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                        ),
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
                          _uploadImage();
                        }
                      },
                      child: Container(
                        height: 50.h,
                        width: 400.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.red.shade900,
                        ),
                        child: Center(
                          child: isloading
                              ? CircularProgressIndicator()
                              : Text('Submit', style: GoogleFonts.abrilFatface(color: Colors.white, fontSize: 20)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
