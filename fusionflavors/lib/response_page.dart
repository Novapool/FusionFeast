import 'package:flutter/material.dart';

class ResponsePage extends StatelessWidget {
  final Future<String> responseFuture;

  const ResponsePage({super.key, required this.responseFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: responseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Keeps the column size to its children size
                children: [
                  Image.asset(
                    'assets/images/logo_final.png', // Ensure the asset path is correct
                    width: 250, // Adjust as needed
                    height: 250, // Adjust as needed
                  ),
                  SizedBox(
                      height:
                          100), // Space between image and progress indicator
                  CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 8, // Adjust the stroke width as needed
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display the image at the top of the page followed by the result
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_final.png', // Ensure the asset path is correct
                    width: 170, // Adjust as needed
                    height: 170, // Adjust as needed
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      snapshot.data ?? 'No response',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
