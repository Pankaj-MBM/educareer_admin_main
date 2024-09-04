import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewJobSeeker extends StatefulWidget {
  @override
  _AddNewJobSeekerState createState() => _AddNewJobSeekerState();
}

class _AddNewJobSeekerState extends State<AddNewJobSeeker> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobNoController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _addJobSeeker() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      DocumentReference docRef = await FirebaseFirestore.instance.collection('job_seekers').add({
        'firstName': _firstNameController.text,
        'middleName': _middleNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'mobNo': _mobNoController.text,
        'gender': _genderController.text,
        'dob': _dobController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'address': _addressController.text,
        'password': _passwordController.text,  // Store hashed password if needed
        'experience': [], // Add empty array for experience
        'skills': [], // Add empty array for skills
        'documents': [], // Add empty array for documents
        'education': [], // Add empty array for education
      });

      // Use doc.id as UID
      await docRef.update({'uid': docRef.id});

      // Clear the text fields
      _firstNameController.clear();
      _middleNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _mobNoController.clear();
      _genderController.clear();
      _dobController.clear();
      _ageController.clear();
      _addressController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job seeker added successfully')),
      );

      setState(() {});
    }
  }

  Widget _buildTextFormField(
      TextEditingController controller,
      String labelText,
      String validatorMessage, {
        bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,
        bool emailValidator = false,
      }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        if (emailValidator && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Job Seeker'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Add New Job Seeker",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildTextFormField(_firstNameController, 'First Name', 'Please enter first name'),
                    SizedBox(height: 16),
                    _buildTextFormField(_middleNameController, 'Middle Name', ''),
                    SizedBox(height: 16),
                    _buildTextFormField(_lastNameController, 'Last Name', 'Please enter last name'),
                    SizedBox(height: 16),
                    _buildTextFormField(_emailController, 'Email', 'Please enter email', keyboardType: TextInputType.emailAddress, emailValidator: true),
                    SizedBox(height: 16),
                    _buildTextFormField(_mobNoController, 'Mobile Number', 'Please enter mobile number', keyboardType: TextInputType.phone),
                    SizedBox(height: 16),
                    _buildTextFormField(_genderController, 'Gender', 'Please enter gender'),
                    SizedBox(height: 16),
                    _buildTextFormField(_dobController, 'Date of Birth (YYYY-MM-DD)', 'Please enter date of birth', keyboardType: TextInputType.datetime),
                    SizedBox(height: 16),
                    _buildTextFormField(_ageController, 'Age', 'Please enter age', keyboardType: TextInputType.number),
                    SizedBox(height: 16),
                    _buildTextFormField(_addressController, 'Address', 'Please enter address'),
                    SizedBox(height: 16),
                    _buildTextFormField(_passwordController, 'Password', 'Please enter password', obscureText: true),
                    SizedBox(height: 16),
                    _buildTextFormField(_confirmPasswordController, 'Confirm Password', 'Please confirm your password', obscureText: true),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addJobSeeker,
                      child: Text('Add Job Seeker'),
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
