import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(VehicleInfoApp());
}

class VehicleInfoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Info Checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VehicleInfoHomePage(),
    );
  }
}

class VehicleInfoHomePage extends StatefulWidget {
  @override
  _VehicleInfoHomePageState createState() => _VehicleInfoHomePageState();
}

class _VehicleInfoHomePageState extends State<VehicleInfoHomePage> {
  final _vehicleNumberController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _vehicleData; // Mark as nullable

  Future<void> _fetchVehicleData() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.example.com/vehicle?number=${_vehicleNumberController.text}'));

    if (response.statusCode == 200) {
      setState(() {
        _vehicleData = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _vehicleData = null;
      });
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Info Checker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _vehicleNumberController,
              decoration: InputDecoration(
                labelText: 'Enter Vehicle Number',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchVehicleData,
              child: Text('Check Vehicle Info'),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_vehicleData != null && _vehicleData!.isNotEmpty)
              Expanded(
                child: ListView(
                  children: _vehicleData!.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    );
                  }).toList(),
                ),
              )
            else if (_vehicleData == null)
              Text('No data available')
          ],
        ),
      ),
    );
  }
}
