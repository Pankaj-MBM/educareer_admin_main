import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'DB_config_pages/count_users.dart';
import 'TestimonialSections.dart';
import 'barchart.dart';
import 'footer.dart';
import 'data_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final DataService dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Map<String, int>>(
        stream: dataService.getCounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Dashboard/Home',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Space between heading and separator
                  Divider(
                    color: Colors.grey, // Separator color
                    thickness: 1, // Separator thickness
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    children: [
                      SizedBox(
                        width: 250, // Set the width
                        height: 180, // Set the height
                        child: Card(
                          elevation: 8.0,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.deepOrange,
                                  size: 50,
                                ),
                                Text(
                                  '${data['total_users']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "Total Users",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250, // Set the width
                        height: 180, // Set the height
                        child: Card(
                          elevation: 8.0,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.cyan,
                                  size: 50,
                                ),
                                Text(
                                  '${data['students']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "Students",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250, // Set the width
                        height: 180, // Set the height
                        child: Card(
                          elevation: 8.0,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.green,
                                  size: 50,
                                ),
                                Text(
                                  '${data['job_seekers']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "Job Seekers",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250, // Set the width
                        height: 180, // Set the height
                        child: Card(
                          elevation: 8.0,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.black26,
                                  size: 50,
                                ),
                                Text(
                                  '${data['job_providers']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "Job Providers",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    children: [
                      SizedBox(
                        width: 250, // Set the width
                        height: 160, // Set the height
                        child: Card(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity, // Responsive width
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xff1A237E),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.facebook,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                          "128",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w800
                                          ),
                                        ),
                                        Text(
                                          "Feeds",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                          "35k",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w800
                                          ),
                                        ),
                                        Text(
                                          "Friends",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250, // Set the width
                        height: 160, // Set the height
                        child: Card(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity, // Responsive width
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xff03A9f4),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.twitter,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                          "211K",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w800
                                          ),
                                        ),
                                        Text(
                                          "Followers",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                          "982",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w800
                                          ),
                                        ),
                                        Text(
                                          "Tweets",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250, // Set the width
                        height: 160, // Set the height
                        child: Card(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity, // Responsive width
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xff01579B),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.linkedinIn,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                          "128K",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w800
                                          ),
                                        ),
                                        Text(
                                          "Contacts",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                          "35k",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w800
                                          ),
                                        ),
                                        Text(
                                          "Friends",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250, // Set the width
                        height: 160, // Set the height
                        child: Card(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity, // Responsive width
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xffC62828),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.googlePlusG,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                          "128",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w800
                                          ),
                                        ),
                                        Text(
                                          "Feeds",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 10,),
                                        Text(
                                          "35k",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w800
                                          ),
                                        ),
                                        Text(
                                          "Friends",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        width: double.infinity,
                        height: 400,
                        child: LineChartSample2(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: SizedBox(
                      height: 500,
                      child: Testimonialsections(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 12.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: SizedBox(
                        height: 150,
                        child: FooterPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
