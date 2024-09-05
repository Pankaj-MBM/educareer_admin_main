import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class SeekerJobSearchView extends StatefulWidget {
  const SeekerJobSearchView({super.key});

  @override
  _SeekerJobSearchViewState createState() => _SeekerJobSearchViewState();
}

class _SeekerJobSearchViewState extends State<SeekerJobSearchView> {
  Future<void> _approveRequest(
      String requestId, Map<String, dynamic> requestDetails) async {
    try {
      await FirebaseFirestore.instance
          .collection('approved_provider_job_requests')
          .doc(requestId)
          .update({
        'status': 'Approved',
      });

      await FirebaseFirestore.instance.collection('job_seekers_history').add({
        ...requestDetails,
        'status': 'Approved',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request approved successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving request: $e')),
      );
    }
  }

  Future<void> _rejectRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('approved_provider_job_requests')
          .doc(requestId)
          .update({
        'status': 'Rejected',
      });

      await FirebaseFirestore.instance
          .collection('approved_provider_job_requests')
          .doc(requestId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request rejected successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('approved_provider_job_requests')
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

          return FractionallySizedBox(
            widthFactor: 1,
            child: DataTable2(
              columnSpacing: 12,
              minWidth: 600,
              columns: [
                DataColumn2(label: Text('Job Title'), size: ColumnSize.L),
                DataColumn2(label: Text('Category'), size: ColumnSize.L),
                DataColumn2(label: Text('City'), size: ColumnSize.L),
                DataColumn2(label: Text('Job Type'), size: ColumnSize.L),
                DataColumn2(label: Text('Status'), size: ColumnSize.S),
                DataColumn2(label: Text('Actions'), size: ColumnSize.S),
              ],
              rows: List.generate(
                requests.length,
                    (index) {
                  var request = requests[index];
                  var requestId = request.id;
                  var requestDetails = request.data() as Map<String, dynamic>;

                  bool isApproved = requestDetails['status'] == 'Approved';
                  bool isRejected = requestDetails['status'] == 'Rejected';

                  return DataRow(
                    cells: [
                      DataCell(Text(requestDetails['title'] ?? 'N/A')),
                      DataCell(Text(requestDetails['category'] ?? 'N/A')),
                      DataCell(Text(requestDetails['city'] ?? 'N/A')),
                      DataCell(Text(requestDetails['jobType'] ?? 'N/A')),
                      DataCell(Text(requestDetails['status'] ?? 'Pending')),
                      DataCell(Row(
                        children: [
                          if (!isApproved)
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _approveRequest(requestId, requestDetails),
                            ),
                          if (!isRejected)
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _rejectRequest(requestId),
                            ),
                        ],
                      )),
                    ],
                    color: MaterialStateProperty.all(
                      requestDetails['status'] == 'Approved'
                          ? Colors.green.shade50
                          : requestDetails['status'] == 'Rejected'
                          ? Colors.red.shade50
                          : Colors.white,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
