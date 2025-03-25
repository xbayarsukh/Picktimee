import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Branches")),
      body: Center(
        child: Text('List of Locations or Branches'),
      ),
    );
  }
}
