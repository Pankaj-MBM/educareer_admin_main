import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this to handle URL launching

class ScholarshipPage extends StatefulWidget {
  const ScholarshipPage({super.key});

  @override
  _ScholarshipPageState createState() => _ScholarshipPageState();
}

class _ScholarshipPageState extends State<ScholarshipPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _scholarshipNameController = TextEditingController();
  final TextEditingController _shortDescriptionController = TextEditingController();
  final TextEditingController _applicableController = TextEditingController();
  final TextEditingController _applyLinkController = TextEditingController();
  final TextEditingController _closingDateController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();

  String? _userId;
  bool _isUploading = false;
  PlatformFile? _selectedFile;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId');
    });
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File selection was canceled.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick file: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _uploadFileAndSubmitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select the required document.')),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      try {
        // Upload the file to Firebase Storage
        final fileBytes = _selectedFile!.bytes;
        if (fileBytes == null) {
          throw Exception('Failed to get file bytes.');
        }

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('scholarships/${_selectedFile!.name}');
        final uploadTask = storageRef.putData(fileBytes);

        final snapshot = await uploadTask.whenComplete(() {});
        final filePath = await snapshot.ref.getDownloadURL();

        // After uploading, save form data to Firebase
        await FirebaseFirestore.instance.collection('ScholarshipCorner').add({
          'scholarshipName': _scholarshipNameController.text,
          'shortDescription': _shortDescriptionController.text,
          'applicable': _applicableController.text,
          'applyLink': _applyLinkController.text,
          'closingDate': _closingDateController.text,
          'startDate': _startDateController.text,
          'userId': _userId,
          'documentPath': filePath,  // Store the document URL
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form Submitted Successfully')),
        );

        // Optionally, clear the form after submission
        _formKey.currentState!.reset();
        setState(() {
          _selectedFile = null;
          _isUploading = false;
        });
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit form: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _openFormDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Scholarship'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildForm(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: _isUploading ? null : () async {
                await _uploadFileAndSubmitForm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _scholarshipNameController,
            decoration: InputDecoration(
              labelText: 'Scholarship Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the scholarship name';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),

          TextFormField(
            controller: _shortDescriptionController,
            decoration: InputDecoration(
              labelText: 'Short Description',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a short description';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),

          TextFormField(
            controller: _applicableController,
            decoration: InputDecoration(
              labelText: 'Applicable',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please specify who it applies to';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),

          TextFormField(
            controller: _applyLinkController,
            decoration: InputDecoration(
              labelText: 'Apply Link',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the application link';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),

          TextFormField(
            controller: _closingDateController,
            decoration: InputDecoration(
              labelText: 'Closing Date',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the closing date';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),

          TextFormField(
            controller: _startDateController,
            decoration: InputDecoration(
              labelText: 'Start Date',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the start date';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),

          Text(
            'Upload Document:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: IconButton(
              onPressed: _pickFile,
              icon: Icon(Icons.upload_file),
            ),
            title: Text('Upload Scholarship Form'),
            subtitle: _selectedFile != null
                ? Text('Selected file: ${_selectedFile!.name}')
                : const Text('No file selected'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ScholarshipCorner').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final data = snapshot.requireData;

        return DataTable2(
          columns: const [
            DataColumn(label: Text('Scholarship Name')),
            DataColumn(label: Text('Short Description')),
            DataColumn(label: Text('Applicable')),
            DataColumn(label: Text('Closing Date')),
            DataColumn(label: Text('Start Date')),
            DataColumn(label: Text('Document')), // Add column for document
            DataColumn(label: Text('Actions')),
          ],
          rows: data.docs.map((doc) {
            return DataRow(
              cells: [
                DataCell(Text(doc['scholarshipName'])),
                DataCell(Text(doc['shortDescription'])),
                DataCell(Text(doc['applicable'])),
                DataCell(Text(doc['closingDate'])),
                DataCell(Text(doc['startDate'])),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () async {
                      final url = doc['documentPath'];
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not open document.')),
                        );
                      }
                    },
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      doc.reference.delete();
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scholarship Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50,top:20),
            child: InkWell(
              onTap: () => _openFormDialog(context),
              child: Row(
                children: [
                  Text("Add New"),
                  SizedBox(width: 8), // Add some spacing between the text and icon
                  Icon(Icons.add),
                ],
              ),
            ),
          )

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: _buildDataTable()),
          ],
        ),
      ),
    );
  }
}
