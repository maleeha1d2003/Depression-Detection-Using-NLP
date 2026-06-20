import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const BatteryApp());

class BatteryApp extends StatefulWidget {
  const BatteryApp({super.key});

  @override
  State<BatteryApp> createState() => _BatteryAppState();
}

class _BatteryAppState extends State<BatteryApp> {
  static const platform = MethodChannel('battery_channel');
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level: $result%';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Battery Level App')),
        body: Center(child: Text(_batteryLevel)),
        floatingActionButton: FloatingActionButton(
          onPressed: _getBatteryLevel,
          child: const Icon(Icons.battery_full),
        ),
      ),
    );
  }
}
