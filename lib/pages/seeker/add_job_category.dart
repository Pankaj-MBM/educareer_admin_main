import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddJobCategory extends StatefulWidget {
  const AddJobCategory({super.key});

  @override
  _AddJobCategoryState createState() => _AddJobCategoryState();
}

class _AddJobCategoryState extends State<AddJobCategory> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  DateTime _postDate = DateTime.now(); // Default to current date

  Future<void> _addJobCategory() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Create a unique ID based on timestamp
      String id = DateTime.now().millisecondsSinceEpoch.toString();

      await FirebaseFirestore.instance.collection('job-category').add({
        'id': id,
        'job_title': _jobTitleController.text,
        'job_desc': _jobDescController.text,
        'skills': _skillsController.text,
        'post_date': _postDate,
      });

      // Clear the text fields
      _jobTitleController.clear();
      _jobDescController.clear();
      _skillsController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job category added successfully')),
      );

      // Optionally, you can navigate to another page or reset the form
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Job Category'),
      ),
      body: Center(
        child: SizedBox(
          width: 400, // Fixed width
          height: 450, // Fixed height
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                        "Job Category",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _jobTitleController,
                      decoration: InputDecoration(
                        labelText: 'Job Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter job title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _jobDescController,
                      decoration: InputDecoration(
                        labelText: 'Job Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter job description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _skillsController,
                      decoration: InputDecoration(
                        labelText: 'Skills Required',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter required skills';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addJobCategory,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
