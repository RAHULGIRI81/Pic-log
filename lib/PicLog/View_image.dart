import 'package:flutter/material.dart';

class FullSizeImageView extends StatelessWidget {
  final String imageUrl;

  const FullSizeImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full Size Image"),
        backgroundColor: Colors.blue.shade50,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: InteractiveViewer(
        boundaryMargin: EdgeInsets.all(0), // Allow zooming beyond the edges
        minScale: 0.1, // Minimum zoom level
        maxScale: 4.0, // Maximum zoom level
        child: Image.network(
          imageUrl, // Fills the entire area
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
