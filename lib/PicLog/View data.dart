import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piclogmain/PicLog/Add_data.dart';
import 'package:piclogmain/PicLog/Login.dart';

class User_View_data extends StatefulWidget {
  const User_View_data({super.key});

  @override
  State<User_View_data> createState() => _User_View_dataState();
}

class _User_View_dataState extends State<User_View_data> {
  var location_ctrl = TextEditingController();
  var ocation_ctrl = TextEditingController();
  var Name_ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          title: Text(
            'PIC LOG',
            style: GoogleFonts.dancingScript(
                fontSize: 30, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return User_Login_page();
                },));
              },
                child: CircleAvatar(
                  radius: 20.0,
                  child: Icon(Icons.add_to_photos_outlined), // Replace with your image URL
                ),
              ),
            ),
          ]),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Add_user_detail")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            final Piclog_view = snapshot.data?.docs ?? [];
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: Piclog_view.length,
                    itemBuilder: (context, index) {
                      final doc = Piclog_view[index];
                      final view_piclog_details =
                          doc.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8, right: 10, left: 10),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Wrap(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "Name : ${view_piclog_details["Name"] ?? ""}",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Card(
                                      child: Container(
                                        height: 200,
                                        width: 350,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 3.h,
                                          ),
                                          Wrap(
                                            children: [
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  "Ocation : ${view_piclog_details["Ocation"] ?? ""}",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Wrap(
                                            children: [
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  "Location :${view_piclog_details["Location"] ?? ""}",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Wrap(
                                            children: [
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  "Date :${view_piclog_details["Date"] ?? ""}",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }),
    );
  }
}
