import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PiercingPage extends StatefulWidget {
  @override
  _PiercingPageState createState() => _PiercingPageState();
}

class _PiercingPageState extends State<PiercingPage> {
  bool isGrid = true;
  List<dynamic> categories = [];
  List<dynamic> piercingServices = [];

  @override
  void initState() {
    super.initState();
    fetchPiercingServices();
  }

  Future<void> fetchPiercingServices() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.56:8400/get_piercing_services/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['categories'] != null && data['services'] != null) {
          setState(() {
            categories = data['categories'];
            piercingServices = data['services'];
          });
        } else {
          throw Exception('Missing categories or services data');
        }
      } else {
        throw Exception(
            'Failed to load piercing services. Status: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom AppBar
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 218, 175, 249),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      "Персинг",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(
                        isGrid ? Icons.list : Icons.grid_view,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isGrid = !isGrid;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 8),

          // Piercing Services Grid/List View
          Expanded(
            child: isGrid
                ? GridView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: piercingServices.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      String imageUrl = piercingServices[index]['simage'] !=
                              null
                          ? 'http://192.168.1.56:8400${piercingServices[index]['simage']}'
                          : 'https://via.placeholder.com/150';

                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(imageUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              child: Column(
                                children: [
                                  Text(
                                    piercingServices[index]['sname'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 218, 175, 249)),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '\₮${piercingServices[index]['sprice']}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.green),
                                  ),
                                  Text(
                                    '${piercingServices[index]['sduration']}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: piercingServices.length,
                    itemBuilder: (context, index) {
                      String imageUrl = piercingServices[index]['simage'] !=
                              null
                          ? 'http://192.168.1.56:8400${piercingServices[index]['simage']}'
                          : 'https://via.placeholder.com/180';

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(imageUrl,
                                width: 50, height: 50, fit: BoxFit.cover),
                          ),
                          title: Text(
                            piercingServices[index]['sname'],
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '\₮${piercingServices[index]['sprice']} • ${piercingServices[index]['sduration']} mins',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
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
