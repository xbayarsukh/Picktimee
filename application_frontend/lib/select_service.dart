import 'package:flutter/material.dart';

class SelectServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: double.infinity, // Full width
          margin: EdgeInsets.all(30), // Margin of 30 on all sides
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 218, 175, 249), // Background color
            borderRadius: BorderRadius.circular(10), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 10, // Blurring effect
                offset: Offset(0, 4), // Moves shadow down
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the content vertically
              children: [
                // Other content or information here
                Spacer(),
                // Row for buttons at the bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Spacing the buttons evenly
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Navigate back to the previous page
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(60, 40), // Set width and height
                        primary:
                            Colors.white, // Set the background color to white
                      ),
                      child: Text('Back',
                          style: TextStyle(
                              color: Color.fromARGB(255, 135, 43, 192))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _selectService(context); // Handle service selection
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(60, 40), // Set width and height
                        primary:
                            Colors.white, // Set the background color to white
                      ),
                      child: Text('Select Service',
                          style: TextStyle(
                              color: Color.fromARGB(255, 135, 43, 192))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectService(BuildContext context) {
    // Logic to handle service selection
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Service Selected'),
        content: Text('You have successfully selected a service!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
