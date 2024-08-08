import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:student/componet/my_container.dart';
import 'package:student/utils/ui_color_code.dart';
import 'package:student/utils/ui_helper.dart';

class RecoverPasswordView extends StatefulWidget {
  const RecoverPasswordView({super.key});

  @override
  State<RecoverPasswordView> createState() => _RecoverPasswordViewState();
}

class _RecoverPasswordViewState extends State<RecoverPasswordView> {
  OtpFieldController otpController = OtpFieldController();

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
                          "Recover Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "Please enter the 6-digit code send to your email ",
                              style: textStyleFonts16(context,
                                  colors: AppColors.wigthColor)),
                          TextSpan(
                              text: "mukeshkachhawah@gmail.com ",
                              style: textStyleFonts16(context,
                                  colors: AppColors.blackColor)),
                          TextSpan(
                              text: "for verification.",
                              style: textStyleFonts16(context,
                                  colors: AppColors.wigthColor))
                        ])),
                        OTPTextField(
                          controller: otpController,
                          length: 5,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 60,
                          style: const TextStyle(fontSize: 17),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.underline,
                          onCompleted: (pin) {
                            print("Completed: " + pin);
                          },
                        ),
                        RoundedButton(
                          text: "Verify OTP",
                          onTap: () {},
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Didn't receive any code?"),
                            wSpace(mWidth: 5),
                            InkWell(
                                onTap: () {}, child: const Text("Resend Again"))
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
