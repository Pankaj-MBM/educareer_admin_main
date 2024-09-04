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
      home: StudentList(),
    );
  }
}

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final MyData _myData = MyData();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
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
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Mobile No')),
            DataColumn(label: Text('Gender')),
            DataColumn(label: Text('Age'), numeric: true),
            DataColumn(label: Text('Address')),
            DataColumn(label: Text('Actions')),
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
    await FirebaseFirestore.instance.collection('students').get();

    data = snapshot.docs.map((doc) {
      return {
        'firstName': doc['firstName'] ?? '',
        'middleName': doc['middleName'] ?? '',
        'lastName': doc['lastName'] ?? '',
        'email': doc['email'] ?? '',
        'mobNo': doc['mobNo'] ?? '',
        'gender': doc['gender'] ?? '',
        'age': doc['age'] ?? '',
        'address': doc['address'] ?? '',
        'id': doc.id, // Save document ID for reference
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
      DataCell(Text((index + 1).toString())), // Sequential number
      DataCell(Text(row['firstName'])),
      DataCell(Text(row['middleName'])),
      DataCell(Text(row['lastName'])),
      DataCell(Text(row['email'])),
      DataCell(Text(row['mobNo'])),
      DataCell(Text(row['gender'])),
      DataCell(Text(row['age'].toString())),
      DataCell(Text(row['address'])),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () => {
              // _edit(row)
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _delete(row),
          ),
        ],
      )),
    ]);
  }

  void _delete(Map<String, dynamic> row) async {
    // Handle delete action
    print('Delete ${row['firstName']} ${row['lastName']}');
    // Implement your delete logic here
    await FirebaseFirestore.instance.collection('students').doc(row['id']).delete();
    fetchData(); // Refresh the data after deletion
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredData.length;

  @override
  int get selectedRowCount => 0;
}





