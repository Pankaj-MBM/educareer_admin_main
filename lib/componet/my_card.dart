import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyCard extends StatelessWidget {
  final String image;
  final String text;
  final String subtext;
  final String postCount;
  const MyCard({super.key, required this.image, required this.text, required this.subtext, required this.postCount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      width: 165,
      child: Card(
        // color: AppColors.wigthColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                height: 40,
                width: 40,
                child: SvgPicture.asset(image)),
            //  hSpacer(mHeight: 10),
             Text(text),
            //  hSpacer(mHeight: 10),
             Text(subtext),
            //  hSpacer(mHeight: 10),
             Text(postCount)
          ],
        ),
      ),
    );
  }
}
