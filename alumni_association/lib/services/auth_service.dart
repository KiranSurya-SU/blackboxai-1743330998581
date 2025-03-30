import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password, {
    required bool isAlumni,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Verify user role matches
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
          
      if (userDoc.exists && userDoc['isAlumni'] != isAlumni) {
        await _auth.signOut();
        throw Exception('Account type mismatch. Please select correct role.');
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password, {
    required String name,
    required String graduationYear,
    required String department,
    required bool isAlumni,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user info to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
            'uid': userCredential.user?.uid,
            'email': email,
            'name': name,
            'graduationYear': graduationYear,
            'department': department,
            'isAlumni': isAlumni,
            'createdAt': FieldValue.serverTimestamp(),
          });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Stream of user authentication state
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
}