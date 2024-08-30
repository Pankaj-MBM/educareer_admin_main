import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewJobPortal extends StatefulWidget {
  const AddNewJobPortal({super.key});

  @override
  _AddNewJobPortalState createState() => _AddNewJobPortalState();
}

class _AddNewJobPortalState extends State<AddNewJobPortal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _salaryRangeController = TextEditingController();

  String? _selectedJobCategory;
  String _selectedJobPosition = 'Senior';
  String _selectedQualification = 'Graduate';
  String _selectedExperience = '1 year';
  String _selectedJobType = 'Remote Job';

  bool _agreedToTerms = false;
  bool _isLoading = true;
  List<String> _jobCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchJobCategories();
  }

  Future<void> _fetchJobCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('job-category').get();
      List<String> jobCategories = snapshot.docs
          .where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data.containsKey('job_title');
      })
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['job_title'] as String;
      })
          .toList();

      if (jobCategories.isEmpty) {
        throw Exception('No valid job categories found');
      }

      setState(() {
        _jobCategories = jobCategories;
        _selectedJobCategory = _jobCategories.isNotEmpty ? _jobCategories[0] : null; // Default to the first category if available
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching job categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SizedBox(
            width: 800,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Create New Job",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 15),
                          // Company Name
                          _buildTextFormField(
                            controller: _companyNameController,
                            label: 'Company Name',
                          ),
                          // Job Title
                          _buildTextFormField(
                            controller: _jobTitleController,
                            label: 'Job Title',
                          ),
                          // Job Description
                          _buildTextFormField(
                            controller: _jobDescriptionController,
                            label: 'Job Description',
                            maxLines: 3,
                          ),
                          // Select Job Category
                          const SizedBox(height: 16),
                          const Text(
                            'Select Job Category',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : _buildDropdownButton(
                            value: _selectedJobCategory,
                            items: _jobCategories,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedJobCategory = newValue;
                              });
                            },
                          ),
                          // Location
                          _buildTextFormField(
                            controller: _locationController,
                            label: 'Location',
                          ),
                          // Salary Range
                          _buildTextFormField(
                            controller: _salaryRangeController,
                            label: 'Salary Range',
                            prefixText: '\$ ',
                            keyboardType: TextInputType.number,
                          ),
                          // Select Job Position
                          const SizedBox(height: 16),
                          const Text(
                            'Select Job Position',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          _buildDropdownButton(
                            value: _selectedJobPosition,
                            items: ['Senior', 'Junior', 'Trainee'],
                            onChanged: (newValue) {
                              setState(() {
                                _selectedJobPosition = newValue!;
                              });
                            },
                          ),
                          // Minimum Qualification
                          const SizedBox(height: 16),
                          const Text(
                            'Minimum Qualification',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          _buildDropdownButton(
                            value: _selectedQualification,
                            items: ['Graduate', 'Post Graduate', '12th', '10th'],
                            onChanged: (newValue) {
                              setState(() {
                                _selectedQualification = newValue!;
                              });
                            },
                          ),
                          // Minimum Experience
                          const SizedBox(height: 16),
                          const Text(
                            'Minimum Experience',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          _buildDropdownButton(
                            value: _selectedExperience,
                            items: ['1 year', '2 years', '4 years', '5+ years'],
                            onChanged: (newValue) {
                              setState(() {
                                _selectedExperience = newValue!;
                              });
                            },
                          ),
                          // Select Job Type
                          const SizedBox(height: 16),
                          const Text(
                            'Select Job Type',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          _buildDropdownButton(
                            value: _selectedJobType,
                            items: ['Remote Job', 'Part-Time', 'Full-Time'],
                            onChanged: (newValue) {
                              setState(() {
                                _selectedJobType = newValue!;
                              });
                            },
                          ),
                          // Agree to terms
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _agreedToTerms = value ?? false;
                                  });
                                },
                              ),
                              const Text(
                                'I agree to the terms and conditions',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          // Submit Button
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: _agreedToTerms ? _handleSubmit : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    String? prefixText,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefixText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownButton<T>({
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null) {
          return 'Please select an option';
        }
        return null;
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance.collection('add_new_job').add({
          'company_name': _companyNameController.text,
          'job_title': _jobTitleController.text,
          'job_description': _jobDescriptionController.text,
          'job_category': _selectedJobCategory,
          'location': _locationController.text,
          'salary_range': _salaryRangeController.text,
          'job_position': _selectedJobPosition,
          'qualification': _selectedQualification,
          'experience': _selectedExperience,
          'job_type': _selectedJobType,
          'posted_at': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Job added successfully!'),
          ),
        );
        _companyNameController.clear();
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        _locationController.clear();
        _salaryRangeController.clear();

      } catch (e) {
        print('Error adding job: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add job.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
