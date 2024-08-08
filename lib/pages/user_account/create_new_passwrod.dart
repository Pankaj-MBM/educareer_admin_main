import 'package:flutter/material.dart';
import 'package:student/componet/my_container.dart';
import 'package:student/componet/my_text_formfild.dart';
import 'package:student/utils/ui_color_code.dart';
import 'package:student/utils/ui_helper.dart';

import 'recove_password_view.dart';
import 'registor_view.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
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
                color:
                    Colors.black.withOpacity(0.7), // Adjust opacity as needed
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 250),
              child: SizedBox(
                height: 600,
                width: 450,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecoverPasswordView(),
                                      ));
                                },
                                child: Text("Forgot Passwrod")),
                          ],
                        ),
                        RoundedButton(
                          width: double.infinity,
                          text: "Login",
                        ),
                        const Divider(
                          color: AppColors.blackColor,
                        ),
                        const RoundedButton(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          text: "Google Sing In",
                          image: Image(
                              image: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/128/300/300221.png")),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have a account"),
                            wSpace(mWidth: 10),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterView(),
                                      ));
                                },
                                child: const Text("Register"))
                          ],
                        )
                      ],
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
