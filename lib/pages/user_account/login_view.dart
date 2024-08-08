import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for input formatters
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:student/componet/my_container.dart';
import 'package:student/componet/my_text_formfild.dart';
import 'package:student/screens/user_account/recove_password_view.dart';
import 'package:student/utils/main_screen.dart';
import 'package:student/utils/ui_color_code.dart';
import 'package:student/utils/ui_helper.dart';

import 'registor_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isOtpLogin = false;

  // Create a StreamController for error animation
  final errorController = StreamController<ErrorAnimationType>.broadcast();

  @override
  void dispose() {
    // Close the error controller when the widget is disposed
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
                color: Colors.black.withOpacity(0.7),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 400, // Set the max width
                    maxHeight: 550, // Set the max height
                  ),
                  child: Card(
                    color: AppColors.wigthColor.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_isOtpLogin) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mobile Number"),
                                SizedBox(height: 10,),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Mobile Number",
                                    hintText: "Enter Mobile Number",
                                    prefixIcon: Icon(Icons.phone),
                                    border: OutlineInputBorder(), // Optional: adds a border to the text field
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ], // Only allow numbers
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      // Add send OTP logic here
                                    },
                                    child: const Text(
                                      "Send OTP",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            PinCodeTextField(
                              length: 6,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              animationType: AnimationType.fade,
                              animationDuration: Duration(milliseconds: 300),
                              errorAnimationController: errorController, // Pass it here
                              onChanged: (value) {
                                setState(() {
                                  var currentText = value;
                                });
                              },
                              appContext: context, // Provide BuildContext here
                            )
                          ] else ...[
                            const MyTextFormField(
                              text: "Email",
                              hintText: "Email",
                              prefixIcon: Icons.email_outlined,
                            ),
                            const MyTextFormField(
                              text: "Password",
                              hintText: "Password",
                              prefixIcon: Icons.lock,
                            ),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!_isOtpLogin) // Only show for email/password login
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecoverPasswordView(),
                                      ),
                                    );
                                  },
                                  child: const Text("Forgot Password"),
                                ),
                            ],
                          ),
                          RoundedButton(
                            width: double.infinity,
                            text: _isOtpLogin ? "Login with OTP" : "Login",
                            onTap: () {
                              if (_isOtpLogin) {
                                // Handle OTP login
                                // Add OTP verification logic here
                              } else {
                                // Handle password login
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(),
                                  ),
                                );
                              }
                            },
                          ),
                          const Divider(
                            color: AppColors.blackColor,
                          ),
                          // const RoundedButton(
                          //   width: double.infinity,
                          //   padding: EdgeInsets.all(10),
                          //   text: "Google Sign In",
                          //   image: Image(
                          //     image: NetworkImage(
                          //       "https://cdn-icons-png.flaticon.com/128/300/300221.png",
                          //     ),
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              wSpace(mWidth: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const RegisterView(),
                                    ),
                                  );
                                },
                                child: const Text("Register"),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isOtpLogin = !_isOtpLogin;
                              });
                            },
                            child: Text(_isOtpLogin
                                ? "Login with Email/Password "
                                : "Login with OTP "),
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
