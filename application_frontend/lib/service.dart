import 'dart:async';
import 'package:flutter/material.dart';
import 'category/lash.dart'; // Import LashPage
import 'category/manicure.dart'; // Import ManicurePage
import 'category/brow.dart'; // Import BrowPage
import 'category/pedicure.dart'; // Import PedicurePage
import 'category/skincare.dart'; // Import SkincarePage
import 'category/piercing.dart'; // Import PiercingPage (new import)

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final List<String> sliderImages = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
  ];

  final List<Map<String, String>> services = [
    {"image": 'assets/images/lash.jpg', "name": "Lash"},
    {"image": 'assets/images/manicure.jpg', "name": "Manicure"},
    {"image": 'assets/images/brow.jpg', "name": "Brow"},
    {"image": 'assets/images/pedicure.jpg', "name": "Pedicure"},
    {"image": 'assets/images/skincare.jpg', "name": "Skincare"},
    {
      "image": 'assets/images/piercing.jpg',
      "name": "Piercing"
    }, // Added Piercing
  ];

  int _currentIndex = 0;
  late Timer _timer;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % sliderImages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 218, 175, 249),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 400,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Үйлчилгээ хайх...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(sliderImages[_currentIndex]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (services[index]["name"] == "Lash") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LashPage()),
                      );
                    } else if (services[index]["name"] == "Manicure") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManicurePage()),
                      );
                    } else if (services[index]["name"] == "Brow") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BrowPage()),
                      );
                    } else if (services[index]["name"] == "Pedicure") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PedicurePage()), // Navigate to PedicurePage
                      );
                    } else if (services[index]["name"] == "Skincare") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SkincarePage()), // Navigate to SkincarePage
                      );
                    } else if (services[index]["name"] == "Piercing") {
                      // Added Piercing navigation
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PiercingPage()), // Navigate to PiercingPage
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(services[index]["image"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
