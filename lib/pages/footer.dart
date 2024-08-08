import 'package:flutter/material.dart';

class FooterPage extends StatelessWidget {
  const FooterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adjusts size to content
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Copyright © 2018 Designed by flutter.design. All rights reserved.",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  "Develop and design by: Hunarship team",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
