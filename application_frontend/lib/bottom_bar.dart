import 'package:flutter/material.dart';
import 'service.dart';
import 'profile.dart';
import 'booking.dart';
import 'login.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home,
    Icons.account_circle,
  ];

  final List<Widget> _pages = [
    ServicePage(),
    ProfilePage(),
    LoginPage(),
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
