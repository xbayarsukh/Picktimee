import 'dart:convert';
import 'package:application_frontend/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';
import 'history.dart';

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

  Future<void> _loadUserInfo() async {
    try {
      String? name = await storage.read(key: 'user_name');
      String? email = await storage.read(key: 'user_email');

      if (name != null && email != null) {
        setState(() {
          userName = name;
          userEmail = email;
        });
      } else {
        String? accessToken = await storage.read(key: 'access_token');
        if (accessToken != null) {
          final response = await http.get(
            Uri.parse('http://192.168.1.56:8400/profile/'),
            headers: {'Authorization': 'Bearer $accessToken'},
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            setState(() {
              userName = data['name'] ?? 'Unknown';
              userEmail = data['email'] ?? 'Unknown';
            });

            await storage.write(key: 'user_name', value: userName);
            await storage.write(key: 'user_email', value: userEmail);
          }
        }
      }
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken != null) {
      final url =
          Uri.parse('http://192.168.1.56:8400/logout/'); // Update if needed

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Амжилттай гарлаа!"),
            backgroundColor: Colors.green, // Custom background color
            duration: Duration(seconds: 2), // Custom duration
            action: SnackBarAction(
              label: '', // Action label
              onPressed: () {
                // Action callback, for example, undo login attempt
              },
            ),
          ),
        );

        // Navigate to bottom page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Гарахад алдаа гарлаа!"),
            backgroundColor: Colors.red, // Custom background color
            duration: Duration(seconds: 2), // Custom duration
            action: SnackBarAction(
              label: '', // Action label
              onPressed: () {
                // Action callback, for example, undo login attempt
              },
            ),
          ),
        );
      }
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
            text: "Мэдээлэл засах",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.history,
            text: "Хэрэглэгчийн түүх",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.settings,
            text: "Тохиргоо",
            onTap: () {
              // Future settings implementation
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.logout,
            text: "Гарах",
            onTap: () {
              logout(context);
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
