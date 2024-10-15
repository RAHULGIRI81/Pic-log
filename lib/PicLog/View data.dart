import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piclogmain/PicLog/Add_data.dart';

import 'View_image.dart';// Import the new page

class User_View_data extends StatefulWidget {
  const User_View_data({super.key});

  @override
  State<User_View_data> createState() => _User_View_dataState();
}

class _User_View_dataState extends State<User_View_data> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        automaticallyImplyLeading: false,
        title: Text(
          'PIC LOG',
          style: GoogleFonts.dancingScript(
              fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return User_Add_Data();
                }));
              },
              child: CircleAvatar(
                radius: 20.0,
                child: Icon(Icons.add_to_photos_outlined),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Add_user_detail")
            .orderBy("Date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final piclogView = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: piclogView.length,
            itemBuilder: (context, index) {
              final doc = piclogView[index];
              final viewPiclogDetails = doc.data() as Map<String, dynamic>;
              return buildPiclogCard(viewPiclogDetails);
            },
          );
        },
      ),
    );
  }

  Widget buildPiclogCard(Map<String, dynamic> viewPiclogDetails) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: ${viewPiclogDetails["Name"] ?? ""}",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FullSizeImageView(imageUrl: viewPiclogDetails["url"]);
                  }));
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(viewPiclogDetails["url"]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              buildDetailText("Ocation: ${viewPiclogDetails["Ocation"] ?? ""}"),
              buildDetailText("Location: ${viewPiclogDetails["Location"] ?? ""}"),
              buildDetailText("Date: ${viewPiclogDetails["Date"] ?? ""}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
