import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

import 'package:firebase_messaging/firebase_messaging.dart';

// class PermissionAccess {
//   /// Requests all necessary permissions
//   Future<bool> getPermission() async {
//     // List of permissions to request
//     Map<handler.Permission, handler.PermissionStatus> statuses = await [
//       handler.Permission.location,
//       handler.Permission.bluetooth,
//       handler.Permission.bluetoothScan,
//       handler.Permission.storage, // Add storage permission
//       handler.Permission.notification, // Add storage permission
//     ].request();
//
//     // Flag to track if all permissions are granted
//     bool allGranted = true;
//
//     // Check each permission's status
//     for (var entry in statuses.entries) {
//       if (entry.value == handler.PermissionStatus.denied) {
//         Fluttertoast.showToast(msg: "${entry.key} permission is denied");
//         allGranted = false;
//       } else if (entry.value == handler.PermissionStatus.permanentlyDenied) {
//         Fluttertoast.showToast(msg: "${entry.key} permission is permanently denied. Please enable it in settings.");
//         allGranted = false;
//         await Future.delayed(Duration(seconds: 3));
//         await handler.openAppSettings();
//       }
//     }
//
//     // Request notification permission separately
//     bool notificationGranted = await _requestNotificationPermission();
//
//     // Combine the results
//     return allGranted && notificationGranted;
//   }
//
//   /// Requests notification permission separately
//   Future<bool> _requestNotificationPermission() async {
//     try {
//       final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//       // Request notification permission
//       NotificationSettings settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//
//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         print('Notification permission granted');
//         return true;
//       } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//         print('Provisional notification permission granted');
//         return true;
//       } else {
//         print('Notification permission denied');
//         Fluttertoast.showToast(msg: "Notification permission is denied.");
//         return false;
//       }
//     } catch (e) {
//       print('Error requesting notification permission: $e');
//       return false;
//     }
//   }
// }

class PermissionAccess {
  /// Requests all necessary permissions
  Future<bool> getPermission() async {
    int attemptCount = 0; // Counter for the number of permission attempts
    const maxAttempts = 3; // Maximum number of attempts

    while (attemptCount < maxAttempts) {
      // Increment the attempt counter
      attemptCount++;

      // Request permissions
      Map<handler.Permission, handler.PermissionStatus> statuses = await [
        handler.Permission.location,
        handler.Permission.bluetooth,
        handler.Permission.bluetoothScan,
        // handler.Permission.storage,
        handler.Permission.notification,
      ].request();

      // Flag to track if all permissions are granted
      bool allGranted = true;

      // Check each permission's status
      for (var entry in statuses.entries) {
        if (entry.value == handler.PermissionStatus.denied) {
          Fluttertoast.showToast(msg: "${entry.key} permission is denied");
          allGranted = false;
        } else if (entry.value == handler.PermissionStatus.permanentlyDenied) {
          Fluttertoast.showToast(msg: "${entry.key} permission is permanently denied. Please enable it in settings.");
          allGranted = false;
        }
      }

      // Request notification permission separately
      bool notificationGranted = await _requestNotificationPermission();

      // Combine the results
      if (allGranted && notificationGranted) {
        return true; // All permissions granted
      }

      // If not all permissions are granted, notify and retry
      if (attemptCount < maxAttempts) {
        Fluttertoast.showToast(msg: "Retrying permissions... Attempt $attemptCount of $maxAttempts");
        await Future.delayed(Duration(seconds: 2)); // Wait before retrying
      } else {
        Fluttertoast.showToast(msg: "Max attempts reached. Please enable permissions in settings.");
        await Future.delayed(Duration(seconds: 3));
        await handler.openAppSettings(); // Open app settings
      }
    }

    return false; // Return false if all attempts fail
  }

  /// Requests notification permission separately
  Future<bool> _requestNotificationPermission() async {
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

      // Request notification permission
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Notification permission granted');
        return true;
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('Provisional notification permission granted');
        return true;
      } else {
        print('Notification permission denied');
        Fluttertoast.showToast(msg: "Notification permission is denied.");
        return false;
      }
    } catch (e) {
      print('Error requesting notification permission: $e');
      return false;
    }
  }
}


class PermissionsStatus {


  static Future<bool> _bleConnectStatus() async {
    PermissionStatus permissionStatus =
        await Permission.bluetoothConnect.status;
    if (permissionStatus.isGranted) {
      return true;
    } else {
      await Permission.bluetoothConnect.request();
      return false;
    }
  }

  static Future<bool> _bleScanStatus() async {
    PermissionStatus permissionStatus = await Permission.bluetoothScan.status;
    if (permissionStatus.isGranted) {
      return true;
    } else {
      await Permission.bluetoothScan.request();
      return false;
    }
  }

  Future<bool> status() async {
    if (Platform.isAndroid) {
      // final locationPStatus = await _locationStatus();
      final bleScanPStatus = await _bleScanStatus();
      final bleConnectPStatus = await _bleConnectStatus();
      if (
      // locationPStatus &&
          bleConnectPStatus &&
          bleConnectPStatus &&
          bleScanPStatus) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
