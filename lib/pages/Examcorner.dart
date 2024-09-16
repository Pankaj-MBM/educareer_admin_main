import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ExamcornerPage extends StatefulWidget {
  const ExamcornerPage({super.key});

  @override
  _ExamcornerPageState createState() => _ExamcornerPageState();
}

class _ExamcornerPageState extends State<ExamcornerPage> {
  List<Map<String, dynamic>> notices = []; // Updated to dynamic
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchNotices(); // Fetch notices from Firestore when the page loads
  }

  Future<void> _fetchNotices() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Examcorner').get();
      setState(() {
        notices = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Failed to fetch notices: $e');
    }
  }

  void _showAddNoticeDialog() {
    final _titleController = TextEditingController();
    final _dateController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _venueController = TextEditingController();
    final _timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Notice'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      _dateController.text =
                      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    }
                  },
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _venueController,
                  decoration: InputDecoration(labelText: 'Venue'),
                ),
                TextField(
                  controller: _timeController,
                  decoration: InputDecoration(labelText: 'Time'),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      _timeController.text = pickedTime.format(context);
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                    await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      setState(() {
                        _selectedFile = result.files.first;
                      });
                    }
                  },
                  child: Text(_selectedFile == null
                      ? 'Upload Document'
                      : 'Document Selected'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_selectedFile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a document.')),
                  );
                  return;
                }

                setState(() {
                  _isUploading = true;
                });

                try {
                  final fileBytes = _selectedFile!.bytes;
                  final storageRef = FirebaseStorage.instance
                      .ref()
                      .child('examcorner_documents/${_selectedFile!.name}');
                  final uploadTask = storageRef.putData(fileBytes!);

                  final snapshot = await uploadTask.whenComplete(() {});
                  final documentPath = await snapshot.ref.getDownloadURL();

                  final newNotice = {
                    'title': _titleController.text,
                    'date': _dateController.text,
                    'description': _descriptionController.text,
                    'venue': _venueController.text,
                    'time': _timeController.text,
                    'documentPath': documentPath, // Store the document URL
                  };

                  await FirebaseFirestore.instance
                      .collection('Examcorner')
                      .add(newNotice);

                  setState(() {
                    notices.add(newNotice);
                    _isUploading = false;
                    _selectedFile = null;
                  });

                  Navigator.of(context).pop();
                } catch (e) {
                  setState(() {
                    _isUploading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to upload document: $e'),
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam Corner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 16.0, // Space between columns
            mainAxisSpacing: 16.0, // Space between rows
            childAspectRatio: 0.75, // Adjust the aspect ratio as needed
          ),
          itemCount: notices.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 200, // Fixed height for the card
              child: NoticeCard(
                title: notices[index]['title'] ?? '',
                date: notices[index]['date'] ?? '',
                description: notices[index]['description'] ?? '',
                venue: notices[index]['venue'] ?? '',
                time: notices[index]['time'] ?? '',
                documentPath: notices[index]['documentPath'] ?? '',
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoticeDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Notice',
      ),
    );
  }
}

class NoticeCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String venue;
  final String time;
  final String documentPath; // New field for document URL

  const NoticeCard({
    required this.title,
    required this.date,
    required this.description,
    required this.venue,
    required this.time,
    required this.documentPath, // Pass the document URL
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Venue: $venue",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Time: $time",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis, // Ensure text does not overflow
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunch(documentPath)) {
                  await launch(documentPath);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not open the document')),
                  );
                }
              },
              child: Text('View Document'),
            ),
          ],
        ),
      ),
    );
  }
}
