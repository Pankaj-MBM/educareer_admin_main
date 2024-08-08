import 'package:flutter/material.dart';
import 'package:student/componet/my_container.dart';
import 'package:student/componet/my_text_formfild.dart';
import 'package:student/utils/ui_color_code.dart';
import 'package:student/utils/ui_helper.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
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
              padding: const EdgeInsets.only(left: 150),
              child: SizedBox(
                height: 700,
                width: 450,
                child: Card(
                  color: AppColors.wigthColor.withOpacity(0.2),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Create New Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        MyTextFormField(
                          text: "First Name",
                          hintText: "First Name",
                          prefixIcon: Icons.email_outlined,
                        ),
                        MyTextFormField(
                          text: "Last Name",
                          hintText: "Last Name",
                          prefixIcon: Icons.lock,
                        ),
                        MyTextFormField(
                          text: "Email",
                          hintText: "Email",
                          prefixIcon: Icons.email_outlined,
                        ),
                        MyTextFormField(
                          text: "Password",
                          hintText: "Password",
                          prefixIcon: Icons.lock,
                        ),
                        MyTextFormField(
                          text: "Confirm Password",
                          hintText: "Confirm Password",
                          prefixIcon: Icons.lock,
                        ),
                        Divider(
                          color: AppColors.blackColor,
                        ),
                        RoundedButton(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          text: "Google Sing In",
                          image: Image(
                              image: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/128/300/300221.png")),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 20,
                left: 20,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back),
                      wSpace(mWidth: 6),
                      Text("Go Back")
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
