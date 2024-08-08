import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../indexpage.dart'; // For input formatters

class MainLogin extends StatefulWidget {
  const MainLogin({super.key});

  @override
  State<MainLogin> createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  bool _isOtpLogin = false;
  final errorController = StreamController<ErrorAnimationType>.broadcast();

  @override
  void dispose() {
    errorController.close();
    super.dispose();
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
                            const MyTextFormField(
                              text: "Email",
                              hintText: "Enter your email",
                              prefixIcon: Icons.email_outlined,
                            ),
                            const MyTextFormField(
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IndexPage(),
                                  ),
                                );
                              } else {
                                // Handle email/password login
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IndexPage(),
                                  ),
                                );
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     const Text("Don't have an account?"),
                          //     SizedBox(width: 10),
                          //     TextButton(
                          //       onPressed: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) =>
                          //             const RegisterView(),
                          //           ),
                          //         );
                          //       },
                          //       child: const Text("Register"),
                          //     ),
                          //   ],
                          // ),
                          TextButton(
                            onPressed: () {
                              setState(() {

                                _isOtpLogin = !_isOtpLogin;
                              });
                            },
                            child: Text(
                              _isOtpLogin
                                  ? "Login with Email/Password": "Login with OTP",
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

// Placeholder widget for MyTextFormField
class MyTextFormField extends StatelessWidget {
  final String text;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;

  const MyTextFormField({
    required this.text,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
// Placeholder widget for RegisterView

