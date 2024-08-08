import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

import 'AppColors.dart';

class Testimonialsections extends StatefulWidget {
  const Testimonialsections({super.key});

  @override
  State<Testimonialsections> createState() => _TestimonialsectionsState();
}

class _TestimonialsectionsState extends State<Testimonialsections> {
  final PageController _pageController = PageController();
  final List<Map<String, String>> _testimonials = [
    {
      'author': 'John Doe',
      'message': 'This is a testimonial from John Doe.',
      'image': 'assets/images/msg2.png', // Replace with actual image path
      'heading': 'Customer Feedback' // Added heading
    },
    {
      'author': 'Jane Smith',
      'message': 'Jane Smith also has something to say.',
      'image': 'assets/images/msg3.png', // Replace with actual image path
      'heading': 'Happy Client' // Added heading
    },
    {
      'author': 'Pankaj parihar',
      'message': 'Jane Smith also has something to say.',
      'image': 'assets/images/new1.JPG', // Replace with actual image path
      'heading': 'Happy Client' // Added heading
    },
    // Add more testimonials here
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= _testimonials.length) {
          _pageController.jumpToPage(0);
        } else {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testimonials and Progress Bar'),
        elevation: 5, // Removes shadow
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: AppColors.mainGridLineColor,
            height: 2.0, // Divider height
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.blueGrey[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Testimonials',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width:MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _testimonials.length,
                          itemBuilder: (context, index) {
                            final testimonial = _testimonials[index];
                            return _buildTestimonial(
                              testimonial['heading']!,
                              testimonial['author']!,
                              testimonial['message']!,
                              testimonial['image']!,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width:10,),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.blueGrey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black54,),

                    ),
                    Divider(
                      color: Colors.grey, // Separator color
                      thickness: 1, // Separator thickness
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity, // Full width of the parent
                      height: 9.0, // Height of the progress bar
                      child: LinearProgressIndicator(
                        color: Colors.blueGrey,
                        value: 0.7, // Example progress value
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('70% completed'),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity, // Full width of the parent
                      height: 9.0, // Height of the progress bar
                      child: LinearProgressIndicator(
                        color: Colors.cyan,
                        value: 0.4, // Example progress value
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('40% completed'),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity, // Full width of the parent
                      height: 9.0, // Height of the progress bar
                      child: LinearProgressIndicator(
                        color: Colors.green,
                        value: 0.9, // Example progress value
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('90% completed'),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity, // Full width of the parent
                      height: 9.0, // Height of the progress bar
                      child: LinearProgressIndicator(
                        value: 0.4, // Example progress value
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('40% completed'),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity, // Full width of the parent
                      height: 9.0, // Height of the progress bar
                      child: LinearProgressIndicator(
                        color: Colors.redAccent,
                        value: 0.2, // Example progress value
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('20% completed'),

                    // Add more progress-related widgets here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonial(String heading, String author, String message, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(maxWidth: 400), // Adjust the max width as needed
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Heading at the top
              Text(
                heading,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              // Image at the top
              CircleAvatar(
                radius: 30, // Adjust size as needed
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(height: 16.0),
              // Content below the image
              Text(
                author,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
