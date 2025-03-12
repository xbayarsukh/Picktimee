import 'package:flutter/material.dart';

class BrowPage extends StatefulWidget {
  @override
  _BrowPageState createState() => _BrowPageState();
}

class _BrowPageState extends State<BrowPage> {
  bool isGrid = true; // Toggle between grid & list view

  final List<String> categories = [
    "Classic Brow",
    "Volume Brow",
    "Hybrid Brow",
    "Mega Volume Brow",
    "Wispy Brow"
  ];

  final List<Map<String, String>> browItems = [
    {"name": "Classic Brow", "image": "assets/images/1.jpg"},
    {"name": "Volume Brow", "image": "assets/images/2.jpg"},
    {"name": "Hybrid Brow", "image": "assets/images/3.jpg"},
    {"name": "Mega Volume Brow", "image": "assets/images/4.jpg"},
    {"name": "Wispy Brow", "image": "assets/images/5.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom AppBar with background
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 218, 175, 249),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      "Brow Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

          SizedBox(height: 10),

          // Categories list
          SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      backgroundColor: Color.fromARGB(255, 218, 175, 249),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Rounded edges (if needed)
                      ),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 10),

          // Brow items (Grid/List)
          Expanded(
            child: isGrid
                ? GridView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: browItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8, // Aspect ratio adjustment
                    ),
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 80,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  browItems[index]["image"]!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              browItems[index]["name"]!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 218, 175, 249),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: browItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              browItems[index]["image"]!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            browItems[index]["name"]!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Handle navigation or action
                          },
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
