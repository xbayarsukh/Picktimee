import 'package:flutter/material.dart';
import 'service.dart';
import 'profile.dart';
import 'booking.dart';
import 'history.dart'; // Import the history page
import 'location.dart'; // Import the location page
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home,
    Icons.history,
    Icons.location_on,
    Icons.account_circle,
  ];

  final List<Widget> _pages = [
    ServicePage(),
    HistoryPage(), // Add the history page to the list
    LocationPage(),
    ProfilePage(), // Add the location page to the list
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingPage()),
          );
        },
        child: Icon(Icons.calendar_month, color: Colors.white),
        backgroundColor: Color(0xFF872BC0), // Purple color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Color(0xFF872BC0) : Colors.white;
          return Icon(iconList[index], size: 24, color: color);
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        backgroundColor: Color(0xFFDAAFFF), // Purple bottom bar color
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
