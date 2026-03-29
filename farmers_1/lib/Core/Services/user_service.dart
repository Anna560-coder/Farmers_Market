import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current authenticated user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Get current user's email
  static String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  /// Get current user's display name
  static String? getCurrentUserDisplayName() {
    return _auth.currentUser?.displayName;
  }

  /// Get current user's UID
  static String? getCurrentUserUID() {
    return _auth.currentUser?.uid;
  }

  /// Get user profile data from Firestore
  static Future<Map<String, dynamic>?> getUserProfileData() async {
    try {
      final user = getCurrentUser();
      if (user == null) return null;

      // Try to get user data from Firestore users collection
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data();
      }

      // If no Firestore data, return basic auth data
      return {
        'email': user.email,
        'displayName': user.displayName,
        'uid': user.uid,
      };
    } catch (e) {
      print('Error getting user profile data: $e');
      return null;
    }
  }

  /// Get user's full name from profile data
  static Future<String?> getUserFullName() async {
    try {
      final profileData = await getUserProfileData();
      if (profileData != null) {
        // Try different possible field names for full name
        return profileData['fullName'] ??
            profileData['name'] ??
            profileData['displayName'] ??
            profileData['firstName'] + ' ' + (profileData['lastName'] ?? '') ??
            getCurrentUserDisplayName();
      }
      return getCurrentUserDisplayName();
    } catch (e) {
      print('Error getting user full name: $e');
      return getCurrentUserDisplayName();
    }
  }

  /// Get user's email from profile data
  static Future<String?> getUserEmail() async {
    try {
      final profileData = await getUserProfileData();
      if (profileData != null) {
        return profileData['email'] ?? getCurrentUserEmail();
      }
      return getCurrentUserEmail();
    } catch (e) {
      print('Error getting user email: $e');
      return getCurrentUserEmail();
    }
  }

  /// Check if user is authenticated
  static bool isUserAuthenticated() {
    return _auth.currentUser != null;
  }

  /// Get user's phone number
  static Future<String?> getUserPhoneNumber() async {
    try {
      final profileData = await getUserProfileData();
      if (profileData != null) {
        return profileData['phoneNumber'] ??
            profileData['phone'] ??
            _auth.currentUser?.phoneNumber;
      }
      return _auth.currentUser?.phoneNumber;
    } catch (e) {
      print('Error getting user phone number: $e');
      return _auth.currentUser?.phoneNumber;
    }
  }
}
