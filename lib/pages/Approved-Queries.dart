import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobApproveSeekerStudentView extends StatefulWidget {
  const JobApproveSeekerStudentView({super.key});

  @override
  _JobApproveSeekerStudentViewState createState() =>
      _JobApproveSeekerStudentViewState();
}

class _JobApproveSeekerStudentViewState
    extends State<JobApproveSeekerStudentView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Approvals'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Admin-approved-List')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading approved requests: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No approved job requests found.'));
                }

                // Filter the data based on the search query
                final filteredRequests = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final jobTitle = data['job_title']?.toLowerCase() ?? '';
                  final userType = data['userType']?.toLowerCase() ?? '';
                  final searchQuery = _searchQuery.toLowerCase();
                  return jobTitle.contains(searchQuery) ||
                      userType.contains(searchQuery);
                }).toList();

                final dataSource = JobRequestsDataTableSource(
                  requests: filteredRequests,
                  onDeleteRequest: _deleteRequest,
                  onConfirmDeletion: _confirmDeletion,
                  context: context,
                );

                return SingleChildScrollView(
                  child: PaginatedDataTable(
                    header: const Text('Approved Job Requests'),
                    columns: const [
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('User Type')),
                      DataColumn(label: Text('Class')),
                      DataColumn(label: Text('Teacher Type')),
                      DataColumn(label: Text('Country')),
                      DataColumn(label: Text('State')),
                      DataColumn(label: Text('City')),
                      DataColumn(label: Text('Salary Range')),
                      DataColumn(label: Text('Approved On')),
                      DataColumn(label: Text('Actions')),
                    ],
                    source: dataSource,
                    rowsPerPage: 10, // Adjust rows per page
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDeletion(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Request'),
        content: const Text('Are you sure you want to delete this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _deleteRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Admin-approved-List')
          .doc(requestId)
          .delete();
    } catch (e) {
      print('Error deleting request: $e');
    }
  }
}

class JobRequestsDataTableSource extends DataTableSource {
  final List<QueryDocumentSnapshot> requests;
  final Future<void> Function(String requestId) onDeleteRequest;
  final Future<bool> Function(BuildContext context) onConfirmDeletion;
  final BuildContext context;

  JobRequestsDataTableSource({
    required this.requests,
    required this.onDeleteRequest,
    required this.onConfirmDeletion,
    required this.context,
  });

  @override
  DataRow getRow(int index) {
    if (index >= requests.length) return DataRow(cells: []);

    var request = requests[index];
    var data = request.data() as Map<String, dynamic>;
    var timestamp = data['timestamp'] as Timestamp?;
    var formattedTimestamp =
    timestamp != null ? '${timestamp.toDate().toLocal()}' : 'Unknown time';

    // Determine background color based on userType
    Color rowColor = data['userType'] == 'Job Seeker'
        ? Colors.lightBlue.shade100
        : Colors.lightGreen.shade100;

    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(Text(data['job_title'] ?? 'N/A')),
        DataCell(Text(data['userType'] ?? 'N/A')),
        DataCell(Text(data['class'] ?? 'N/A')),
        DataCell(Text(data['teacherType'] ?? 'N/A')),
        DataCell(Text(data['country'] ?? 'N/A')),
        DataCell(Text(data['state'] ?? 'N/A')),
        DataCell(Text(data['city'] ?? 'N/A')),
        DataCell(Text(data['salaryRange'] ?? 'N/A')),
        DataCell(Text(formattedTimestamp)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirm = await onConfirmDeletion(context);
              if (confirm) {
                await onDeleteRequest(request.id);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => requests.length;

  @override
  int get selectedRowCount => 0;
}
