import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('I am Evil nooo'),
              ElevatedButton(
                onPressed: () {
                  print("Button pressed");
                },
                child: Text('Elevated Button'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
