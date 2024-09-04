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
          'id': doc.id, // Store document ID for later reference
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
              onPressed: () => _approveRequest(row['id']),
              child: const Text('Approve'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _showRejectConfirmationDialog(row),
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

  void _approveRequest(String requestId) {
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
                  _showJobSeekerList(requestId); // Open list dialog for Job Seekers
                },
              ),
              ListTile(
                title: const Text('Job Provider'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the current dialog
                  _showJobProviderList(requestId); // Open list dialog for Job Providers
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showJobSeekerList(String requestId) async {
    try {
      // Fetch data from the job_search_requests collection
      final snapshot = await FirebaseFirestore.instance
          .collection('approve_job_seeker_request').get();


      final List<Map<String, dynamic>> jobSeekers = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      // Show the fetched data in a dialog
      showDialog(
        context: _context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              List<Map<String, dynamic>> selectedRows = [];

              return AlertDialog(
                title: const Text('Job Seeker Requests'),
                content: jobSeekers.isEmpty
                    ? const Text('No job seeker requests found.')
                    : SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('User Type')),
                      DataColumn(label: Text('City')),
                      DataColumn(label: Text('category')),
                      DataColumn(label: Text('Country')),
                      DataColumn(label: Text('Request ID')),
                      DataColumn(label: Text('Salary Range')),
                      DataColumn(label: Text('State')),
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('job title')),
                      DataColumn(label: Text('Timestamp')),
                    ],
                    rows: jobSeekers.map((jobSeeker) {
                      return DataRow(
                        cells: [
                          DataCell(Text(jobSeeker['userType'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['city'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['category'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['country'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['request_id'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['salaryRange'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['state'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['subject'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['job_title'] ?? 'N/A')),
                          DataCell(Text(jobSeeker['timestamp']?.toDate().toString() ?? 'N/A')),
                        ],
                        selected: selectedRows.contains(jobSeeker),
                        onSelectChanged: (selected) {
                          setState(() {
                            if (selected == true) {
                              selectedRows.add(jobSeeker);
                            } else {
                              selectedRows.remove(jobSeeker);
                            }
                          });
                        },
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
                  ElevatedButton(
                    onPressed: selectedRows.isEmpty
                        ? null
                        : () {
                      _moveToConfirmedCollection(
                          selectedRows); // Move selected rows to confirm-admin-approv collection
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Send'),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print('Error fetching job seeker requests: $e');
    }
  }

  void _showJobProviderList(String requestId) async {
    try {
      // Fetch data from the approved_provider_job_requests collection
      final snapshot = await FirebaseFirestore.instance
          .collection('approved_provider_job_requests')
          .get();

      final List<Map<String, dynamic>> jobProviders = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      // Show the fetched data in a dialog
      showDialog(
        context: _context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              List<Map<String, dynamic>> selectedRows = [];

              return AlertDialog(
                title: const Text('Job Provider Requests'),
                content: jobProviders.isEmpty
                    ? const Text('No job provider requests found.')
                    : SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Select')),
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('City')),
                      DataColumn(label: Text('Job Type')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('User Type')),
                      DataColumn(label: Text('Request ID')),
                    ],
                    rows: jobProviders.map((jobProvider) {
                      bool isSelected = selectedRows.contains(jobProvider);
                      return DataRow(
                        selected: isSelected,
                        onSelectChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedRows.add(jobProvider);
                            } else {
                              selectedRows.remove(jobProvider);
                            }
                          });
                        },
                        cells: [
                          DataCell(
                            Checkbox(
                              value: isSelected,
                              onChanged: (bool? selected) {
                                setState(() {
                                  if (selected == true) {
                                    selectedRows.add(jobProvider);
                                  } else {
                                    selectedRows.remove(jobProvider);
                                  }
                                });
                              },
                            ),
                          ),
                          DataCell(Text(jobProvider['title'] ?? 'N/A')),
                          DataCell(Text(jobProvider['category'] ?? 'N/A')),
                          DataCell(Text(jobProvider['city'] ?? 'N/A')),
                          DataCell(Text(jobProvider['jobType'] ?? 'N/A')),
                          DataCell(Text(jobProvider['status'] ?? 'N/A')),
                          DataCell(Text(jobProvider['userType'] ?? 'N/A')),
                          DataCell(Text(jobProvider['request_id'] ?? 'N/A')),
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
                  ElevatedButton(
                    onPressed: selectedRows.isEmpty
                        ? null
                        : () async {
                      await _moveToConfirmedCollection(selectedRows); // Move selected rows to confirm-admin-approved collection
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Send'),
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


  Future<void> _moveToConfirmedCollection(
      List<Map<String, dynamic>> selectedRows) async {
    try {
      for (var row in selectedRows) {
        // Remove 'id' from row as Firestore auto-generates IDs
        Map<String, dynamic> dataToSave = Map<String, dynamic>.from(row);
        dataToSave.remove('id');

        // Save to the confirm-admin-approved collection
        await FirebaseFirestore.instance
            .collection('confirm-admin-approved')
            .add(dataToSave);
      }

      print('Selected rows moved to confirm-admin-approved collection.');
    } catch (e) {
      print('Error moving to confirm-admin-approved collection: $e');
    }
  }



  // Future<void> _moveToConfirmedCollection(List<Map<String, dynamic>> selectedRows) async {
  //   try {
  //     final batch = FirebaseFirestore.instance.batch();
  //
  //     for (var row in selectedRows) {
  //       // Add each selected row to the confirm-admin-approved collection
  //       final docRef = FirebaseFirestore.instance.collection('confirm-admin-approved').doc(row['id']);
  //       batch.set(docRef, row);
  //     }
  //
  //     await batch.commit();
  //   } catch (e) {
  //     print('Error moving to confirm-admin-approved collection: $e');
  //   }
  // }



  // void _moveToConfirmedCollection(List<Map<String, dynamic>> selectedRows) async {
  //   try {
  //     final batch = FirebaseFirestore.instance.batch();
  //
  //     for (var row in selectedRows) {
  //       final docRef = FirebaseFirestore.instance
  //           .collection('confirm-admin-approv')
  //           .doc(row['id']);
  //       batch.set(docRef, row); // Copy selected row data to confirm-admin-approv collection
  //     }
  //
  //     await batch.commit();
  //     print('Data moved to confirm-admin-approv collection successfully.');
  //   } catch (e) {
  //     print('Error moving data to confirm-admin-approv collection: $e');
  //   }
  // }

  @override
  int get rowCount => filteredData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  void _showRejectConfirmationDialog(Map<String, dynamic> row) {
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reject Request'),
          content: const Text('Are you sure you want to reject this request?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _rejectRequest(row['id']);
                Navigator.of(context).pop();
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  void _rejectRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('student_job_requests')
          .doc(requestId)
          .update({'status': 'Rejected'});

      print('Request rejected successfully.');
      fetchData(); // Refresh the table after rejection
    } catch (e) {
      print('Error rejecting request: $e');
    }
  }
}
