import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UnderWorking extends StatelessWidget {
  const UnderWorking({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Container(
        child: Column(
          children: [
            Lottie.asset(
              'assets/animation/progress.json',
              width: 500,  // Adjust width as needed
              height: 500, // Adjust height as needed
              fit: BoxFit.fill, // Adjust fit as needed
            ),
            Center(
              child: Text("Work in Process...!",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
            ),
          ],
        ),

      ),

    );
  }
}
