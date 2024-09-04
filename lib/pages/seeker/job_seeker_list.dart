import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JobSeekerList(),
    );
  }
}

class JobSeekerList extends StatefulWidget {
  const JobSeekerList({super.key});

  @override
  _JobSeekerListState createState() => _JobSeekerListState();
}

class _JobSeekerListState extends State<JobSeekerList> {
  late MyData _myData;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _myData = MyData(context); // Pass the context here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Seeker List'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SizedBox(
                width: 200,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                  ),
                  onChanged: (query) {
                    setState(() {
                      _myData.filterData(query);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: PaginatedDataTable2(
          source: _myData,
          columns: const [
            DataColumn(label: Text('No')),
            DataColumn(label: Text('First Name')),
            DataColumn(label: Text('Middle Name')),
            DataColumn(label: Text('Last Name')),
            DataColumn(label: Text('Mobile No')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Gender')),
            DataColumn(label: Text('Actions')), // Add Actions Column
          ],
          columnSpacing: 5,
          horizontalMargin: 5,
          rowsPerPage: 5, // Test with a lower number
          availableRowsPerPage: const [5, 10, 20],
          onRowsPerPageChanged: (rowsPerPage) {
            setState(() {
              _myData.notifyListeners();
            });
          },
          showCheckboxColumn: false,
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];
  final BuildContext context;

  MyData(this.context) {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('job_seekers').get();
      data = snapshot.docs.map((doc) {
        print('Document Data: ${doc.data()}'); // Debug print
        return {
          'firstName': doc['firstName'] ?? '',
          'middleName': doc['middleName'] ?? '',
          'lastName': doc['lastName'] ?? '',
          'mobNo': doc['mobNo'] ?? '',
          'email': doc['email'] ?? '',
          'gender': doc['gender'] ?? '',
          'id': doc.id,
          'education': doc['education'] ?? [],
          'skills': doc['skills'] ?? [],
          'experience': doc['experience'] ?? [],
          'documents': doc['documents'] ?? [],
        };
      }).toList();

      filteredData = List.from(data);
      print('Fetched Data: $data'); // Debug print
      notifyListeners();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void filterData(String query) {
    if (query.isEmpty) {
      filteredData = List.from(data);
    } else {
      filteredData = data
          .where((row) => row.values.any((value) => value.toString().contains(query)))
          .toList();
    }
    print('Filtered data: $filteredData'); // Debug print
    notifyListeners();
  }

  void _confirmDelete(Map<String, dynamic> row) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this job seeker?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _delete(row);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _delete(Map<String, dynamic> row) {
    FirebaseFirestore.instance.collection('job_seekers').doc(row['id']).delete().then((_) {
      fetchData(); // Refresh the data after deletion
    });
  }

  void _view(Map<String, dynamic> row) {
    final educationData = row['education'] as List<dynamic>? ?? [];
    final skillsData = row['skills'] as List<dynamic>? ?? [];
    final documentsData = row['documents'] as List<dynamic>? ?? [];

    // Find the latest document based on a 'date' field (e.g., 'createdAt')
    final latestDocument = documentsData.isNotEmpty
        ? documentsData.reduce((a, b) {
      final dateA = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime(1970);
      final dateB = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime(1970);
      return dateA.isAfter(dateB) ? a : b;
    })
        : null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Job Seeker Details'),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Personal Information:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('First Name: ${row['firstName'] ?? 'N/A'}'),
                Text('Middle Name: ${row['middleName'] ?? 'N/A'}'),
                Text('Last Name: ${row['lastName'] ?? 'N/A'}'),
                Text('Email: ${row['email'] ?? 'N/A'}'),
                Text('Mobile No: ${row['mobNo'] ?? 'N/A'}'),
                Text('Gender: ${row['gender'] ?? 'N/A'}'),
                SizedBox(height: 10),

                // Education Section as DataTable
                Text('Education:', style: TextStyle(fontWeight: FontWeight.bold)),
                educationData.isNotEmpty
                    ? DataTable(
                  columns: const [
                    DataColumn(label: Text('Degree')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Level of Education')),
                    DataColumn(label: Text('Start Date')),
                    DataColumn(label: Text('End Date')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: educationData.map<DataRow>((edu) {
                    return DataRow(
                      cells: [
                        DataCell(Text(edu['degree'] ?? 'N/A')),
                        DataCell(Text(edu['name'] ?? 'N/A')),
                        DataCell(Text(edu['level_of_education'] ?? 'N/A')),
                        DataCell(Text(edu['start_date'] ?? 'N/A')),
                        DataCell(Text(edu['end_date'] ?? 'N/A')),
                        DataCell(Text(edu['status'] ?? 'N/A')),
                      ],
                    );
                  }).toList(),
                )
                    : Text('No education data available'),
                SizedBox(height: 10),

                // Skills Section as DataTable
                Text('Skills:', style: TextStyle(fontWeight: FontWeight.bold)),
                skillsData.isNotEmpty
                    ? DataTable(
                  columns: const [
                    DataColumn(label: Text('Level')),
                    DataColumn(label: Text('Title')),
                  ],
                  rows: skillsData.map<DataRow>((skill) {
                    return DataRow(
                      cells: [
                        DataCell(Text(skill['level'] ?? 'N/A')),
                        DataCell(Text(skill['title'] ?? 'N/A')),
                      ],
                    );
                  }).toList(),
                )
                    : Text('No skills data available'),
                SizedBox(height: 10),

                // Documents Section as DataTable with only the latest document
                Text('Documents:', style: TextStyle(fontWeight: FontWeight.bold)),
                latestDocument != null
                    ? DataTable(
                  columns: const [
                    DataColumn(label: Text('Document Type')),
                    DataColumn(label: Text('Document URL')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text(latestDocument['fileType'] ?? 'N/A')),
                        DataCell(Text(latestDocument['filePath'] ?? 'N/A')),
                      ],
                    ),
                  ],
                )
                    : Text('No documents available'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }




  @override
  DataRow getRow(int index) {
    final row = filteredData[index];
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(row['firstName'] ?? 'N/A')),
        DataCell(Text(row['middleName'] ?? 'N/A')),
        DataCell(Text(row['lastName'] ?? 'N/A')),
        DataCell(Text(row['mobNo'] ?? 'N/A')),
        DataCell(Text(row['email'] ?? 'N/A')),
        DataCell(Text(row['gender'] ?? 'N/A')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.visibility),
                onPressed: () => _view(row),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _confirmDelete(row),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredData.length;

  @override
  int get selectedRowCount => 0;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
