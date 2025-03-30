import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alumni_association/services/database_service.dart';

class JobPortal extends StatefulWidget {
  const JobPortal({super.key});

  @override
  State<JobPortal> createState() => _JobPortalState();
}

class _JobPortalState extends State<JobPortal> {
  final DatabaseService _databaseService = DatabaseService();
  Stream<QuerySnapshot>? _jobStream;

  @override
  void initState() {
    super.initState();
    _jobStream = _databaseService.getJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Portal'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _jobStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No job listings available.'));
          }

          final jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(job['title']),
                  subtitle: Text('${job['company']} - ${job['location']}'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigate to job details screen
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}