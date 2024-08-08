import 'package:flutter/material.dart';

class StudentList extends StatelessWidget {
  const StudentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          StudentCard(
            name: 'John Doe',
            age: 20,
            email: 'john.doe@example.com',
            phoneNumber: '+123 456 7890',
            imageUrl: 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg',
          ),
          StudentCard(
            name: 'Jane Smith',
            age: 22,
            email: 'jane.smith@example.com',
            phoneNumber: '+123 456 7891',
            imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTSKbCFe_QYSVH-4FpaszXvakr2Eti9eAJpQ&s',
          ),
          StudentCard(
            name: 'Emily Johnson',
            age: 19,
            email: 'emily.johnson@example.com',
            phoneNumber: '+123 456 7892',
            imageUrl: 'https://pics.craiyon.com/2023-07-15/dc2ec5a571974417a5551420a4fb0587.webp',
          ),
          // Add more StudentCard widgets as needed
        ],
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final String name;
  final int age;
  final String email;
  final String phoneNumber;
  final String imageUrl;

  const StudentCard({
    required this.name,
    required this.age,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
    super.key,
  });

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Details below the image
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8.0),
                        Text('Age: $age', style: const TextStyle(fontSize: 18.0)),
                        Text('Email: $email', style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
                        Text('Phone: $phoneNumber', style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FilledButton(

                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          child: Text(name[0]), // Initial of the student's name
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        title: Text(name, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age: $age', style: const TextStyle(fontSize: 16.0)),
            Text('Email: $email', style: const TextStyle(fontSize: 14.0, color: Colors.grey)),
            Text('Phone: $phoneNumber', style: const TextStyle(fontSize: 14.0, color: Colors.grey)),
          ],
        ),
        trailing: TextButton(
          onPressed: () => _showDetailsDialog(context),
          child: const Text('View More', style: TextStyle(color: Colors.blue)),
        ),
      ),
    );
  }
}
