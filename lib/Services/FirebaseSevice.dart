import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:developer' as developer;

// void logInfo(String message) {
//   developer.log(message, name: "GasTrack");
// }

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateFCMToken({
    required String customerId,
    required String fcmToken,
  }) async {
    try {
      // Reference the Firestore document using the customerId
      DocumentReference userRef =
          _db.collection('gtrack_customers').doc(customerId);

      // Update the FCM token in the Firestore document
      await userRef.update({
        'fcm_token': fcmToken,
        'last_update_date':
            FieldValue.serverTimestamp(), // Track the update time
      });

      print('FCM token updated successfully for customerId: $customerId');
    } catch (e) {
      print('Error updating FCM token for customerId $customerId: $e');
    }
  }

  Future<void> addUser({
    required String name,
    required String email,
    required String phone,
    required String profileUrl,
    required String userId,
    required String authType,
    required String customer_id,
    required String latitude,
    required String longitude,
    required String city,
    required String state,
    required String country,
  }) async {
    try {
      // Use phone as the document ID if email is empty
      String docId = email.isNotEmpty ? email : phone;

      DocumentReference userRef = _db.collection('gtrack_customers').doc(docId);
      DocumentSnapshot userDoc = await userRef.get();

      Map<String, dynamic> userData = {
        'auth_type': authType,
        'customer_id': customer_id,
        'name': name,
        'email': email,
        'phone': phone,
        'profileUrl': profileUrl,
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'city': city,
        'state': state,
        'country': country,
        'last_update_date': FieldValue.serverTimestamp(),
      };

      if (!userDoc.exists) {
        userData['registration_date'] = FieldValue.serverTimestamp();
      }

      await userRef.set(userData, SetOptions(merge: true));
      print('User added or updated successfully');
    } catch (e) {
      print('Error adding or updating user: $e');
    }
  }

  Future<void> updateGasDetails({
    required String email,
    required String phone,
    required String gasConsumerNo,
    required String deviceName,
    required String gasCompany,
  }) async {
    try {
      // Use phone as the document ID if email is empty
      String docId = email.isNotEmpty ? email : phone;

      DocumentReference userRef = _db.collection('gtrack_customers').doc(docId);

      Map<String, dynamic> gasData = {
        'gas_consumer_no': gasConsumerNo,
        'device_name': deviceName,
        'gas_company': gasCompany,
        'last_update_date': FieldValue.serverTimestamp(),
      };

      await userRef.set(gasData, SetOptions(merge: true));
      print('Gas details updated successfully');
    } catch (e) {
      print('Error updating gas details: $e');
    }
  }

  Future<void> updateGasReadings({
    required String customerId,
    required String weight,
    required String battery,
    required String remainGas,
    required bool criticalFlag,
    required DateTime readingDate,
  }) async {
    try {
      // Reference the document using customerId
      DocumentReference userRef =
          _db.collection('gtrack_customers').doc(customerId);

      Map<String, dynamic> readingData = {
        'remainGas': remainGas,
        'weight': weight,
        'battery': battery,
        'critical_flag': criticalFlag,
        'reading_date': readingDate,
      };

      // Add new reading to the 'gas_readings' array field
      await userRef.update({
        'gas_readings': FieldValue.arrayUnion([readingData]),
        'last_update_date': FieldValue.serverTimestamp(),
      });

      print('Gas readings updated successfully');
    } catch (e) {
      print('Error updating gas readings: $e');
    }
  }

  Future<void> updateDeviceDetails({
    required String customerId,
    required BluetoothDevice device,
  }) async {
    try {
      DocumentReference userRef =
          _db.collection('gtrack_customers').doc(customerId);

      await userRef.update({
        'device': device.id.toString(), // Store only device ID
        'last_update_date': FieldValue.serverTimestamp(),
      });

      print('Device details updated successfully for customerId: $customerId');
    } catch (e) {
      print('Error updating device details for customerId $customerId: $e');
    }
  }

  Future<String?> fetchDeviceDetails({required String customerId}) async {
    try {
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('gtrack_customers')
          .doc(customerId);

      DocumentSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('device')) {
          String deviceId = data['device'];
          print('Device ID for customerId $customerId: $deviceId');
          return deviceId; // Return the device ID
        }
      }
      print('No device details found for customerId: $customerId');
      return null;
    } catch (e) {
      print('Error fetching device details for customerId $customerId: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getGasReadings(String customerId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('gtrack_customers').doc(customerId).get();
      if (doc.exists) {
        List readings = doc.get('gas_readings') ?? [];
        return List<Map<String, dynamic>>.from(readings);
      } else {
        print("No readings found for customerId: $customerId");
        return [];
      }
    } catch (e) {
      print('Error fetching gas readings: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getGasReadingsLogs(
      String customerId) async {
    try {
      // Fetch documents from the 'gas_readings' collection
      QuerySnapshot snapshot = await _db
          .collection('gas_readings') // Your Firestore collection name
          .where('customer_id', isEqualTo: customerId) // Query by customer_id
          .orderBy(
              'reading_date') // Order by reading_date to ensure correct sorting
          .get();

      // Convert the snapshot to a list of maps
      List<Map<String, dynamic>> readings = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return readings;
    } catch (e) {
      print("Error fetching gas readings: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getUserData({
    required String email,
    required String phone,
  }) async {
    try {
      // Use phone as the document ID if email is empty
      String docId = email.isNotEmpty ? email : phone;

      DocumentSnapshot userDoc =
          await _db.collection('gtrack_customers').doc(docId).get();

      // Check if the user document exists
      if (userDoc.exists) {
        // Return user data as a Map<String, dynamic>
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getGasReadingsDaysofuse(
      String customerId) async {
    // Fetch data from Firestore based on customerId (this is just an example)
    var snapshot = await FirebaseFirestore.instance
        .collection('gasReadings')
        .where('customerId', isEqualTo: customerId)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}

// int calculateUsageDays(List<Map<String, dynamic>> logEntries) {
//   // Step 1: Filter logs where critical_flag is true
//   List<Map<String, dynamic>> criticalLogs = logEntries.where((log) => log['critical_flag'] == true).toList();
//   print("Step 1 - Critical Logs: $criticalLogs");
//
//   // Step 2: If there are no critical logs, return 0
//   if (criticalLogs.isEmpty) {
//     print("No critical logs found.");
//     return 0;
//   }
//
//   // Step 3: Convert reading_date to DateTime and group by date, handling null values
//   Set<DateTime> criticalDates = criticalLogs
//       .where((log) => log['reading_date'] != null) // Filter out null timestamps
//       .map((log) {
//     var timestamp = log['reading_date'];
//     if (timestamp is Timestamp) {
//       DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//       return DateTime(date.year, date.month, date.day);
//     }
//     return null; // Return null if not a valid timestamp
//   })
//       .where((date) => date != null) // Remove null values
//       .cast<DateTime>() // Ensure proper type
//       .toSet();
//
//   print("Step 3 - Unique Critical Dates: $criticalDates");
//
//   // Step 4: Find the max critical date
//   if (criticalDates.isEmpty) return 0; // Ensure we don't call reduce() on an empty set
//   DateTime maxCriticalDate = criticalDates.reduce((a, b) => a.isAfter(b) ? a : b);
//   print("Step 4 - Max Critical Date: $maxCriticalDate");
//
//   // Step 5: Filter logs with dates greater than the max critical date
//   List<DateTime> futureDates = logEntries
//       .where((log) => log['reading_date'] != null) // Ensure timestamp is not null
//       .map((log) {
//     var timestamp = log['reading_date'];
//     if (timestamp is Timestamp) {
//       DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//       return DateTime(date.year, date.month, date.day);
//     }
//     return null; // Return null if not a valid timestamp
//   })
//       .where((date) => date != null && date.isAfter(maxCriticalDate)) // Ensure date is valid
//       .cast<DateTime>() // Convert back to DateTime type
//       .toList();
//
//   print("Step 5 - Future Dates After Max Critical Date: $futureDates");
//
//   // Step 6: Group future dates by unique days and count them
//   int uniqueFutureDays = futureDates.toSet().length;
//   print("Step 6 - Unique Future Days Count: $uniqueFutureDays");
//
//   return uniqueFutureDays;
// }

// TODO:without unique

// int calculateUsageDays(List<Map<String, dynamic>> logEntries) {
//   print("Step 1: Received Log Entries -> $logEntries");
//
//   // Step 1: Convert reading_date to DateTime, handling null values
//   List<DateTime> dates = logEntries
//       .where((log) => log['reading_date'] != null) // Remove null timestamps
//       .map((log) {
//     var timestamp = log['reading_date'];
//     if (timestamp is Timestamp) {
//       DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//       return DateTime(date.year, date.month, date.day);
//     }
//     return null; // Return null if not a valid timestamp
//   })
//       .where((date) => date != null) // Remove null values
//       .cast<DateTime>() // Ensure proper type
//       .toList();
//
//   print("Step 2: Extracted & Converted Dates -> $dates");
//
//   // Step 2: Sort logs by date to process them in order
//   dates.sort();
//   print("Step 3: Sorted Dates -> $dates");
//
//   // Step 3: Identify positions of critical (Y) and non-critical (X) logs
//   List<bool> isCriticalList = logEntries.map((log) => log['critical_flag'] == true).toList();
//   print("Step 4: Boolean List of Critical Flags (Y = true, X = false) -> $isCriticalList");
//
//   int lastCriticalIndex = isCriticalList.lastIndexWhere((flag) => flag); // Last Y position
//   int firstCriticalIndex = isCriticalList.indexWhere((flag) => flag); // First Y position
//
//   print("Step 5: First Critical Flag Index -> $firstCriticalIndex");
//   print("Step 6: Last Critical Flag Index -> $lastCriticalIndex");
//
//   if (lastCriticalIndex == -1) {
//     // No critical flag (all Xs) → return total count of Xs
//     int totalDays = isCriticalList.length;
//     print("Step 7: No Critical Logs Found. Total Days of Use = $totalDays");
//     return totalDays;
//   }
//
//   // Step 7: Count Xs before last Y
//   int xBeforeY = isCriticalList.sublist(0, lastCriticalIndex).where((flag) => !flag).length;
//   print("Step 8: Count of X before Last Y = $xBeforeY");
//
//   // Step 8: Count Xs after last Y
//   int xAfterY = isCriticalList.sublist(lastCriticalIndex + 1).where((flag) => !flag).length;
//   print("Step 9: Count of X after Last Y = $xAfterY");
//
//   // Step 9: Return the correct count based on scenarios
//   int finalUsageDays = xAfterY > 0 ? xAfterY : xBeforeY;
//   print("Step 10: Final Usage Days (Recent Days of Use) = $finalUsageDays");
//
//   return finalUsageDays;
// }


// TODO:with unique
// int calculateUsageDays(List<Map<String, dynamic>> logEntries) {
//   print("Step 1: Received Log Entries -> $logEntries");
//
//   // Step 1: Convert reading_date to DateTime (removing duplicates per day)
//   Map<DateTime, bool> dateFlags = {}; // Stores date -> isCritical (Y or X)
//
//   for (var log in logEntries) {
//     if (log['reading_date'] == null) continue; // Ignore null timestamps
//
//     var timestamp = log['reading_date'];
//     DateTime date;
//
//     if (timestamp is Timestamp) {
//       date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//       date = DateTime(date.year, date.month, date.day); // Keep only Y-M-D
//     } else {
//       continue; // Skip if not a valid timestamp
//     }
//
//     bool isCritical = log['critical_flag'] == true;
//
//     if (!dateFlags.containsKey(date)) {
//       dateFlags[date] = isCritical; // First occurrence of the date
//     } else if (isCritical) {
//       dateFlags[date] = true; // If any log on that date is Y, override it
//     }
//   }
//
//   print("Step 2: Mapped Unique Dates with Critical Flags -> $dateFlags");
//
//   // Step 2: Sort dates
//   List<DateTime> sortedDates = dateFlags.keys.toList()..sort();
//   print("Step 3: Sorted Unique Dates -> $sortedDates");
//
//   // Step 3: Convert sorted dates to flag list (X = false, Y = true)
//   List<bool> isCriticalList = sortedDates.map((date) => dateFlags[date]!).toList();
//   print("Step 4: Boolean List (Y = true, X = false) -> $isCriticalList");
//
//   int lastCriticalIndex = isCriticalList.lastIndexWhere((flag) => flag); // Last Y position
//   print("Step 5: Last Critical Flag Index -> $lastCriticalIndex");
//
//   if (lastCriticalIndex == -1) {
//     // If there are no Ys (all Xs), return the total count
//     int totalDays = isCriticalList.length;
//     print("Step 6: No Critical Logs Found. Total Days of Use = $totalDays");
//     return totalDays;
//   }
//
//   // Step 6: Count Xs before and after last Y
//   int xBeforeY = isCriticalList.sublist(0, lastCriticalIndex).where((flag) => !flag).length;
//   int xAfterY = isCriticalList.sublist(lastCriticalIndex + 1).where((flag) => !flag).length;
//
//   print("Step 7: X Count Before Last Y = $xBeforeY");
//   print("Step 8: X Count After Last Y = $xAfterY");
//
//   // Step 7: Return X count after last Y (if available), otherwise before
//   int finalUsageDays = xAfterY > 0 ? xAfterY : xBeforeY;
//   print("Step 9: Final Usage Days (Recent Days of Use) = $finalUsageDays");
//
//   return finalUsageDays;
// }

// TODO:without unique
// Scenario	Input Log (X = No Critical, Y = Critical)	Expected Output
// 1	XXXXXX	✅ 6
// 2	XXXXXXYYY	✅ 6
// 3	XXXXXXYYYXXXXX	✅ 5
// 4	XXXXXXYYYXXXXXYY	✅ 5
// 5	YXXXXXX	✅ 6
// 6	XXYXXXYYXX	✅ 2
// 7	YYYY	✅ 0
// 8	XXXYYYXXXYYY	✅ 3
// 9  XXXXXYYXX	✅ 2
// 10 XXYXXXYYXX ✅ 2

// TODO:without unique


// int calculateUsageDays(List<Map<String, dynamic>> logEntries) {
//   print("Step 1: Received Log Entries -> $logEntries");
//
//   // Step 1: Convert reading_date to DateTime (removing duplicates per day)
//   Map<DateTime, bool> dateFlags = {}; // Stores date -> isCritical (Y or X)
//
//   for (var log in logEntries) {
//     if (log['reading_date'] == null) continue; // Ignore null timestamps
//
//     var timestamp = log['reading_date'];
//     DateTime date;
//
//     if (timestamp is Timestamp) {
//       date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//       date = DateTime(date.year, date.month, date.day); // Keep only Y-M-D
//     } else {
//       continue; // Skip if not a valid timestamp
//     }
//
//     bool isCritical = log['critical_flag'] == true;
//
//     if (!dateFlags.containsKey(date)) {
//       dateFlags[date] = isCritical; // First occurrence of the date
//     } else if (isCritical) {
//       dateFlags[date] = true; // If any log on that date is Y, override it
//     }
//   }
//
//   print("Step 2: Mapped Unique Dates with Critical Flags -> $dateFlags");
//
//   // Step 2: Sort dates
//   List<DateTime> sortedDates = dateFlags.keys.toList()..sort();
//   print("Step 3: Sorted Unique Dates -> $sortedDates");
//
//   // Step 3: Convert sorted dates to flag list (X = false, Y = true)
//   List<bool> isCriticalList = sortedDates.map((date) => dateFlags[date]!).toList();
//   print("Step 4: Boolean List (Y = true, X = false) -> $isCriticalList");
//
//   int lastCriticalIndex = isCriticalList.lastIndexWhere((flag) => flag); // Last Y position
//   print("Step 5: Last Critical Flag Index -> $lastCriticalIndex");
//
//   if (lastCriticalIndex == -1) {
//     // If there are no Ys (all Xs), return the total count
//     int totalDays = isCriticalList.length;
//     print("Step 6: No Critical Logs Found. Total Days of Use = $totalDays");
//     return totalDays;
//   }
//
//   int secondLastCriticalIndex = isCriticalList.sublist(0, lastCriticalIndex).lastIndexWhere((flag) => flag);
//   print("Step 6: Second Last Critical Flag Index -> $secondLastCriticalIndex");
//
//   if (isCriticalList[isCriticalList.length - 1]) {
//     // If last entry is Y, count Xs **between** last Y and previous Y
//     if (secondLastCriticalIndex == -1) {
//       print("Step 7: No previous Y found, returning 0");
//       return 0; // No previous Y found, so we return 0
//     }
//     int countBetweenY = isCriticalList.sublist(secondLastCriticalIndex + 1, lastCriticalIndex).where((flag) => !flag).length;
//     print("Step 8: Count of X between last Y and previous Y = $countBetweenY");
//     return countBetweenY;
//   } else {
//     // If last entry is X, count Xs **after** last Y
//     int xAfterY = isCriticalList.sublist(lastCriticalIndex + 1).where((flag) => !flag).length;
//     print("Step 9: Count of X after Last Y = $xAfterY");
//     return xAfterY;
//   }
// }



// TODO:Final


// int calculateUsageDays(List<Map<String, dynamic>> logEntries) {
//   print("Step 1: Received Log Entries -> $logEntries");
//
//   // Step 1: Convert reading_date to DateTime (removing duplicates per day)
//   Map<DateTime, bool> dateFlags = {}; // Stores date -> isCritical (Y or X)
//
//   for (var log in logEntries) {
//     if (log['reading_date'] == null) continue; // Ignore null timestamps
//
//     var timestamp = log['reading_date'];
//     DateTime date;
//
//     if (timestamp is Timestamp) {
//       date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//       date = DateTime(date.year, date.month, date.day); // Keep only Y-M-D
//     } else {
//       continue; // Skip if not a valid timestamp
//     }
//
//     bool isCritical = log['critical_flag'] == true;
//
//     if (!dateFlags.containsKey(date)) {
//       dateFlags[date] = isCritical; // First occurrence of the date
//     } else if (isCritical) {
//       dateFlags[date] = true; // If any log on that date is Y, override it
//     }
//   }
//
//   print("Step 2: Mapped Unique Dates with Critical Flags -> $dateFlags");
//
//   // Step 2: Sort dates
//   List<DateTime> sortedDates = dateFlags.keys.toList()..sort();
//   print("Step 3: Sorted Unique Dates -> $sortedDates");
//
//   // Step 3: Convert sorted dates to flag list (X = false, Y = true)
//   List<bool> isCriticalList = sortedDates.map((date) => dateFlags[date]!).toList();
//   print("Step 4: Boolean List (Y = true, X = false) -> $isCriticalList");
//
//   // Handle empty list
//   if (isCriticalList.isEmpty) {
//     print("Step 5: Empty list, returning 0");
//     return 0;
//   }
//
//   // Find the first Y position (first true)
//   int firstCriticalIndex = isCriticalList.indexWhere((flag) => flag);
//   print("Step 5: First Critical Flag Index -> $firstCriticalIndex");
//
//   if (firstCriticalIndex == -1) {
//     // If there are no Ys (all Xs), return the total count
//     int totalDays = isCriticalList.length;
//     print("Step 6: No Critical Logs Found. Total Days of Use = $totalDays");
//     return totalDays;
//   }
//
//   // Count X days before the first Y
//   int xBeforeFirstY = firstCriticalIndex;
//   print("Step 6: X days before first Y = $xBeforeFirstY");
//
//   // Find the last Y position
//   int lastCriticalIndex = isCriticalList.lastIndexWhere((flag) => flag);
//
//   // If the last entry is X, also count Xs after the last Y
//   int xAfterLastY = 0;
//   if (lastCriticalIndex < isCriticalList.length - 1) {
//     xAfterLastY = isCriticalList.length - lastCriticalIndex - 1;
//     print("Step 7: X days after last Y = $xAfterLastY");
//   }
//
//   // Find gaps between consecutive Y groups
//   int gapsBetweenYGroups = 0;
//   bool inYGroup = false;
//   int currentGapStart = -1;
//
//   for (int i = firstCriticalIndex; i <= lastCriticalIndex; i++) {
//     if (isCriticalList[i]) {
//       // Found a Y
//       if (!inYGroup) {
//         // Start of a new Y group
//         inYGroup = true;
//
//         // If we were counting a gap, add it to the total
//         if (currentGapStart != -1) {
//           gapsBetweenYGroups += (i - currentGapStart);
//           print("Step 8: Found gap from $currentGapStart to ${i-1}");
//           currentGapStart = -1;
//         }
//       }
//     } else {
//       // Found an X
//       if (inYGroup) {
//         // End of a Y group, start counting a new gap
//         inYGroup = false;
//         currentGapStart = i;
//       }
//     }
//   }
//
//   // For your specific case [false, false, false, false, false, false, false, true, true]
//   // We want to return 7 (all X days before the first Y)
//   int totalXDays = xBeforeFirstY + xAfterLastY;
//   print("Step 9: Total usage days = $totalXDays");
//
//   return totalXDays;
// }



int calculateUsageDays(List<Map<String, dynamic>> logEntries) {
  print("Step 1: Received Log Entries -> $logEntries");

  // Step 1: Convert reading_date to DateTime (removing duplicates per day)
  Map<DateTime, bool> dateFlags = {}; // Stores date -> isCritical (Y or X)

  for (var log in logEntries) {
    if (log['reading_date'] == null) continue; // Ignore null timestamps

    var timestamp = log['reading_date'];
    DateTime date;

    if (timestamp is Timestamp) {
      date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      date = DateTime(date.year, date.month, date.day); // Keep only Y-M-D
    } else {
      continue; // Skip if not a valid timestamp
    }

    bool isCritical = log['critical_flag'] == true;

    if (!dateFlags.containsKey(date)) {
      dateFlags[date] = isCritical; // First occurrence of the date
    } else if (isCritical) {
      dateFlags[date] = true; // If any log on that date is Y, override it
    }
  }

  print("Step 2: Mapped Unique Dates with Critical Flags -> $dateFlags");

  // Step 2: Sort dates
  List<DateTime> sortedDates = dateFlags.keys.toList()..sort();
  print("Step 3: Sorted Unique Dates -> $sortedDates");

  // Step 3: Convert sorted dates to flag list (X = false, Y = true)
  List<bool> isCriticalList = sortedDates.map((date) => dateFlags[date]!).toList();
  print("Step 4: Boolean List (Y = true, X = false) -> $isCriticalList");

  // Handle empty list
  if (isCriticalList.isEmpty) {
    print("Step 5: Empty list, returning 0");
    return 0;
  }

  // Case: All days are X (Scenario 1)
  if (!isCriticalList.contains(true)) {
    int totalDays = isCriticalList.length;
    print("Case 1: All X days. Total Days of Use = $totalDays");
    return totalDays;
  }

  // Case: All days are Y (Scenario 7)
  if (!isCriticalList.contains(false)) {
    print("Case 7: All Y days. Total Days of Use = 0");
    return 0;
  }

  // Find the last Y index
  int lastYIndex = isCriticalList.lastIndexWhere((flag) => flag);
  print("Last Y Index: $lastYIndex");

  // Case: Last day is X (Scenarios 3, 5, 6, 9, 10)
  if (lastYIndex < isCriticalList.length - 1) {
    // Count all X days after the last Y
    int xDaysAfterLastY = isCriticalList.length - lastYIndex - 1;
    print("Case X: Last day is X. X days after last Y = $xDaysAfterLastY");
    return xDaysAfterLastY;
  }

  // Case: Last day is Y (Scenarios 2, 4, 8)
  // Need to look for X sequences between Y groups

  // Find the first Y index for reference
  int firstYIndex = isCriticalList.indexWhere((flag) => flag);

  // If the last entry is Y, we need to find the last group of consecutive Y's
  // and then count X's before that group
  int lastYGroupStartIndex = lastYIndex;

  // Walk backward from the last Y to find where the last Y group starts
  while (lastYGroupStartIndex > 0 && isCriticalList[lastYGroupStartIndex - 1]) {
    lastYGroupStartIndex--;
  }

  print("Last Y Group starts at index: $lastYGroupStartIndex");

  // Count X days before the last Y group but after any previous Y
  int xDaysCount = 0;

  // If there are previous Y's, find the last one before this group
  if (lastYGroupStartIndex > 0) {
    int previousYIndex = isCriticalList.lastIndexWhere((flag) => flag, lastYGroupStartIndex - 1);

    if (previousYIndex != -1) {
      // Count X's between the previous Y and the last Y group
      xDaysCount = lastYGroupStartIndex - previousYIndex - 1;
      print("Case Y: Last day is Y. X days between previous Y and last Y group = $xDaysCount");
    } else {
      // No previous Y, count all X's before the last Y group
      xDaysCount = lastYGroupStartIndex;
      print("Case Y: Last day is Y. X days before last Y group = $xDaysCount");
    }
  } else {
    // The last Y group starts at the beginning, so no X's to count
    xDaysCount = 0;
    print("Case Y: Last day is Y. No X days before last Y group");
  }

  return xDaysCount;
}