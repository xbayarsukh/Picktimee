import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'select_service.dart'; // Import the SelectServicePage (where the user selects the service)
import 'login.dart'; // Import the LoginPage for redirect when not logged in

class BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: double.infinity,
          margin: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 218, 175, 249),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Цаг захиалах хэсэгт тавтай морил',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 135, 43, 192),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Захиалсан цагаа өөрчлөх шаардлагатай бол урьдчилан мэдэгдэнэ үү. Хэрэв таны хүссэн цаг идэвхгүй буюу бүх цаг дууссан бол боломжтой цагийг сонгох. Тухайн үйлчилгээний талаар урьдчилан мэдээлэл авах. Захиалсан цагийнхаа хугацааг алдахгүйгээр ирэх, эсвэл 3-4 цагийн өмнө мэдэгдэх, хожимдвол захиалсан цаг хүчингүй болохыг анхаарна уу.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? accessToken = prefs.getString('access_token');

                        // Check if the access token is present, meaning the user is logged in
                        if (accessToken != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectServicePage()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage()), // Redirect to login page if not logged in
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(60, 40),
                        primary: Colors.white,
                      ),
                      child: Text(
                        'Book Now',
                        style:
                            TextStyle(color: Color.fromARGB(255, 135, 43, 192)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the page
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(20, 40),
                        primary: Colors.white,
                      ),
                      child: Text(
                        'Cancel',
                        style:
                            TextStyle(color: Color.fromARGB(255, 135, 43, 192)),
                      ),
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
}
