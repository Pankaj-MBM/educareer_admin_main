import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';

class Adddesignationpage extends StatefulWidget {
  const Adddesignationpage({super.key});

  @override
  _AdddesignationpageState createState() => _AdddesignationpageState();
}

class _AdddesignationpageState extends State<Adddesignationpage> {
  final TextEditingController _titleController = TextEditingController();
  final _myData = MyData();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection('designation').get();
    final data = snapshot.docs.map((doc) {
      final id = doc.id;
      final title = doc['title'] ?? 'No Title';
      return {
        'id': id,
        'title': title,
      };
    }).toList();
    setState(() {
      _myData.updateData(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pass the current context to MyData for delete dialog handling
    _myData.context = context;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Designations'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SizedBox(
                width: 200,
                child: TextField(
                  controller: _searchController,
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
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: PaginatedDataTable2(
          source: _myData,
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Title')),
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

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Designation'),
          content: TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Enter designation title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addDesignation();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addDesignation() async {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      await FirebaseFirestore.instance.collection('designation').add({
        'title': title,
      });
      _titleController.clear();
      _fetchData(); // Refresh the data after adding
    }
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this designation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteDesignation(id);
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDesignation(String id) async {
    await FirebaseFirestore.instance.collection('designation').doc(id).delete();
    _fetchData(); // Refresh the data after deletion
  }
}

class MyData extends DataTableSource {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];
  BuildContext? context; // Make context available here

  void updateData(List<Map<String, dynamic>> newData) {
    data = newData;
    filteredData = List.from(data);
    notifyListeners();
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
    final row = filteredData[index];
    return DataRow(cells: [
      DataCell(Text(row['id'])),
      DataCell(Text(row['title'])),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              if (context != null) {
                final id = row['id'] as String;
                (context as BuildContext).findAncestorStateOfType<_AdddesignationpageState>()?._showDeleteDialog(context!, id);
              }
            },
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredData.length;

  @override
  int get selectedRowCount => 0;
}
