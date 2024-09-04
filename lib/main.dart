import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmin/pages/logins/main_login.dart';
import 'firebase_options.dart';

void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'EduCareer Admin',
      home: MainLogin(),
    );
  }
}

