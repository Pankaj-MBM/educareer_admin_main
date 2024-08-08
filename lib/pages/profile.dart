import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with "My Profile" text
            const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.teal,
              thickness: 2,
            ),
            const SizedBox(height: 15),

            // Profile Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 70, // Size of the profile image
                        backgroundImage: AssetImage('assets/images/new1.JPG'), // Replace with your image asset
                        backgroundColor: Colors.grey[300], // Fallback color if the image is not loaded
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // Add your edit logic here
                            print('Edit profile image tapped');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Profile Name
                  Text(
                    'Rohit Rao', // Replace with user's name
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Email
                  Text(
                    '123@example.com', // Replace with user's email
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Additional Info
                  InfoCard(
                    title: 'Phone Number',
                    value: '+91 7568862848', // Replace with user's phone number
                  ),
                  InfoCard(
                    title: 'Address',
                    value: '1234 Jodhpur, Rajasthan', // Replace with user's address
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
