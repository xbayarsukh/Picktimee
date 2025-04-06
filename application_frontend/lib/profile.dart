import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login.dart'; // Import LoginPage
import 'edit_profile.dart';

class ProfilePage extends StatelessWidget {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // This function will log the user out
  Future<void> _logout(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Retrieve refresh token from secure storage
    String? refreshToken = await storage.read(key: 'refresh_token');
    print(
        'Reading Refresh Token: $refreshToken'); // Log the token to check its value

    if (refreshToken == null) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No refresh token found')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/logout/'), // Your logout API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $refreshToken', // Send token in the Authorization header
        },
      );

      Navigator.pop(context); // Close loading dialog

      if (response.statusCode == 200) {
        // Successfully logged out
        await storage.delete(
            key: 'refresh_token'); // Delete refresh token from secure storage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        final responseBody = json.decode(response.body);
        String errorMessage = responseBody['error'] ?? 'Error logging out';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: ${e.toString()}')),
      );
    }
  }

  // Function to store the refresh token during login
  Future<void> _storeRefreshToken(String refreshToken) async {
    await storage.write(key: 'refresh_token', value: refreshToken);
    print(
        'Stored Refresh Token: $refreshToken'); // Log the stored token to verify
  }

  // The widget build function
  @override
  Widget build(BuildContext context) {
    // Replace with actual dynamic user data
    String userName = "John Doe";
    String userEmail = "johndoe@gmail.com";

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 218, 175, 249),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/1.jpg'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    userName, // Replace with dynamic user data
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    userEmail, // Replace with dynamic email data
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          _buildProfileOption(
            context,
            icon: Icons.person,
            text: "Edit Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.settings,
            text: "Settings",
            onTap: () {
              // Handle Settings action
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.logout,
            text: "Logout",
            onTap: () {
              _logout(context); // Call logout function when tapped
            },
          ),
        ],
      ),
    );
  }

  // Helper function to create profile options (like Edit Profile, Settings, etc.)
  Widget _buildProfileOption(BuildContext context,
      {required IconData icon,
      required String text,
      required Function() onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Color.fromARGB(255, 218, 175, 249)),
              SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(
                  color: Color.fromARGB(255, 218, 175, 249),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
