import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class RejectQueries extends StatelessWidget {
  const RejectQueries({super.key});

  Future<void> _deleteRequest(BuildContext context, String requestId) async {
    try {
      // Show confirmation dialog
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text('Are you sure you want to delete this request?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        // Delete the document
        await FirebaseFirestore.instance
            .collection('admin-reject-queries')
            .doc(requestId)
            .delete();

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Request successfully deleted.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error deleting request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejected Queries'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('admin-reject-queries').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No rejected queries found.'));
          }

          final List<Map<String, dynamic>> rejectQueries = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            print('Document Data: $data'); // Debugging line
            return {
              'id': doc.id,
              ...data,
            };
          }).toList();

          return
             DataTable2(
              columnSpacing: 12,
              minWidth: 600,
              columns: const [
                DataColumn2(label: Text('Teacher Type')),
                DataColumn2(label: Text('Subject')),
                DataColumn2(label: Text('City')),
                DataColumn2(label: Text('State')),
                DataColumn2(label: Text('Class')),
                DataColumn2(label: Text('Request ID')),
                DataColumn2(label: Text('Actions')),
              ],
              rows: rejectQueries.map((query) {
                return DataRow(
                  cells: [
                    DataCell(Text(query['teacherType'] ?? 'N/A')),
                    DataCell(Text(query['subject'] ?? 'N/A')),
                    DataCell(Text(query['city'] ?? 'N/A')),
                    DataCell(Text(query['state'] ?? 'N/A')),
                    DataCell(Text(query['class'] ?? 'N/A')),
                    DataCell(Text(query['request_id'] ?? 'N/A')),
                    DataCell(IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteRequest(context, query['id']),
                    )),
                  ],
                );
              }).toList(),
           
          );
        },
      ),
    );
  }
}

