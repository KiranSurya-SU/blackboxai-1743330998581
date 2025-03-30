import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alumni_association/services/database_service.dart';
import 'package:intl/intl.dart';

class EventManagement extends StatefulWidget {
  const EventManagement({super.key});

  @override
  State<EventManagement> createState() => _EventManagementState();
}

class _EventManagementState extends State<EventManagement> {
  final DatabaseService _databaseService = DatabaseService();
  Stream<QuerySnapshot>? _eventStream;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

  @override
  void initState() {
    super.initState();
    _eventStream = _databaseService.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No upcoming events.'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final eventDate = (event['date'] as Timestamp).toDate();
              
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(event['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_dateFormat.format(eventDate)),
                      Text(event['location']),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // RSVP to event
                    },
                    child: const Text('RSVP'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}