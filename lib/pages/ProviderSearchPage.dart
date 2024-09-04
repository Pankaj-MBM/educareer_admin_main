import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderSearchView extends StatefulWidget {
  const ProviderSearchView({Key? key}) : super(key: key);

  @override
  _ProviderSearchViewState createState() => _ProviderSearchViewState();
}

class _ProviderSearchViewState extends State<ProviderSearchView> {
  final CollectionReference jobRequests =
  FirebaseFirestore.instance.collection('job_requests');

  void _approveJobRequest(DocumentSnapshot doc) async {
    await jobRequests.doc(doc.id).update({'status': 'approved'});

    // Send job details to job seekers' history collection
    await FirebaseFirestore.instance.collection('job_seekers_history').add({
      'title': doc['title'],
      'category': doc['category'],
      'city': doc['city'],
      'jobType': doc['jobType'],
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Job request approved and sent to job seekers.')),
    );
  }

  void _rejectJobRequest(DocumentSnapshot doc) async {
    await jobRequests.doc(doc.id).update({'status': 'rejected'});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job request rejected.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: jobRequests
                .where('status', whereIn: ['pending', 'approved']).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final Map<String, dynamic> searchDetails =
                  doc.data()! as Map<String, dynamic>;
                  final bool isApproved = searchDetails['status'] == 'approved';

                  return Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Job Title: ${searchDetails['title'] ?? 'N/A'}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Category: ${searchDetails['category'] ?? 'N/A'}'),
                          Text('City: ${searchDetails['city'] ?? 'N/A'}'),
                          Text('Job Type: ${searchDetails['jobType'] ?? 'N/A'}'),
                          Text(
                              'Submitted On: ${searchDetails['timestamp'] != null ? (searchDetails['timestamp'] as Timestamp).toDate().toString() : 'N/A'}'),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              isApproved
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : ElevatedButton(
                                onPressed: () => _approveJobRequest(doc),
                                child: const Text('Approve'),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => _rejectJobRequest(doc),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Reject'),
                              ),
                            ],
                          ),
                        ],
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