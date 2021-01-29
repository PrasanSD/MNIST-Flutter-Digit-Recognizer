import 'package:flutter/material.dart';
import 'package:mnist_flutter/pages/drawing_page.dart';
import 'package:mnist_flutter/pages/upload_page.dart';
import 'package:mnist_flutter/utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List tabs = [
      UploadPage(),
      DrawPage(),
    ];
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        iconSize: iconSize,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey[400],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: "Image"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bubble_chart), label: "Draw"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
