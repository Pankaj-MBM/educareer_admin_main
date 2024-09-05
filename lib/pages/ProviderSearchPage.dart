import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class ProviderJobSearchView extends StatefulWidget {
  const ProviderJobSearchView({super.key});

  @override
  _ProviderJobSearchViewState createState() => _ProviderJobSearchViewState();
}

class _ProviderJobSearchViewState extends State<ProviderJobSearchView> {
  final Stream<QuerySnapshot> _requestsStream = FirebaseFirestore.instance
      .collection('approve_job_seeker_request')
      .snapshots();

  Future<void> _approveRequest(String requestId) async {
    try {
      Map<String, dynamic> requestData = await _fetchRequestData(requestId);
      await FirebaseFirestore.instance
          .collection('approve_admin_provider_list')
          .doc(requestId)
          .set(requestData);
      await FirebaseFirestore.instance
          .collection('approve_job_seeker_request')
          .doc(requestId)
          .update({'status': 'approved'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request approved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to approve request: $e")),
      );
    }
  }

  Future<void> _rejectRequest(String requestId) async {
    try {
      Map<String, dynamic> requestData = await _fetchRequestData(requestId);
      await FirebaseFirestore.instance
          .collection('rejected_job_seeker_requests')
          .doc(requestId)
          .set(requestData);
      await FirebaseFirestore.instance
          .collection('approve_job_seeker_request')
          .doc(requestId)
          .update({'status': 'rejected'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request rejected successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to reject request: $e")),
      );
    }
  }

  Future<Map<String, dynamic>> _fetchRequestData(String requestId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('approve_job_seeker_request')
        .doc(requestId)
        .get();
    return doc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<QuerySnapshot>(
        stream: _requestsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No requests to display.'));
          }

          final requests = snapshot.data!.docs;

          return PaginatedDataTable2(

            header: const Text('Job Requests'),
            columns: const [
              DataColumn(label: Text('Sr.No')),
              DataColumn(label: Text('Job Title')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            source: JobRequestsDataSource(
              requests,
              onApprove: _approveRequest,
              onReject: _rejectRequest,
            ),
            columnSpacing: 20,
            horizontalMargin: 10,
            rowsPerPage: 5,
          );
        },
      ),
    );
  }
}

class JobRequestsDataSource extends DataTableSource {
  final List<QueryDocumentSnapshot> requests;
  final Function(String) onApprove;
  final Function(String) onReject;

  JobRequestsDataSource(this.requests,
      {required this.onApprove, required this.onReject});

  @override
  DataRow getRow(int index) {
    final request = requests[index];
    final requestId = request.id;
    final data = request.data() as Map<String, dynamic>;
    final status = data['status'] ?? 'Pending';

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(data['job_title'] ?? 'No Title')),
        DataCell(Text(data['category'] ?? 'N/A')),
        DataCell(Text(
            '${data['city'] ?? 'N/A'}, ${data['state'] ?? 'N/A'}, ${data['country'] ?? 'N/A'}')),
        DataCell(Text(status)),
        DataCell(
          status == 'Pending'
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => onApprove(requestId),
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onReject(requestId),
              ),
            ],
          )
              : Icon(
            status == 'approved' ? Icons.done : Icons.close,
            color: status == 'approved' ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => requests.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount=>0;
}