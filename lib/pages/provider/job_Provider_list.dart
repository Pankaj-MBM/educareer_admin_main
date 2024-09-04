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
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JobProviderList(),
      navigatorKey: navigatorKey,
    );
  }
}

class JobProviderList extends StatefulWidget {
  const JobProviderList({super.key});

  @override
  _JobProviderListState createState() => _JobProviderListState();
}

class _JobProviderListState extends State<JobProviderList> {
  late MyData _myData;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _myData = MyData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Providers List'),
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
  final BuildContext context; // Store the context passed from the widget
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];

  MyData(this.context) {
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('job_providers').get();

    data = snapshot.docs.map((doc) {
      return {
        'firstName': doc['firstName'] ?? 'N/A',
        'middleName': doc['middleName'] ?? 'N/A',
        'lastName': doc['lastName'] ?? 'N/A',
        'title': doc['title'] ?? 'N/A', // Ensure this field exists
        'mobNo': doc['mobNo'] ?? 'N/A',
        'email': doc['email'] ?? 'N/A',
        'dob': doc['dob'] ?? 'N/A', // Ensure this field exists
        'age': doc['age'] ?? 'N/A', // Ensure this field exists
        'address': doc['address'] ?? 'N/A', // Ensure this field exists
        'password': doc['password'] ?? 'N/A', // Ensure this field exists
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
          .where((row) => row.values.any(
              (value) => value.toString().toLowerCase().contains(query.toLowerCase())))
          .toList();
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final row = filteredData[index];
    return DataRow(cells: [
      DataCell(Text((index + 1).toString())), // Sequential number
      DataCell(Text(row['firstName'] ?? 'N/A')),
      DataCell(Text(row['middleName'] ?? 'N/A')),
      DataCell(Text(row['lastName'] ?? 'N/A')),
      DataCell(Text(row['mobNo'] ?? 'N/A')),
      DataCell(Text(row['email'] ?? 'N/A')),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.visibility, color: Colors.green),
            onPressed: () {
              _showAlertMessage(context, row);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _delete(row, context),
          ),
        ],
      )),
    ]);
  }

  void _showAlertMessage(BuildContext context, Map<String, dynamic> row) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('First Name: ${row['firstName']}'),
              Text('Middle Name: ${row['middleName']}'),
              Text('Last Name: ${row['lastName']}'),
              Text('Title: ${row['title']}'),
              Text('Email: ${row['email']}'),
              Text('Mobile No: ${row['mobNo']}'),
              Text('Date of Birth: ${row['dob']}'),
              Text('Age: ${row['age']}'),
              Text('Address: ${row['address']}'),
              Text('Password: ${row['password']}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _delete(Map<String, dynamic> row, BuildContext context) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this job provider?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when Cancel is pressed
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when Delete is pressed
              },
            ),
          ],
        );
      },
    );

    if (confirmed) {
      await FirebaseFirestore.instance
          .collection('job_providers')
          .doc(row['id'])
          .delete();
      fetchData(); // Refresh the data after deletion
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredData.length;

  @override
  int get selectedRowCount => 0;
}
