import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // Load user info from storage or fetch from API
  Future<void> _loadUserInfo() async {
    try {
      // Example: Reading from storage
      String? name = await storage.read(key: 'user_name');
      String? email = await storage.read(key: 'user_email');

      if (name != null && email != null) {
        setState(() {
          userName = name;
          userEmail = email;
        });
      } else {
        // Optional: fetch from API
        String? accessToken = await storage.read(key: 'access_token');
        if (accessToken != null) {
          final response = await http.get(
            Uri.parse('https://picktimee.onrender.com/profile/'), // your user API
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            setState(() {
              userName = data['name'] ?? 'Unknown';
              userEmail = data['email'] ?? 'Unknown';
            });

            // Optionally store
            await storage.write(key: 'user_name', value: userName);
            await storage.write(key: 'user_email', value: userEmail);
          }
        }
      }
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Get the refresh token from storage
      String? refreshToken = await storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No refresh token found')),
        );
        return;
      }

      // Send logout request with refresh token
      final response = await http.post(
        Uri.parse('https://picktimee.onrender.com/logout/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refresh': refreshToken,
        }),
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        // Clear all stored data
        await storage.deleteAll();
        
        // Navigate to login page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, // This removes all previous routes
        );
      } else {
        final responseBody = json.decode(response.body);
        String errorMessage = responseBody['error'] ?? 'Error logging out';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color.fromARGB(255, 218, 175, 249),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    userName.isNotEmpty ? userName : 'Loading...',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    userEmail.isNotEmpty ? userEmail : '',
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
              // Implement settings page
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.logout,
            text: "Logout",
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

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
