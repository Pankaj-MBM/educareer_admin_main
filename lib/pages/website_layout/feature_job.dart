import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeatureJobPage extends StatefulWidget {
  const FeatureJobPage({super.key});

  @override
  _FeatureJobPageState createState() => _FeatureJobPageState();
}

class _FeatureJobPageState extends State<FeatureJobPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Future<void> _addFeaturedJob() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Create a unique ID based on timestamp
      String id = DateTime.now().millisecondsSinceEpoch.toString();

      await FirebaseFirestore.instance.collection('featured_jobs').add({
        'id': id,
        'company_name': _companyNameController.text,
        'title': _titleController.text,
        'payment': _paymentController.text,
        'location': _locationController.text,
      });

      // Clear the text fields
      _companyNameController.clear();
      _titleController.clear();
      _paymentController.clear();
      _locationController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Featured job added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Featured Job'),
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
                        "Featured Job",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _companyNameController,
                      decoration: InputDecoration(
                        labelText: 'Company Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter company name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
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
                      controller: _paymentController,
                      decoration: InputDecoration(
                        labelText: 'Payment',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter payment';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter location';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addFeaturedJob,
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
