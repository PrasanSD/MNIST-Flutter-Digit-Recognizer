import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mnist_flutter/dl_model/classifier.dart';
import 'package:mnist_flutter/utils/constants.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final picker = ImagePicker();
  Classifier classifier = Classifier();
  PickedFile image;
  int digit = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.camera_alt_outlined),
        onPressed: () async {
          image = await picker.getImage(
            source: ImageSource.gallery,
            maxHeight: 300,
            maxWidth: 300,
            imageQuality: 100,
          );
          digit = await classifier.classifyImage(image);
          setState(() {});
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Digit recognizer"),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "Image shown below",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: canvasSize + borderSize * 2,
              height: canvasSize + borderSize * 2,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: borderSize),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: digit == -1
                      ? AssetImage('assets/white_background.jpg')
                      : FileImage(File(image.path)),
                ),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Text("Current Prediction:",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            Text(digit == -1 ? "" : "$digit",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
