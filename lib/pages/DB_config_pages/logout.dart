import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logins/main_login.dart';

Future<void> logout(BuildContext context) async {
  // Clear user data from shared preferences or other storage
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear(); // Clear all stored data
     Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const MainLogin()),
        (Route<dynamic> route) => false,
  );
}
