import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CompaniePage extends StatelessWidget {
  const CompaniePage({super.key});

  @override
  Widget build(BuildContext context) {
    final companies = [
      {
        'name': 'Company A',
        'logo': 'assets/images/user_img.jpg',
        'description': 'Company A is a leading firm in tech innovations.',
        'contact': '+1234567890',
        'mail': 'contact@companya.com',
        'specialization': 'Tech Innovations',
        'location': 'https://www.google.com/maps/place/Company+A',
        'availableJobs': ['Software Engineer', 'UI/UX Designer'], // Added jobs
      },
      {
        'name': 'Company B',
        'logo': 'assets/images/user_img.jpg',
        'description': 'Company B specializes in AI and machine learning.',
        'contact': '+0987654321',
        'mail': 'contact@companyb.com',
        'specialization': 'AI and Machine Learning',
        'location': 'https://www.google.com/maps/place/Company+B',
        'availableJobs': ['Data Scientist', 'Machine Learning Engineer'], // Added jobs
      },
      {
        'name': 'Company C',
        'logo': 'assets/images/user_img.jpg',
        'description': 'Company C provides top-notch financial services.',
        'contact': '+1122334455',
        'mail': 'contact@companyc.com',
        'specialization': 'Financial Services',
        'location': 'https://www.google.com/maps/place/Company+C',
        'availableJobs': ['Financial Analyst', 'Account Manager'], // Added jobs
      },
      // Add more companies here
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profiles'),
        backgroundColor: Colors.cyan[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: companies.length,
          itemBuilder: (context, index) {
            final company = companies[index];
            return CompanyCard(
              name: company['name'] as String,
              logo: company['logo'] as String,
              description: company['description'] as String,
              contact: company['contact'] as String,
              mail: company['mail'] as String,
              specialization: company['specialization'] as String,
              location: company['location'] as String,
              availableJobs: List<String>.from(company['availableJobs'] as List), // Cast to List<String>
            );
          },
        ),
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  final String name;
  final String logo;
  final String description;
  final String contact;
  final String mail;
  final String specialization;
  final String location;
  final List<String> availableJobs; // New field for jobs

  const CompanyCard({
    required this.name,
    required this.logo,
    required this.description,
    required this.contact,
    required this.mail,
    required this.specialization,
    required this.location,
    required this.availableJobs, // Add to constructor
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50), // Circular logo
                  child: Image.asset(
                    logo,
                    width: 80, // Adjust size as needed
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(specialization, style: TextStyle(fontSize: 16, color: Colors.teal)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(description, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _showContactForm(context);
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.teal, // Background color
                    // onPrimary: Colors.white, // Text color
                  ),
                  child: const Text('Contact'),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            const Divider(color: Colors.teal, thickness: 1), // Divider for separation
            const SizedBox(height: 8.0),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.teal),
              title: Text(contact, style: const TextStyle(fontSize: 16)),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.teal),
              title: Text(mail, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 8.0),
            // Display available jobs
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: availableJobs.map((job) => Chip(
                label: Text(job),
                backgroundColor: Colors.teal[100],
              )).toList(),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () => _launchURL(location),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'View on Google Maps',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showContactForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Form'),
          content: Container(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Message',
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                // primary: Colors.teal, // Background color
                // onPrimary: Colors.white, // Text color
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
