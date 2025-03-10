import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Service'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // You can handle your booking action here, like making an API call or saving to a database
            _bookService(context);
          },
          child: Text('Book Now'),
        ),
      ),
    );
  }

  // Simplified method for booking confirmation
  void _bookService(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Booking Confirmed'),
        content: Text('Your service has been successfully booked!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to the previous page
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
