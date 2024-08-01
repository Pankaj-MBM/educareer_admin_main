import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final double height;
  final double widthFactor;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final String text;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final Icon icon;
  final VoidCallback? onTap;

  const MyContainer({
    Key? key,
    this.height = 50.0,
    this.widthFactor = 0.1,
    this.color,
    this.padding,
    this.margin,
    this.decoration,
    required this.text,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.borderRadius = 10.0,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: MediaQuery.of(context).size.width * widthFactor,
        padding: padding,
        margin: margin,
        decoration: decoration ??
            BoxDecoration(
              color: color ?? Colors.blue,
              border: Border.all(color: borderColor!, width: borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 8), // Adds some space between the icon and the text
            Text(text, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
