import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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


  Future<List<Map<String, dynamic>>> getGasReadingsLogs(String customerId) async {
    try {
      // Fetch documents from the 'gas_readings' collection
      QuerySnapshot snapshot = await _db
          .collection('gas_readings') // Your Firestore collection name
          .where('customer_id', isEqualTo: customerId) // Query by customer_id
          .orderBy('reading_date') // Order by reading_date to ensure correct sorting
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

      DocumentSnapshot userDoc = await _db.collection('gtrack_customers').doc(docId).get();

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

  Future<List<Map<String, dynamic>>> getGasReadingsDaysofuse(String customerId) async {
    // Fetch data from Firestore based on customerId (this is just an example)
    var snapshot = await FirebaseFirestore.instance
        .collection('gasReadings')
        .where('customerId', isEqualTo: customerId)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}

// int calculateUsageDays(List<Map<String, dynamic>> logEntries) {
//   // Filter logs where critical_flag is true
//   List<Map<String, dynamic>> criticalLogs = logEntries.where((log) => log['critical_flag'] == true).toList();
//
//   if (criticalLogs.isEmpty) {
//     return 0; // No critical logs found
//   }
//
//   // Sort logs by reading_date to get the first and last critical log
//   criticalLogs.sort((a, b) {
//     Timestamp aDate = a['reading_date'];
//     Timestamp bDate = b['reading_date'];
//     return aDate.seconds.compareTo(bDate.seconds); // Compare by the seconds of the Timestamp
//   });
//
//   // First critical log date
//   DateTime firstCriticalDate = DateTime.fromMillisecondsSinceEpoch(criticalLogs.first['reading_date'].seconds * 1000);
//   // Last critical log date
//   DateTime lastCriticalDate = DateTime.fromMillisecondsSinceEpoch(criticalLogs.last['reading_date'].seconds * 1000);
//
//   // Calculate difference in days
//   Duration difference = lastCriticalDate.difference(firstCriticalDate);
//   int daysOfUsage = difference.inDays;
//
//   return daysOfUsage;
//
//
// }


// int calculateUsageDays(List<Map<String, dynamic>> logEntries) {
//   // Step 1: Filter logs where critical_flag is true
//   List<Map<String, dynamic>> criticalLogs = logEntries.where((log) => log['critical_flag'] == true).toList();
//
//   // Step 2: If there are no critical logs, return 0
//   if (criticalLogs.isEmpty) {
//     return 0; // No critical logs found
//   }
//
//   // Step 3: Convert reading_date to DateTime and group by date
//   Set<DateTime> criticalDates = criticalLogs.map((log) {
//     Timestamp timestamp = log['reading_date'];
//     DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//     return DateTime(date.year, date.month, date.day); // Normalize to date only
//   }).toSet(); // Ensure unique dates
//
//   // Step 4: Find the max critical date
//   DateTime maxCriticalDate = criticalDates.reduce((a, b) => a.isAfter(b) ? a : b);
//
//   // Step 5: Filter logs with dates greater than the max critical date
//   List<DateTime> futureDates = logEntries.map((log) {
//     Timestamp timestamp = log['reading_date'];
//     DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//     return DateTime(date.year, date.month, date.day); // Normalize to date only
//   }).where((date) => date.isAfter(maxCriticalDate)).toList();
//
//   // Step 6: Group future dates by unique days and count them
//   int uniqueFutureDays = futureDates.toSet().length;
//
//   // Step 7: Add the number of unique critical dates
//   int totalDaysOfUsage = criticalDates.length + uniqueFutureDays;
//
//   return totalDaysOfUsage;
// }


int calculateUsageDays(List<Map<String, dynamic>> logEntries) {
  // Step 1: Filter logs where critical_flag is true
  List<Map<String, dynamic>> criticalLogs = logEntries.where((log) => log['critical_flag'] == true).toList();
  print("Step 1 - Critical Logs: $criticalLogs");

  // Step 2: If there are no critical logs, return 0
  if (criticalLogs.isEmpty) {
    print("No critical logs found.");
    return 0; // No critical logs found
  }

  // Step 3: Convert reading_date to DateTime and group by date
  Set<DateTime> criticalDates = criticalLogs.map((log) {
    Timestamp timestamp = log['reading_date'];
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return DateTime(date.year, date.month, date.day); // Normalize to date only
  }).toSet(); // Ensure unique dates
  print("Step 3 - Unique Critical Dates: $criticalDates");

  // Step 4: Find the max critical date
  DateTime maxCriticalDate = criticalDates.reduce((a, b) => a.isAfter(b) ? a : b);
  print("Step 4 - Max Critical Date: $maxCriticalDate");

  // Step 5: Filter logs with dates greater than the max critical date
  List<DateTime> futureDates = logEntries.map((log) {
    Timestamp timestamp = log['reading_date'];
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return DateTime(date.year, date.month, date.day); // Normalize to date only
  }).where((date) => date.isAfter(maxCriticalDate)).toList();
  print("Step 5 - Future Dates After Max Critical Date: $futureDates");

  // Step 6: Group future dates by unique days and count them
  int uniqueFutureDays = futureDates.toSet().length;
  print("Step 6 - Unique Future Days Count: $uniqueFutureDays");

  // Step 7: Add the number of unique critical dates
  // int totalDaysOfUsage = criticalDates.length + uniqueFutureDays;
  // print("Step 7 - Total Days of Usage: $totalDaysOfUsage");

  return uniqueFutureDays;
  // return totalDaysOfUsage;
}
