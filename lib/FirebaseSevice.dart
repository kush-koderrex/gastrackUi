import 'package:cloud_firestore/cloud_firestore.dart';




class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser({
    required String name,
    required String email,
    required String profileUrl,
    required String userId,
  }) async {
    try {
      // Reference to the "users" collection
      DocumentReference userRef = _db.collection('users').doc(email);

      // Data to be added to the document
      Map<String, dynamic> userData = {
        'name': name,
        'email': email,
        'profileUrl': profileUrl,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add or update the user data in the Firestore
      await userRef.set(userData, SetOptions(merge: true));
      print('User added successfully');
    } catch (e) {
      print('Error adding user: $e');
    }
  }
}
