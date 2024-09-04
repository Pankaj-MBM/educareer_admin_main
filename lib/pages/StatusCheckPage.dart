import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatusCheckView extends StatefulWidget {
  const StatusCheckView({super.key});

  @override
  _StatusCheckViewState createState() => _StatusCheckViewState();
}

class _StatusCheckViewState extends State<StatusCheckView> {
  // Track the status of each request to update UI dynamically
  final Map<String, bool> _approvedRequests = {};
  Future<void> _approveRequest(
      String requestId, Map<String, dynamic> searchDetails) async {
    try {
      // Update the status of the request to 'Approved' in job_search_requests
      await FirebaseFirestore.instance
          .collection('job_search_requests')
          .doc(requestId)
          .update({
        'status': 'Approved',
      });

      // Show Snackbar for successful approval
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request approved successfully.')),
      );

      // Update local state to reflect approval
      setState(() {
        _approvedRequests[requestId] = true;
      });
    } catch (e) {
      print('Error approving request: $e');
    }
  }

  Future<void> _rejectRequest(String requestId) async {
    try {
      // Delete the request from Firestore when it is rejected
      await FirebaseFirestore.instance
          .collection('job_search_requests')
          .doc(requestId)
          .delete();

      // Show Snackbar for successful rejection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request rejected successfully.')),
      );

      // Update the UI by removing the rejected request from the local state
      setState(() {
        _approvedRequests.remove(requestId); // Also remove from approved list
      });
    } catch (e) {
      print('Error rejecting request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel - Job Search Requests'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('job_search_requests')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var requests = snapshot.data!.docs;

              if (requests.isEmpty) {
                return const Center(child: Text('No job search requests found.'));
              }

              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  var request = requests[index];
                  var requestId = request.id;
                  var searchDetails =
                  request['searchDetails'] as Map<String, dynamic>;

                  // Check if this request has been approved
                  bool isApproved = _approvedRequests[requestId] ?? false;

                  return Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Job Title: ${searchDetails['keywords'] ?? 'N/A'}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Category: ${searchDetails['category'] ?? 'N/A'}'),
                          Text('City: ${searchDetails['city'] ?? 'N/A'}'),
                          Text('State: ${searchDetails['state'] ?? 'N/A'}'),
                          Text('Country: ${searchDetails['country'] ?? 'N/A'}'),
                          Text('Job Type: ${searchDetails['jobType'] ?? 'N/A'}'),
                          Text(
                              'Experience Level: ${searchDetails['experienceLevel'] ?? 'N/A'}'),
                          Text(
                              'Salary Range: ${searchDetails['salaryRange'] ?? 'N/A'}'),
                          Text('Status: ${request['status'] ?? 'Pending'}'),
                          Text(
                              'Submitted On: ${request['timestamp'] != null ? (request['timestamp'] as Timestamp).toDate().toString() : 'N/A'}'),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              isApproved
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : ElevatedButton(
                                onPressed: () =>
                                    _approveRequest(requestId, searchDetails),
                                child: const Text('Approve'),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => _rejectRequest(requestId),
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