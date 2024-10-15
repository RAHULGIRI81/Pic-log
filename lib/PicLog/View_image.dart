import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class FullSizeImageView extends StatelessWidget {
  final String imageUrl;

  const FullSizeImageView({Key? key, required this.imageUrl}) : super(key: key);

  Future<void> downloadImage(BuildContext context, String url) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Storage permission denied")),
        );
        return;
      }

      // Get the Downloads directory
      Directory? dir = await getExternalStorageDirectory();
      String filePath = '${dir!.path}/Download/${url.split('/').last}';
      print("Downloading image from $url to $filePath");

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Downloading...")),
      );

      // Download the image
      await Dio().download(url, filePath);
      print("Download completed");

      // Notify the gallery about the new file
      await Process.run('am', ['broadcast', '-a', 'android.intent.action.MEDIA_SCANNER_SCAN_FILE', '-d', 'file://$filePath']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image downloaded to $filePath")),
      );
    } catch (e) {
      print("Error downloading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error downloading image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full Size Image"),
        backgroundColor: Colors.blue.shade50,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => downloadImage(context, imageUrl),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
