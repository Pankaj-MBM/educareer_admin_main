import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../componet/header.dart';
import '../../componet/my_card.dart';
import '../../responsive.dart';
import '../../utils/ui_color_code.dart';
import '../../utils/ui_helper.dart';
import 'my_task_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
    late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          children: [
            const Header(),
            hSpacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      topRow(),
                      hSpacer(),
                      svgImage(context),
                      if (Responsive.isMobile(context)) hSpacer(),
                      if (Responsive.isMobile(context))
                        notificationAndCalender(),
                    ],
                  ),
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 2,
                      child: notificationAndCalender(),
                    ),
                ],
              ),
            ),
            futterBar(),
            hSpacer()
          ],
        ),
      ),
    );
  }

  Widget topRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 1000,
          decoration: BoxDecoration(
            color: Colors.lightBlue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior:
                  Clip.none, // Allow the Positioned widget to overflow
              children: [
                Positioned(
                  left: 0,
                  top:
                      -50, // Adjust the position to raise the image above the container
                  child: SizedBox(
                    height: 150,
                    width: 200,
                    child: SvgPicture.asset("assets/svg/find-a-candidate.svg"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    wSpace(), // Adjust the width to make space for the image
                    Text(
                      'Fill your positions now!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Button action
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Find a Candidate',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        hSpacer(),
        hSpacer(),
        Row(
          children: [
            const MyCard(
                image: "assets/svg/job-post.svg",
                text: "Job",
                subtext: "Post",
                postCount: "0"),
            wSpace(mWidth: 10),
            const MyCard(
                image: "assets/svg/candidate-save.svg",
                text: "Candidates",
                subtext: "Saved",
                postCount: "0"),
            wSpace(mWidth: 10),
            const MyCard(
                image: "assets/svg/candidate-invite.svg",
                text: "Candidates",
                subtext: "Invited",
                postCount: "0"),
            wSpace(mWidth: 10),
            const MyCard(
                image: "assets/svg/candidate-sortlisted.svg",
                text: "Candidates",
                subtext: "Shortlisted",
                postCount: "0"),
            wSpace(mWidth: 10),
            const MyCard(
                image: "assets/svg/candidate-selected.svg",
                text: "Candidates",
                subtext: "Selected",
                postCount: "0"),
            wSpace(mWidth: 10),
            const MyCard(
                image: "assets/svg/candidate-on-hold.svg",
                text: "Candidates",
                subtext: "on Hold",
                postCount: "0"),
            wSpace(mWidth: 10),
          ],
        ),
      ],
    );
  }

  Widget svgImage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 300,
            width: 300,
            child: SvgPicture.asset("assets/svg/no-candidate-found.svg")),
        hSpacer(),
        Text(
          "Please post a job to receive candidate suggestions",
          style: textStyleFonts22(context, colors: AppColors.wigthColor),
        ),
        hSpacer(),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: SizedBox(
                    height: 300,
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: SvgPicture.asset(
                                "assets/svg/post-a-job-icon.svg")),
                        Text(
                            "Seems like you do not have sufficient credits remaining to Post a Job. Click below to get more credits."),
                        Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              "Go To Subscription",
                              style: textStyleFonts16b(context,
                                  colors: AppColors.wigthColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text(
                "Post a Job",
                style: textStyleFonts16b(context, colors: AppColors.wigthColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget notificationAndCalender() {
    return Column(
      children: [
        // notification and calender
        Card(
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      children: [
                        Icon(Icons.notifications),
                        wSpace(mWidth: 10),
                        Text("Notification")
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month),
                        wSpace(mWidth: 10),
                        Text("Calendar")
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 300,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    notification(),
                    Center(child: Text("Calendar content here")),
                  ],
                ),
              ),
            ],
          ),
        ),
        hSpacer(),

        /// todo taks
        MyTaskCard()
      ],
    );
  }

  Widget notification() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // assets/svg/notification.svg

        SizedBox(
            height: 50,
            width: 50,
            child: SvgPicture.asset("assets/svg/notification.svg")),
        hSpacer(),

        Text("Notification content here")
      ],
    );
  }

  Widget futterBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image:
                        AssetImage("assets/images/jobs-in-education-logo.png"),
                    height: 60,
                    width: 100,
                  ),
                  Text("Copyright © 2024 | www.jobsineducation.net")
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      TextButton(onPressed: () {}, child: Text("About Us")),
                      TextButton(onPressed: () {}, child: Text("Plans")),
                      TextButton(onPressed: () {}, child: Text("Contact")),
                      TextButton(
                          onPressed: () {}, child: Text("Privacy Police")),
                      TextButton(
                          onPressed: () {}, child: Text("Terms & Conditions")),
                      TextButton(
                          onPressed: () {}, child: Text("Refund Policy")),
                      TextButton(onPressed: () {}, child: Text("Blogs")),
                    ],
                  ),
                  hSpacer(mHeight: 10),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/circle-linkedin-512.webp", // Replace with your image asset path
                        fit: BoxFit.fill,
                        height: 25,
                        width: 25,
                        //   color: AppColors.wigthColor,
                      ),
                      wSpace(mWidth: 10),
                      Image.asset(
                        "assets/images/facebook.png", // Replace with your image asset path
                        fit: BoxFit.fill,
                        height: 25,
                        width: 25,
                        //   color: AppColors.wigthColor,
                      ),
                      wSpace(mWidth: 10),
                      Image.asset(
                        "assets/images/instagram-logo.webp", // Replace with your image asset path
                        fit: BoxFit.fill,
                        height: 35,
                        width: 35,
                        //   color: AppColors.wigthColor,
                      ),
                      wSpace(mWidth: 10),
                      Image.asset(
                        "assets/images/Twitter-Logo.png", // Replace with your image asset path
                        height: 35,
                        width: 35,
                        // color: AppColors.wigthColor,
                      ),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
