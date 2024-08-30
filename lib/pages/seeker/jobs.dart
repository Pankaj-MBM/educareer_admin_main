import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<Map<String, dynamic>>> _jobStream;
  List<Map<String, dynamic>> _filteredJobs = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _jobStream = _firestore.collection('add_new_job').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id, // Store document ID for delete functionality
            'company_name': data['company_name'] ?? '',
            'experience': data['experience'] ?? '',
            'job_category': data['job_category'] ?? '',
            'job_description': data['job_description'] ?? '',
            'job_position': data['job_position'] ?? '',
            'job_title': data['job_title'] ?? '',
            'job_type': data['job_type'] ?? '',
            'location': data['location'] ?? '',
            'posted_at': _formatTimestamp(data['posted_at']), // Convert Timestamp to String
            'qualification': data['qualification'] ?? '',
            'salary_range': data['salary_range'] ?? '',
          };
        }).toList();
      },
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    return DateFormat('dd-MM-yy').format(timestamp.toDate());
  }

  void _searchJobs(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _searchJobs,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _jobStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final jobs = snapshot.data ?? [];
                  _filteredJobs = jobs.where((job) {
                    return job.values.any((value) =>
                        value.toString().toLowerCase().contains(_searchQuery));
                  }).toList();

                  return PaginatedDataTable2(
                    source: MyJobData(_filteredJobs, _firestore),
                    columns: const [
                      DataColumn(label: Text('Company Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(label: Text('Job Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(label: Text('Job Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(label: Text('Experience', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(label: Text('Job Position', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(label: Text('Job Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(label: Text('Posted At', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(label: Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(label: Text('Qualification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(label: Text('Salary Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                    ],
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    rowsPerPage: 10,
                    availableRowsPerPage: const [5, 10, 20],
                    onRowsPerPageChanged: (rowsPerPage) {
                      setState(() {});
                    },
                    showCheckboxColumn: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyJobData extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final FirebaseFirestore firestore;

  MyJobData(this.data, this.firestore);

  @override
  DataRow? getRow(int index) {
    final row = data[index];
    return DataRow(cells: [
      DataCell(Text(row['company_name'])),
      DataCell(Text(row['job_title'])),
      DataCell(Text(row['job_category'])),
      DataCell(Text(row['experience'])),
      DataCell(Text(row['job_position'])),
      DataCell(Text(row['job_description'])),
      DataCell(Text(row['posted_at'])),
      DataCell(Text(row['location'])),
      DataCell(Text(row['qualification'])),
      DataCell(Text(row['salary_range'])),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Add edit functionality here
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.deepOrangeAccent),
              onPressed: () {
                _deleteJob(row['id']);
              },
            ),
          ],
        ),
      ),
    ]);
  }

  void _deleteJob(String jobId) {
    firestore.collection('add_new_job').doc(jobId).delete();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
