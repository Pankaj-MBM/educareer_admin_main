import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddNewJobPortal extends StatefulWidget {
  AddNewJobPortal({super.key});

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

  String _selectedJobCategory = 'React';
  String _selectedJobPosition = 'Senior';
  String _selectedQualification = 'Graduate';
  String _selectedExperience = '1 year';
  String _selectedJobType = 'Remote Job';

  bool _agreedToTerms = false;
  bool _isFileUploaded = false;
  File? _uploadedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SizedBox(
            width:800,
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
                          Center(child: Text("Create New Job",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                          SizedBox(height: 15,),
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
                          _buildDropdownButton(
                            value: _selectedJobCategory,
                            items: [
                              'React',
                              'Flutter',
                              'Angular',
                              'ASP.NET Web API',
                              'Node.js',
                              'MERN'
                            ],
                            onChanged: (newValue) {
                              setState(() {
                                _selectedJobCategory = newValue!;
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

                          // Company Logo
                          const SizedBox(height: 16),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrangeAccent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () async {
                                  // Handle file selection
                                  FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                    type: FileType.image,
                                  );

                                  if (result != null) {
                                    setState(() {
                                      _isFileUploaded = true;
                                      _uploadedImage = File(result.files.single.path!);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'File selected: ${result.files.single.name}',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Upload Company Logo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Display Uploaded Image
                          if (_uploadedImage != null) ...[
                            const SizedBox(height: 16),
                            Center(
                              child: Image.file(
                                _uploadedImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],

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
                              const Expanded(
                                child: Text(
                                  'I agree to the terms and conditions',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Submit Button
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF263238),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 48,
                                  vertical: 16,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    _agreedToTerms) {
                                  // Submit the form
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Form submitted')),
                                  );
                                } else if (!_agreedToTerms) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'You must agree to the terms and conditions',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
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
    String? prefixText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefixText,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter ${label.toLowerCase()}';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownButton({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
