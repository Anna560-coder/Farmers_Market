import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  Handle user signup
  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'role': role, // role determines if user is admin or user
      });

      return null; // success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "This email is already registered";
      } else if (e.code == 'invalid-email') {
        return "Invalid email format";
      } else if (e.code == 'weak-password') {
        return "Password is too weak (min 6 characters)";
      } else {
        return "Signup failed: ${e.message}";
      }
    } catch (e) {
      return "An unexpected error occurred: ${e.toString()}";
    }
  }

  // Handle user login (with role check)
  Future<String?> login({
    required String email,
    required String password,
    required String role, // add role parameter
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      DocumentSnapshot userDoc = await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        return "User record not found in database";
      }

      String actualRole = userDoc['role'];

      if (actualRole != role) {
        return "Selected role does not match your account role";
      }

      return actualRole; // "Admin" or "User"
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "User not found";
      } else if (e.code == 'wrong-password') {
        return "Incorrect password";
      } else if (e.code == 'invalid-email') {
        return "Invalid email format";
      } else if (e.code == 'user-disabled') {
        return "This account has been disabled";
      } else {
        return "Login failed: ${e.message}";
      }
    } catch (e) {
      return "An unexpected error occurred: ${e.toString()}";
    }
  }

  //Handle user logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
