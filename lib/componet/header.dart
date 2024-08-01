import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../controllers/MenuAppController.dart';
import '../responsive.dart';
import '../screens/profile/profile_view.dart';
import '../utils/ui_color_code.dart';
import '../utils/ui_helper.dart';
import 'my_container.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                context.read<MenuAppController>().controlMenu();
              },
            ),
          if (!Responsive.isMobile(context))
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileView(),
                        ),
                      );
                    },
                    child: Text(
                      "Home",
                      style: textStyleFonts18(context,
                          colors: AppColors.wigthColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Contact Us",
                      style: textStyleFonts18(context,
                          colors: AppColors.wigthColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "FAQ's",
                      style: textStyleFonts18(context,
                          colors: AppColors.wigthColor),
                    ),
                  ),
                  wSpace(),
                  const MyContainer(
                    text: "Candidate",
                    icon: Icon(
                      Icons.search,
                      color: AppColors.blackColor,
                    ),
                    color: AppColors.bgButtonColor,
                  ),
                  wSpace(),
                  const MyContainer(
                    text: "Find Job",
                    icon: Icon(
                      Icons.search,
                      color: AppColors.blackColor,
                    ),
                    color: AppColors.bgButtonColor,
                  ),
                  wSpace(),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/svg/wallet.svg"),
                      SizedBox(width: 20),
                      Text(
                        "50k",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                wSpace(),
                wSpace(mWidth: 10),
                Text(
                  "T.B.P. Public School",
                  style: textStyleFonts18(context, colors: AppColors.wigthColor),
                  maxLines: 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
