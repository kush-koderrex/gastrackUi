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
      DocumentReference userRef = _db.collection('gtrack_customers').doc(customerId);

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
      DocumentSnapshot doc = await _db.collection('gtrack_customers').doc(customerId).get();
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




}




// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   Future<void> addUser({
//     required String name,
//     required String email,
//     required String phone,
//     required String profileUrl,
//     required String userId,
//     required String authType,
//     required String latitude,
//     required String longitude,
//     required String city,
//     required String state,
//     required String country,
//   }) async {
//     try {
//       // Use phone as the document ID if email is empty
//       String docId = email.isNotEmpty ? email : phone;
//
//       DocumentReference userRef = _db.collection('gtrack_customers').doc(docId);
//       DocumentSnapshot userDoc = await userRef.get();
//
//       Map<String, dynamic> userData = {
//         'auth_type': authType,
//         'name': name,
//         'email': email,
//         'phone': phone,
//         'profileUrl': profileUrl,
//         'userId': userId,
//         'latitude': latitude,
//         'longitude': longitude,
//         'city': city,
//         'state': state,
//         'country': country,
//         'last_update_date': FieldValue.serverTimestamp(),
//       };
//
//       if (!userDoc.exists) {
//         userData['registration_date'] = FieldValue.serverTimestamp();
//       }
//
//       await userRef.set(userData, SetOptions(merge: true));
//       print('User added or updated successfully');
//     } catch (e) {
//       print('Error adding or updating user: $e');
//     }
//   }
//
//   Future<void> updateGasDetails({
//     required String email,
//     required String gasConsumerNo,
//     required String deviceName,
//     required String gasCompany,
//   }) async {
//     try {
//
//       DocumentReference userRef = _db.collection('gtrack_customers').doc(email);
//
//       Map<String, dynamic> gasData = {
//         'gas_consumer_no': gasConsumerNo,
//         'device_name': deviceName,
//         'gas_company': gasCompany,
//         'last_update_date': FieldValue.serverTimestamp(),
//       };
//
//       await userRef.set(gasData, SetOptions(merge: true));
//       print('Gas details updated successfully');
//     } catch (e) {
//       print('Error updating gas details: $e');
//     }
//   }
// }
