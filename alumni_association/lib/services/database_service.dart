import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user data
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  // Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  // Get all jobs
  Stream<QuerySnapshot> getJobs() {
    return _firestore
        .collection('jobs')
        .orderBy('postedAt', descending: true)
        .snapshots();
  }

  // Post a new job
  Future<void> postJob({
    required String title,
    required String company,
    required String description,
    required String location,
    required String postedBy,
  }) async {
    await _firestore.collection('jobs').add({
      'title': title,
      'company': company,
      'description': description,
      'location': location,
      'postedBy': postedBy,
      'postedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all events
  Stream<QuerySnapshot> getEvents() {
    return _firestore
        .collection('events')
        .orderBy('date', descending: false)
        .where('date', isGreaterThan: DateTime.now())
        .snapshots();
  }

  // Create new event
  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required String organizer,
  }) async {
    await _firestore.collection('events').add({
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'organizer': organizer,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // RSVP to event
  Future<void> rsvpToEvent(String eventId, String userId) async {
    await _firestore
        .collection('events')
        .doc(eventId)
        .collection('attendees')
        .doc(userId)
        .set({
      'userId': userId,
      'rsvpAt': FieldValue.serverTimestamp(),
    });
  }

  // Make donation
  Future<void> makeDonation({
    required String donorId,
    required double amount,
    required String purpose,
  }) async {
    await _firestore.collection('donations').add({
      'donorId': donorId,
      'amount': amount,
      'purpose': purpose,
      'donatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Chat functionality
  Stream<QuerySnapshot> getChatMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    await _firestore.collection('messages').add({
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}