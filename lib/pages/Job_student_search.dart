import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class JobSearchStudentView extends StatefulWidget {
  const JobSearchStudentView({super.key});

  @override
  _JobSearchStudentViewState createState() => _JobSearchStudentViewState();
}

class _JobSearchStudentViewState extends State<JobSearchStudentView> {
  final MyData _myData = MyData();

  @override
  void initState() {
    super.initState();
    _myData.setContext(context); // Set context for MyData
    _myData.fetchData().then((_) {
      setState(() {}); // Trigger a rebuild after data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Job Requests'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SizedBox(
                width: 200,
                child: TextField(
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
            DataColumn(label: Text('User Type')),
            DataColumn(label: Text('Subject')),
            DataColumn(label: Text('Class')),
            DataColumn(label: Text('Teacher Type')),
            DataColumn(label: Text('State')),
            DataColumn(label: Text('City')),
            DataColumn(label: Text('Actions')),
          ],
          columnSpacing: 5,
          horizontalMargin: 5,
          rowsPerPage: 10,
          availableRowsPerPage: const [5, 10, 20],
          onRowsPerPageChanged: (rowsPerPage) {
            setState(() {
              // Trigger a rebuild on rows per page change
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
  late List<Map<String, dynamic>> filteredData;
  late BuildContext _context; // Store context here

  MyData() {
    filteredData = List.from(data);
  }

  void setContext(BuildContext context) {
    _context = context; // Set context when available
  }

  Future<void> fetchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('approved_student_job_requests')
          .get();
      final List<Map<String, dynamic>> fetchedData = snapshot.docs.map((doc) {
        return {
          'student_id': doc.id, // Store document ID as student_id
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      data = fetchedData;
      filteredData = List.from(data);
      notifyListeners(); // Notify listeners after fetching data
    } catch (e) {
      print('Error fetching data: $e'); // Debugging line
    }
  }

  void filterData(String query) {
    if (query.isEmpty) {
      filteredData = List.from(data);
    } else {
      filteredData = data
          .where((row) =>
          row.values.any((value) => value.toString().contains(query)))
          .toList();
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= filteredData.length) return null;

    final row = filteredData[index];

    return DataRow(cells: [
      DataCell(Text(row['userType'] ?? 'N/A')),
      DataCell(Text(row['subject'] ?? 'N/A')),
      DataCell(Text(row['class'] ?? 'N/A')),
      DataCell(Text(row['teacherType'] ?? 'N/A')),
      DataCell(Text(row['state'] ?? 'N/A')),
      DataCell(Text(row['city'] ?? 'N/A')),
      DataCell(
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _approveRequest(row['student_id']),
              child: const Text('Approve'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _showRejectConfirmationDialog(row['student_id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Reject'),
            ),
          ],
        ),
      ),
    ]);
  }

  void _approveRequest(String studentId) async {
    try {
      // Fetch the student request data from 'approved_student_job_requests'
      final studentSnapshot = await FirebaseFirestore.instance
          .collection('approved_student_job_requests')
          .doc(studentId)
          .get();

      if (!studentSnapshot.exists) {
        print('Student request not found');
        return;
      }

      final studentData = studentSnapshot.data() as Map<String, dynamic>;

      showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select User Type'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Job Seeker'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the current dialog
                    _showJobSeekerList(studentId, studentData); // Pass student data
                  },
                ),
                ListTile(
                  title: const Text('Job Provider'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the current dialog
                    _showJobProviderList(studentId, studentData); // Pass student data
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print('Error fetching student data: $e');
    }
  }

  void _showJobSeekerList(String studentId, Map<String, dynamic> studentData) async {
    try {
      // Fetch job seeker requests
      final snapshot = await FirebaseFirestore.instance
          .collection('approve_job_seeker_request')
          .where('status', isEqualTo: 'approved') // Filter by status 'approved'
          .get();

      final List<Map<String, dynamic>> jobSeekers = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...?doc.data() as Map<String, dynamic>?,
        };
      }).toList();

      List<Map<String, dynamic>> selectedJobSeekers = [];

      showDialog(
        context: _context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Job Seeker Requests'),
                content: jobSeekers.isEmpty
                    ? const Text('No job seeker requests found.')
                    : SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('User Type')),
                      DataColumn(label: Text('City')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Country')),
                      DataColumn(label: Text('State')),
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('Job Title')),
                      DataColumn(label: Text('Timestamp')),
                    ],
                    rows: jobSeekers.map((jobSeeker) {
                      final isSelected = selectedJobSeekers.contains(jobSeeker);
                      return DataRow(
                        selected: isSelected,
                        onSelectChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedJobSeekers.add(jobSeeker);
                            } else {
                              selectedJobSeekers.remove(jobSeeker);
                            }
                          });
                        },
                        cells: [
                          DataCell(Text(jobSeeker['userType'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['city'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['category'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['country'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['state'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['subject'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['job_title'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['timestamp']?.toDate().toString() ?? 'N/A')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Close'),
                  ),
                  if (selectedJobSeekers.isNotEmpty)
                    TextButton(
                      onPressed: () async {
                        // Show confirmation dialog before saving
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Selection'),
                              content: const Text('Are you sure you want to approve the selected job seekers?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close confirmation dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      // Save selected job seekers to Admin-approved-List
                                      for (var jobSeeker in selectedJobSeekers) {
                                        await FirebaseFirestore.instance
                                            .collection('Admin-approved-List')
                                            .doc() // Use a new auto-generated document ID
                                            .set({
                                          'student_id': studentId,
                                          'student_data': studentData, // Add student data
                                          ...jobSeeker,
                                        });
                                      }

                                      Navigator.of(context).pop(); // Close confirmation dialog
                                      Navigator.of(_context).pop(); // Close the original dialog
                                      ScaffoldMessenger.of(_context).showSnackBar(
                                        const SnackBar(content: Text('Approved successfully!')),
                                      );
                                    } catch (e) {
                                      print('Error approving job seekers: $e');
                                    }
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Approve'),
                    ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print('Error fetching job seekers: $e');
    }
  }

  void _showJobProviderList(String requestId, Map<String, dynamic> studentData) async {
    try {
      // Fetch job provider requests
      final snapshot = await FirebaseFirestore.instance
          .collection('approved_provider_job_requests')
          .where('status', isEqualTo: 'Approved') // Filter by status 'approved'
          .get();

      final List<Map<String, dynamic>> jobProviders = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...?doc.data() as Map<String, dynamic>?,
        };
      }).toList();

      List<Map<String, dynamic>> selectedJobProviders = [];

      showDialog(
        context: _context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Job Provider Requests'),
                content: jobProviders.isEmpty
                    ? const Text('No job provider requests found.')
                    : SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('City')),
                      DataColumn(label: Text('JobType')),
                      DataColumn(label: Text('Status')),
                    //  DataColumn(label: Text('Posted At')),
                    ],
                    rows: jobProviders.map((jobProvider) {
                      final isSelected = selectedJobProviders.contains(jobProvider);
                      return DataRow(
                        selected: isSelected,
                        onSelectChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedJobProviders.add(jobProvider);
                            } else {
                              selectedJobProviders.remove(jobProvider);
                            }
                          });
                        },
                        cells: [
                          DataCell(Text(jobProvider['title'] ?? 'N/A')),
                          DataCell(Text(jobProvider['category'] ?? 'N/A')),
                          DataCell(Text(jobProvider['city'] ?? 'N/A')),
                          DataCell(Text(jobProvider['jobType'] ?? 'N/A')),
                          DataCell(Text(jobProvider['status'] ?? 'N/A')),
                        //  DataCell(Text(jobProvider['posted_at']?.toDate().toString() ?? 'N/A')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Close'),
                  ),
                  if (selectedJobProviders.isNotEmpty)
                    TextButton(
                      onPressed: () async {
                        // Show confirmation dialog before saving
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Selection'),
                              content: const Text('Are you sure you want to approve the selected job providers?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close confirmation dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      // Save selected job providers to Admin-approved-List
                                      for (var jobProvider in selectedJobProviders) {
                                        await FirebaseFirestore.instance
                                            .collection('Admin-approved-List')
                                            .add({
                                          'student_id': requestId,
                                          'student_data': studentData, // Add student data
                                          ...jobProvider,
                                        });

                                        // Optionally delete the document from the original collection
                                        await FirebaseFirestore.instance
                                            .collection('approved_provider_job_requests')
                                            .doc(jobProvider['id'])
                                            .delete();
                                      }

                                      Navigator.of(context).pop(); // Close confirmation dialog
                                      Navigator.of(_context).pop(); // Close the original dialog
                                      ScaffoldMessenger.of(_context).showSnackBar(
                                        const SnackBar(content: Text('Approved successfully!')),
                                      );
                                    } catch (e) {
                                      print('Error approving job providers: $e');
                                    }
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Select'),
                    ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print('Error fetching job provider requests: $e');
    }
  }

  Future<void> _showRejectConfirmationDialog(String requestId) async {
    // Fetch the document data before deleting
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('approved_student_job_requests')
        .doc(requestId)
        .get();

    // Extract the data from the document
    Map<String, dynamic>? documentData = documentSnapshot.data() as Map<String, dynamic>?;

    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reject Request'),
            content: const Text('Are you sure you want to reject this request?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    if (documentData != null) {
                      // Move the document to the 'admin-reject-queries' collection
                      await FirebaseFirestore.instance
                          .collection('admin-reject-queries')
                          .doc(requestId)
                          .set(documentData);

                      // Remove the document from the 'approved_student_job_requests' collection
                      await FirebaseFirestore.instance
                          .collection('approved_student_job_requests')
                          .doc(requestId)
                          .delete();

                      // Show confirmation SnackBar
                      ScaffoldMessenger.of(_context).showSnackBar(
                        SnackBar(
                          content: const Text('Request rejected'),
                          backgroundColor: Colors.green, // Green color for success
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  } catch (e) {
                    print('Error rejecting request: $e'); // Debugging line
                  }
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Reject'),
              ),
            ],
          );
          },
        );
    }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredData.length;

  @override
  int get selectedRowCount => 0;
}
