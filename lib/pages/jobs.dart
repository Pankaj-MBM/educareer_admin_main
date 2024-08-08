import 'package:flutter/material.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample job data
    final List<Map<String, dynamic>> jobs = [
      {
        'title': 'Software Engineer',
        'company': 'Tech Solutions Inc.',
        'salary': '\$80,000 - \$100,000',
        'experience': true,
        'skills': ['Flutter', 'Dart', 'REST APIs'],
        'description': 'Develop mobile applications using Flutter.',
      },
      {
        'title': 'Web Developer',
        'company': 'Webify LLC',
        'salary': '\$60,000 - \$80,000',
        'experience': false,
        'skills': ['JavaScript', 'React', 'CSS'],
        'description': 'Build responsive websites using React.',
      },
      {
        'title': 'Data Analyst',
        'company': 'Data Corp',
        'salary': '\$70,000 - \$90,000',
        'experience': true,
        'skills': ['Python', 'SQL', 'Data Visualization'],
        'description': 'Analyze data trends and produce reports.',
      },
      {
        'title': 'Product Manager',
        'company': 'Innovate Ltd',
        'salary': '\$90,000 - \$110,000',
        'experience': true,
        'skills': ['Project Management', 'Agile', 'Communication'],
        'description': 'Lead product development teams.',
      },
      {
        'title': 'UI/UX Designer',
        'company': 'Creative Minds',
        'salary': '\$70,000 - \$85,000',
        'experience': false,
        'skills': ['Adobe XD', 'Figma', 'User Research'],
        'description': 'Design user-friendly interfaces.',
      },
      {
        'title': 'Network Engineer',
        'company': 'NetSecure Inc.',
        'salary': '\$75,000 - \$95,000',
        'experience': true,
        'skills': ['Networking', 'Security', 'Troubleshooting'],
        'description': 'Maintain network infrastructure.',
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Positions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.teal, // Separator color
              thickness: 2, // Separator thickness
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return JobCard(job: job);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  job['experience'] ? Icons.work : Icons.school,
                  color: Colors.teal,
                ),
                const SizedBox(width: 10),
                Text(
                  job['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              job['company'],
              style: TextStyle(
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.attach_money, color: Colors.teal),
                const SizedBox(width: 5),
                Text(
                  job['salary'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  job['experience'] ? Icons.check_circle : Icons.close,
                  color: job['experience'] ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 5),
                Text(
                  'Experience Required: ${job['experience'] ? "Yes" : "No"}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: job['skills'].map<Widget>((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Colors.teal[100],
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              job['description'],
              style: TextStyle(color: Colors.grey[800]),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _showApplyDialog(context);
                },
                child: const Text('Post'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Background color
                  foregroundColor: Colors.white, // Text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Apply'),
          content: const Text('Are you sure you want to apply for this position?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Add the apply logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Applied successfully!'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.green.withOpacity(0.8), // Green color with 80% opacity
                  ),
                );
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
