import 'package:flutter/material.dart';
import 'service.dart';
import 'profile.dart';
import 'booking.dart'; // Assuming you have a BookingPage widget
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Animated Navigation Bottom Bar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_bottomNavIndex], // Change body based on selected index
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the booking page when FAB is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingPage()),
          );
        },
        child: Icon(
          Icons.calendar_month,
          color: Colors.white, // Set the icon color to white
        ),
        backgroundColor: Color.fromARGB(255, 60, 11, 91),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color =
              isActive ? Color.fromARGB(255, 60, 11, 91) : Colors.grey;
          return Icon(
            iconList[index],
            size: 24,
            color: color,
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
