import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    // Request permission for location access
    var status = await Permission.location.request();

    if (status.isGranted) {
      // When permission is granted, get the current position
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } else {
      // Handle permission denied case
      return null;
    }
  }
}