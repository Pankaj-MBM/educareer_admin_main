
// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'package:flutter/material.dart';

//// ui hight and width space
Widget hSpacer({double mHeight = 20.0}) {
  return SizedBox(
    height: mHeight,
  );
}

Widget wSpace({double mWidth = 18.0}) {
  return SizedBox(
    width: mWidth,
  );
}
/// Custom fonts custom button fonts size forget password
TextStyle textStyleFonts10(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.labelLarge!.copyWith(
    color: colors,
    fontWeight: FontWeight.w500,
    fontSize: 11,
  );
}

/// Custom fonts custom button fonts size forget password
TextStyle textStyleFonts12(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.labelLarge!.copyWith(
    color: colors,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );
}


/// Custom fonts custom button fonts size forget password
TextStyle textStyleFonts13(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.labelLarge!.copyWith(
    color: colors,
    fontWeight: FontWeight.w500,
    fontSize: 13,
  );
}


/// Custom fonts custom button fonts size forget password
TextStyle textStyleFonts14(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.displaySmall!.copyWith(
    color: colors,
    // fontWeight: FontWeight.w500,
    fontSize: 14,
  );
}

TextStyle textStyleFonts14b(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.bodySmall!.copyWith(
    color: colors,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
}

TextStyle textStyleFonts16(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.bodySmall!.copyWith(
    color: colors,
    fontSize: 16,
  );
}

TextStyle textStyleFonts16b(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.bodySmall!.copyWith(
    color: colors,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
}

/// Custom fonts custom button fonts size
TextStyle textStyleFonts18(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context)
      .textTheme
      .headlineMedium!
      .copyWith(color: colors, fontWeight: FontWeight.w500, fontSize: 18);
}

TextStyle textStyleFonts18b(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.labelLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: colors,
      fontSize: 18
  );
}

TextStyle textStyleFonts20(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.labelMedium!.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: colors,
  );
}

/// us Login Page
TextStyle textStyleFonts22(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.titleMedium!.copyWith(
    color: colors,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
}

/// us Login Page , Registrar

TextStyle textStyleFonts24(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context)
      .textTheme
      .headlineMedium!
      .copyWith(color: colors, fontWeight: FontWeight.bold, fontSize: 20);

  // TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);
}

TextStyle textStyleFonts25(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context)
      .textTheme
      .headlineSmall!
      .copyWith(color: colors, fontWeight: FontWeight.bold);
}

TextStyle textStyleFonts28(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context)
      .textTheme
      .headlineMedium!
      .copyWith(color: colors, fontWeight: FontWeight.bold, fontSize: 24);
}

// App Ui Logo Header And Future or Splash Screen
Widget AppLogo({double mHeight = 100.0, double width = 100.0}) {
  return Center(
    child: Container(
      height: mHeight,
      width: width,
      decoration: const BoxDecoration(

        //color: Colors.red,
          image: DecorationImage(
            // colorFilter: ColorFilter.mode(Colors.white, BlendMode.dstATop),
            image: AssetImage(
              "assets/images/logo.png",
            ),
          )),
    ),
  );
}
