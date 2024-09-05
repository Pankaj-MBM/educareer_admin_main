import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, int>> getCounts() {
    return CombineLatestStream.list([
      _firestore.collection('students').snapshots(),
      _firestore.collection('job_seekers').snapshots(),
      _firestore.collection('job_providers').snapshots(),
    ]).map((snapshots) {
      final studentsCount = snapshots[0].docs.length;
      final jobSeekersCount = snapshots[1].docs.length;
      final jobProvidersCount = snapshots[2].docs.length;
      final totalUsers = studentsCount + jobSeekersCount + jobProvidersCount;

      print('Updated counts: $studentsCount, $jobSeekersCount, $jobProvidersCount');

      return {
        'students': studentsCount,
        'job_seekers': jobSeekersCount,
        'job_providers': jobProvidersCount,
        'total_users': totalUsers,
      };
    });
  }
}
