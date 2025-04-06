import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SelectServicePage extends StatefulWidget {
  @override
  _SelectServicePageState createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  String? selectedBranch;
  String? selectedWorker;
  String? selectedService;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List<Map<String, dynamic>> branches = [];
  List<Map<String, dynamic>> workers = [];
  List<Map<String, dynamic>> services = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse("http://127.0.0.1:8000/book/"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          branches = List<Map<String, dynamic>>.from(data["branches"]);
          workers = List<Map<String, dynamic>>.from(data["workers"]);
          services = List<Map<String, dynamic>>.from(data["services"]);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
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
                      decoration: InputDecoration(labelText: "Select Branch"),
                      value: selectedBranch,
                      items: branches
                          .map((branch) => DropdownMenuItem(
                                value: branch["id"].toString(),
                                child: Text(branch["name"]),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBranch = value;
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Select Worker"),
                      value: selectedWorker,
                      items: workers
                          .map((worker) => DropdownMenuItem(
                                value: worker["id"].toString(),
                                child: Text(worker["name"]),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedWorker = value;
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Select Service"),
                      value: selectedService,
                      items: services
                          .map((service) => DropdownMenuItem(
                                value: service["id"].toString(),
                                child: Text(service["name"]),
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

  Future<void> _confirmSelection() async {
    if (selectedBranch != null &&
        selectedWorker != null &&
        selectedService != null &&
        selectedDate != null &&
        selectedTime != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      String formattedTime = selectedTime!.format(context);

      int customerId = 1; // Replace with actual customer ID

      Map<String, dynamic> bookingData = {
        "service_id": int.parse(selectedService!),
        "customer_id": customerId,
        "worker_id": int.parse(selectedWorker!),
        "branch_id": int.parse(selectedBranch!),
        "date": formattedDate,
        "time": formattedTime,
      };

      try {
        final response = await http.post(
          Uri.parse("http://127.0.0.1:8000/book/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bookingData),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 201) {
          _showDialog(
              "Success", "Booking successful! ID: ${responseData['event_id']}");
        } else {
          _showDialog("Error", responseData["error"]);
        }
      } catch (e) {
        _showDialog("Error", "Failed to connect to server.");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
