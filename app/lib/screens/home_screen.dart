import 'package:flutter/material.dart';
import 'capture_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AgriVision')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Capture Crop Image'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CaptureScreen()),
            );
          },
        ),
      ),
    );
  }
}
