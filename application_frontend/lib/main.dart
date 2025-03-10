import 'package:flutter/material.dart';
import 'bottom_bar.dart'; // Import bottom_bar.dart here

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: ''), // Use MyHomePage here
    );
  }
}
