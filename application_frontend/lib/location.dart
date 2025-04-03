import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  final List<Map<String, String>> branches = [
    {
      "name": "Downtown Salon",
      "address": "123 Main St, City Center",
      "image": "assets/images/branch1.jpg",
    },
    {
      "name": "Uptown Beauty",
      "address": "456 High St, Uptown",
      "image": "assets/images/branch2.jpg",
    },
    {
      "name": "Westside Lash Studio",
      "address": "789 Sunset Blvd, Westside",
      "image": "assets/images/branch3.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Curved header
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 218, 175, 249),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Text(
                "Хаяг байрлал",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Branch list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: branches.length,
                itemBuilder: (context, index) {
                  final branch = branches[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          branch["image"]!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        branch["name"]!,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(branch["address"]!),
                      trailing: IconButton(
                        icon: Icon(Icons.map, color: Colors.blue),
                        onPressed: () {
                          // Implement navigation logic here (e.g., open Google Maps)
                          print("Navigate to ${branch['name']}");
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
