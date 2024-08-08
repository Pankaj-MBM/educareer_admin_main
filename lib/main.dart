import 'package:flutter/material.dart';
import 'package:flutteradmin/pages/indexpage.dart';
import 'package:flutteradmin/pages/logins/main_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainLogin(),
      // home: IndexPage(), // Set IndexPage as the home page
    );
  }
}
