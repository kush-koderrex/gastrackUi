import 'package:flutter/services.dart';

class GasTrackService {
  static const platform = MethodChannel('com.example.gas_track_ui/gtrack_process');

  static Future<void> startPeriodicTask(String device, int duration) async {
    try {
      final String result = await platform.invokeMethod(
        'launchPeriodicTask',
        {
          'device': device,
          'duration': duration,
        },
      );
      print(result);
    } on PlatformException catch (e) {
      print("Error starting periodic task: ${e.message}");
    }
  }
}
