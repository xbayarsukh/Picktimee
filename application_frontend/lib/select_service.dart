import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectServicePage extends StatefulWidget {
  @override
  _SelectServicePageState createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  String? selectedArtist;
  String? selectedService;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> artists = ["Artist 1", "Artist 2", "Artist 3"];
  final List<String> services = ["Service 1", "Service 2", "Service 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Artist"),
                value: selectedArtist,
                items: artists
                    .map((artist) => DropdownMenuItem(
                          value: artist,
                          child: Text(artist),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedArtist = value;
                  });
                },
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Service"),
                value: selectedService,
                items: services
                    .map((service) => DropdownMenuItem(
                          value: service,
                          child: Text(service),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedService = value;
                  });
                },
              ),
              SizedBox(height: 15),
              ListTile(
                title: Text(selectedDate == null
                    ? "Select Date"
                    : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(selectedTime == null
                    ? "Select Time"
                    : selectedTime!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Back"),
                  ),
                  ElevatedButton(
                    onPressed: _confirmSelection,
                    child: Text("Confirm"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmSelection() {
    if (selectedArtist != null &&
        selectedService != null &&
        selectedDate != null &&
        selectedTime != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Confirmation"),
          content: Text(
              "Artist: $selectedArtist\nService: $selectedService\nDate: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}\nTime: ${selectedTime!.format(context)}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
    }
  }
}
