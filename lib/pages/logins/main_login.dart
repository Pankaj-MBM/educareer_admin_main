import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../indexpage.dart'; // Make sure this import is correct
import '../profile.dart'; // Import ProfilePage if needed

class MainLogin extends StatefulWidget {
  const MainLogin({super.key});

  @override
  State<MainLogin> createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  bool _isOtpLogin = false;
  final errorController = StreamController<ErrorAnimationType>.broadcast();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    errorController.close();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmailPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Check user credentials in Firestore
      final usersCollection = FirebaseFirestore.instance.collection('educareer-admin');
      final query = await usersCollection
          .where('username', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();
      if (query.docs.isNotEmpty) {
        // Successful login
        final userDocument = query.docs.first;
        final userData = userDocument.data();
        _showErrorSnackbar('Login Success..!', Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IndexPage(userData: userData),
          ),
        );
      } else {
        // Invalid credentials
        print('Invalid username or password');
        _showErrorSnackbar('Invalid username or password', Colors.red);
      }
    } catch (e) {
      print('Error occurred: $e');
      _showErrorSnackbar('An error occurred. Please try again.', Colors.red);
    }
  }

  Future<void> _loginWithOtp() async {
    // Add OTP login logic here
  }

  void _showErrorSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned.fill(
              child: Image.network(
                "https://images.squarespace-cdn.com/content/v1/5ea9b3dc4a1d870f88a99f57/1588639206580-JDMAVS5LF81QCI906YA9/HeaderImage2.jpg",
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.3),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 550,
                  ),
                  child: Card(
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Admin Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_isOtpLogin) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Mobile Number",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  key: ValueKey('mobile-field'), // Unique Key for mobile
                                  controller: _mobileController,
                                  decoration: const InputDecoration(
                                    labelText: "Mobile Number",
                                    hintText: "Enter Mobile Number",
                                    prefixIcon: Icon(Icons.phone),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      // Add send OTP logic here
                                    },
                                    child: const Text(
                                      "Send OTP",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            PinCodeTextField(
                              key: ValueKey('otp-field'), // Unique Key for OTP
                              controller: _otpController,
                              length: 6,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              animationType: AnimationType.fade,
                              animationDuration: const Duration(milliseconds: 300),
                              errorAnimationController: errorController,
                              onChanged: (value) {},
                              appContext: context,
                            )
                          ] else ...[
                            MyTextFormField(
                              key: ValueKey('email-field'), // Unique Key for email
                              controller: _emailController,
                              text: "Email",
                              hintText: "Enter your email",
                              prefixIcon: Icons.email_outlined,
                            ),
                            MyTextFormField(
                              key: ValueKey('password-field'), // Unique Key for password
                              controller: _passwordController,
                              text: "Password",
                              hintText: "Enter your password",
                              prefixIcon: Icons.lock,
                              obscureText: true,
                            ),
                          ],
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () {
                              if (_isOtpLogin) {
                                _loginWithOtp();
                              } else {
                                _loginWithEmailPassword();
                              }
                            },
                            child: Text(
                              _isOtpLogin ? "Login with OTP" : "Login",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isOtpLogin = !_isOtpLogin;
                              });
                            },
                            child: Text(
                              _isOtpLogin
                                  ? "Login with Email/Password" : "Login with OTP",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final String text;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextFormField({
    required Key key,
    required this.text,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: text,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(),
      ),
    );
  }
}
