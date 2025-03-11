import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BLETaskScreen extends StatefulWidget {
  @override
  _BLETaskScreenState createState() => _BLETaskScreenState();
}

class _BLETaskScreenState extends State<BLETaskScreen> {
  static const platform = MethodChannel('com.gastrack.background/gtrack_process');

  // final TextEditingController _deviceNameController = TextEditingController(text: "BLE Device");
  final TextEditingController _deviceNameController = TextEditingController(text: "Project_RED_TTTP");
  final TextEditingController _durationController = TextEditingController(text: "15");
  final TextEditingController _serviceUUIDController = TextEditingController(text: "9999");
  final TextEditingController _characteristicUUIDController = TextEditingController(text: "8888");
  final TextEditingController _readCharacteristicUUIDController = TextEditingController(text: "9999");
  final TextEditingController _customerIdController = TextEditingController(text: "jarvis.ai.kush@gmail.com");

  Future<void> startTask() async {
    try {
      String deviceName = _deviceNameController.text;
      int duration = int.parse(_durationController.text);
      String serviceUUID = _serviceUUIDController.text;
      String characteristicUUID = _characteristicUUIDController.text;
      String readCharacteristicUUID = _readCharacteristicUUIDController.text;
      String customerId = _customerIdController.text;

      final result = await platform.invokeMethod('launchPeriodicTask', {
        'device': deviceName,
        'duration': duration,
        'serviceUUID': serviceUUID,
        'characteristicUUID': characteristicUUID,
        'readCharacteristicUUID': readCharacteristicUUID,
        'customerId': customerId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task Started: $result')),
      );
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting task: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start BLE Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _deviceNameController,
              decoration: InputDecoration(labelText: 'Device Name'),
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _serviceUUIDController,
              decoration: InputDecoration(labelText: 'Service UUID'),
            ),
            TextField(
              controller: _characteristicUUIDController,
              decoration: InputDecoration(labelText: 'Characteristic UUID'),
            ),
            TextField(
              controller: _readCharacteristicUUIDController,
              decoration: InputDecoration(labelText: 'Read Characteristic UUID'),
            ),
            TextField(
              controller: _customerIdController,
              decoration: InputDecoration(labelText: 'Customer ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startTask,
              child: Text('Start Task'),
            ),
          ],
        ),
      ),
    );
  }
}
