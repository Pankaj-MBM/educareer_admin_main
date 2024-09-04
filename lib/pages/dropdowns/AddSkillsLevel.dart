import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';

class AddSkillsLevel extends StatefulWidget {
  const AddSkillsLevel({super.key});

  @override
  _AddSkillsLevelState createState() => _AddSkillsLevelState();
}

class _AddSkillsLevelState extends State<AddSkillsLevel> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late MyData _myData;

  @override
  void initState() {
    super.initState();
    _myData = MyData(onDelete: _showDeleteDialog);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Skills').get();
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
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
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
          title: Text('Add Skill'),
          content: TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Enter skill title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addSkill();
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

  // Future<void> _addSkill() async {
  //   final title = _titleController.text.trim();
  //   if (title.isNotEmpty) {
  //     try {
  //       await FirebaseFirestore.instance.collection('Skills').add({
  //         'title': title,
  //       });
  //       _titleController.clear();
  //       _fetchData(); // Refresh the data after adding
  //     } catch (e) {
  //       // Handle errors appropriately
  //       print('Error adding skill: $e');
  //     }
  //   }
  // }
  Future<void> _addSkill() async {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      try {
        final newDocRef = FirebaseFirestore.instance.collection('Skills').doc();
        await newDocRef.set({
          'id': newDocRef.id, // Save the document ID as part of the document
          'title': title,
        });
        _titleController.clear();
        _fetchData(); // Refresh the data after adding
      } catch (e) {
        // Handle errors appropriately
        print('Error adding skill: $e');
      }
    }
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this skill?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteSkill(id);
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

  Future<void> _deleteSkill(String id) async {
    try {
      await FirebaseFirestore.instance.collection('Skills').doc(id).delete();
      _fetchData(); // Refresh the data after deletion
    } catch (e) {
      // Handle errors appropriately
      print('Error deleting skill: $e');
    }
  }
}

class MyData extends DataTableSource {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];
  final Function(String) onDelete;

  MyData({required this.onDelete});

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
              final id = row['id'] as String;
              onDelete(id);
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
