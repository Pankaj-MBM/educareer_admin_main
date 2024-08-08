import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example company details
    final company = {
      'name': 'EduCareer',
      'profileImage': 'assets/images/contact-1.jpg', // Example profile image
      'contact': '1234567890',
      'mail': 'educontact@companya.com',
      'address': '123 phase 2nd first kamala nehru nagar 342001',
      'website': 'https://www.Educareer.com', // Extra information
      'socialMedia': '@companya', // Extra information
    };

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Text(
              "Contact Information",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 5),
            const Divider(
              height: 2,
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Profile Photo Column
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        company['profileImage'] as String,
                        width: double.infinity,
                         // Adjust the height as needed
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0), // Space between photo and info
                  // Contact Information Column
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              company['name'] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Contact: ${company['contact']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Email: ${company['mail']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Address: ${company['address']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8.0),
                            const Divider(
                              height: 2,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Website: ${company['website']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.facebook,
                                        color: Color(0xFF1877F2),
                                        size: 40, // Adjust the size here
                                      ),
                                      onPressed: () {
                                        // Define the action for the Facebook icon here
                                      },
                                    ),
                                    // Add more icons here if needed
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.instagram,
                                        color:Color(0xFFC13584),
                                        size: 40, // Adjust the size here
                                      ),
                                      onPressed: () {
                                        // Define the action for the Facebook icon here
                                      },
                                    ),
                                    // Add more icons here if needed
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.twitter,
                                        color: Color(0xFF1DA1F2),
                                        size: 40, // Adjust the size here
                                      ),
                                      onPressed: () {
                                        // Define the action for the Facebook icon here
                                      },
                                    ),
                                    // Add more icons here if needed
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.youtube,
                                        color: Color(0xFFFF0000),
                                        size: 40, // Adjust the size here
                                      ),
                                      onPressed: () {
                                        // Define the action for the Facebook icon here
                                      },
                                    ),
                                    // Add more icons here if needed
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.linkedinIn,
                                        color: Color(0xFF0A66C2),
                                        size: 40, // Adjust the size here
                                      ),
                                      onPressed: () {
                                        // Define the action for the Facebook icon here
                                      },
                                    ),
                                    // Add more icons here if needed
                                  ],
                                ),
                              ],
                            ),





                          ],
                        ),
                      ),
                    ),
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
