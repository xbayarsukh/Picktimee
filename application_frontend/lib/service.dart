import 'dart:async';
import 'package:flutter/material.dart';

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

  final List<String> serviceImages = [
    'assets/images/lash.jpg',
    'assets/images/manicure.jpg',
    'assets/images/brow.jpg',
    'assets/images/pedicure.jpg',
    'assets/images/skincare.jpg',
    'assets/images/piercing.jpg',
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
              color: Color.fromARGB(255, 60, 11, 91),
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
                          hintText: "Search services...",
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
            margin: EdgeInsets.all(20),
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 60, 11, 91),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(sliderImages[_currentIndex]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: serviceImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print("Image ${index + 1} clicked");
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 60, 11, 91),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(serviceImages[index]),
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
