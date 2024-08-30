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
  final MyData _myData = MyData();
  final TextEditingController _controller = TextEditingController();

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
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Mobile No')),
            DataColumn(label: Text('Gender')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Age'), numeric: true),
            DataColumn(label: Text('DOB')),
            DataColumn(label: Text('Password')),
            DataColumn(label: Text('Address')),
            DataColumn(label: Text('Actions')),  // Add Actions Column
          ],
          columnSpacing: 12,
          horizontalMargin: 12,
          rowsPerPage: 10,
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

  MyData() {
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('job_seekers').get();

    data = snapshot.docs.map((doc) {
      return {
        'name': doc['name'] ?? '',
        'mobNo': doc['mobNo'] ?? '',
        'gender': doc['gender'] ?? '',
        'email': doc['email'] ?? '',
        'age': doc['age'] ?? '',
        'dob': doc['dob'] ?? '',
        'password': doc['password'] ?? '',
        'address': doc['address'] ?? '',
        'id': doc.id,  // Save document ID for reference
      };
    }).toList();

    filteredData = List.from(data);
    notifyListeners();
  }

  void filterData(String query) {
    if (query.isEmpty) {
      filteredData = List.from(data);
    } else {
      filteredData = data
          .where((row) => row.values
          .any((value) => value.toString().contains(query)))
          .toList();
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final row = filteredData[index];
    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),  // Sequential number
      DataCell(Text(row['name'])),
      DataCell(Text(row['mobNo'])),
      DataCell(Text(row['gender'])),
      DataCell(Text(row['email'])),
      DataCell(Text(row['age'].toString())),
      DataCell(Text(row['dob'])),
      DataCell(Text(row['password'])),
      DataCell(Text(row['address'])),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _edit(row),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _delete(row),
          ),
          IconButton(
            icon: Icon(Icons.visibility, color: Colors.green),
            onPressed: () => _view(row),
          ),
        ],
      )),
    ]);
  }

  void _edit(Map<String, dynamic> row) {
    // Handle edit action
    print('Edit ${row['name']}');
    // Implement your edit logic here
  }

  void _delete(Map<String, dynamic> row) {
    // Handle delete action
    print('Delete ${row['name']}');
    // Implement your delete logic here
    FirebaseFirestore.instance.collection('job_seekers').doc(row['id']).delete();
    fetchData();  // Refresh the data after deletion
  }

  void _view(Map<String, dynamic> row) {
    // Handle view action
    print('View ${row['name']}');
    // Implement your view logic here
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredData.length;

  @override
  int get selectedRowCount => 0;
}
