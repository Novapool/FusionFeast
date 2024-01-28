import 'package:flutter/material.dart';
import 'package:fusionflavors/response_page.dart'; // Make sure this import is correct
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> list = <String>[
  'Chinese',
  'Russian',
  'Middle Eastern',
  'Indian',
  'French',
  'Italian',
  'Mexican',
  'Japanese',
  'Korean',
  'Thai',
  'Vietnamese',
  'American',
  'Spanish',
  'Greek',
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _response = '';
  String? _selectedCuisine1;
  String? _selectedCuisine2;

  @override
  void initState() {
    super.initState();
  }

  Future<String> _sendMessage() async {
    const url = 'http://35.21.132.99:8080/ask'; // Replace with your actual URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': 'Fusion between $_selectedCuisine1 and $_selectedCuisine2'
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response']; // Return the actual response
      } else {
        throw Exception('Failed to load response');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/logo_final.png',
                fit: BoxFit.contain,
                height: 250.0, // Adjust the height as needed
                width: 250.0, // Adjust the width as needed
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DropdownButton<String>(
                        value: _selectedCuisine1,
                        hint: const Text('Select First Cuisine',
                            style: TextStyle(color: Colors.blue)),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCuisine1 = newValue;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        isExpanded: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          '',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      DropdownButton<String>(
                        value: _selectedCuisine2,
                        hint: const Text(
                          'Select Second Cuisine',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCuisine2 = newValue;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        isExpanded: true,
                      ),
                      const SizedBox(height: 20),
                      _buildFusionButton(context),
                      const SizedBox(height: 20),
                      Text(_response),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFusionButton(BuildContext context) {
    return Builder(
      builder: (BuildContext newContext) {
        return ElevatedButton(
          onPressed: (_selectedCuisine1 != null &&
                  _selectedCuisine2 != null &&
                  _selectedCuisine1 != _selectedCuisine2)
              ? () async {
                  try {
                    Navigator.of(newContext).push(
                      MaterialPageRoute(
                        builder: (context) => ResponsePage(
                          responseFuture: _sendMessage(),
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(newContext).showSnackBar(
                      SnackBar(content: Text('Error during navigation: $e')),
                    );
                  }
                }
              : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.blue
                      .withOpacity(0.3); // Disabled color, can be adjusted
                }
                return Colors.blue; // Enabled color, solid blue
              },
            ),
            foregroundColor:
                MaterialStateProperty.all<Color>(Colors.white), // Text color
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    4.0), // Adjust for the desired border radius
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0), // Adjust padding to match your design
            ),
          ),
          child: const Text('Fuse'),
        );
      },
    );
  }
}
