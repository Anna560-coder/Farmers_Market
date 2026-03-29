import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmers_1/Core/Models/farm_profile.dart';

class FarmProfileService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _collection = 'farmProfiles';

  static Future<FarmProfile?> getCurrentUserFarmProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      return FarmProfile.fromMap(doc.data(), doc.id);
    } catch (e) {
      throw Exception('Failed to get farm profile: $e');
    }
  }

  static Future<String> createFarmProfile(FarmProfile farmProfile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final now = DateTime.now();
      final farmProfileWithTimestamps = farmProfile.copyWith(
        userId: user.uid,
        createdAt: now,
        updatedAt: now,
      );

      final docRef = await _firestore
          .collection(_collection)
          .add(farmProfileWithTimestamps.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create farm profile: $e');
    }
  }

  static Future<void> updateFarmProfile(FarmProfile farmProfile) async {
    try {
      if (farmProfile.id == null) {
        throw Exception('Farm profile ID is required for update');
      }

      final updatedProfile = farmProfile.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection(_collection)
          .doc(farmProfile.id)
          .update(updatedProfile.toMap());
    } catch (e) {
      throw Exception('Failed to update farm profile: $e');
    }
  }

  static Future<void> deleteFarmProfile(String farmProfileId) async {
    try {
      await _firestore.collection(_collection).doc(farmProfileId).delete();
    } catch (e) {
      throw Exception('Failed to delete farm profile: $e');
    }
  }

  static Future<bool> hasFarmProfile() async {
    try {
      final profile = await getCurrentUserFarmProfile();
      return profile != null;
    } catch (e) {
      return false;
    }
  }

  static Future<FarmProfile?> getFarmProfileById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      return FarmProfile.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get farm profile by ID: $e');
    }
  }

  static Stream<FarmProfile?> streamCurrentUserFarmProfile() {
    try {
      final user = _auth.currentUser;
      if (user == null) return Stream.value(null);

      return _firestore
          .collection(_collection)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .snapshots()
          .map((snapshot) {
            if (snapshot.docs.isEmpty) return null;
            final doc = snapshot.docs.first;
            return FarmProfile.fromMap(doc.data(), doc.id);
          });
    } catch (e) {
      return Stream.error(Exception('Failed to stream farm profile: $e'));
    }
  }

  static String? validateFarmProfile(FarmProfile farmProfile) {
    if (farmProfile.farmName.trim().isEmpty) {
      return 'Farm name is required';
    }
    if (farmProfile.location.trim().isEmpty) {
      return 'Location is required';
    }
    if (farmProfile.size.trim().isEmpty) {
      return 'Farm size is required';
    }
    if (farmProfile.ownerName.trim().isEmpty) {
      return 'Owner name is required';
    }
    if (farmProfile.email.trim().isEmpty) {
      return 'Email is required';
    }
    if (farmProfile.phone.trim().isEmpty) {
      return 'Phone number is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(farmProfile.email)) {
      return 'Please enter a valid email address';
    }

    final phoneRegex = RegExp(r'^[\+]?[0-9\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(farmProfile.phone)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }
}
